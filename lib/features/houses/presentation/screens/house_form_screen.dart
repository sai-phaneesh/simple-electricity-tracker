import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:electricity/shared/widgets/responsive_layout.dart';
import 'package:electricity/features/houses/presentation/bloc/houses_bloc.dart';
import 'package:provider/provider.dart';
import 'package:electricity/features/houses/presentation/form/house_form_model.dart';
import 'package:electricity/core/widgets/flutter_toast_x.dart';

const List<String> _houseTypes = [
  'Apartment',
  'House',
  'Townhouse',
  'Condo',
  'Studio',
  'Villa',
  'Other',
];

const List<String> _ownershipTypes = [
  'Owned',
  'Rented',
  'Family Property',
  'Shared',
];

/// Screen for adding a new house
class AddHouseScreen extends StatefulWidget {
  const AddHouseScreen({super.key});

  @override
  State<AddHouseScreen> createState() => _AddHouseScreenState();
}

class _AddHouseScreenState extends State<AddHouseScreen> {
  HouseFormModel? _model;
  bool _createdLocalModel = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_model != null) return;

    // Try to obtain a provided HouseFormModel; if none exists, create one
    try {
      _model = Provider.of<HouseFormModel>(context, listen: false);
    } catch (_) {
      _createdLocalModel = true;
      _model = HouseFormModel();
    }
  }

  @override
  void dispose() {
    if (_createdLocalModel) {
      _model?.dispose();
    }
    super.dispose();
  }

  Future<void> _createHouse() async {
    // Validate form
    _model!.validateNow();
    if (!_model!.formKey.currentState!.validate() || !_model!.isValid.value) {
      FlutterToastX.warning('Please fix the form errors before submitting.');
      return;
    }

    // Mark submitting and show loading
    _model!.isSubmitting.value = true;

    try {
      // Create the house via BLoC
      context.read<HousesBloc>().add(
        AddHouse(
          name: _model!.name.text.trim(),
          address: _model!.address.text.trim(),
          houseType: _model!.houseType ?? 'House',
          ownershipType: _model!.ownershipType ?? 'Owned',
          notes: _model!.notes.text.trim().isEmpty
              ? null
              : _model!.notes.text.trim(),
          meterNumber: _model!.meterNumber.text.trim(),
          defaultPricePerUnit:
              double.tryParse(_model!.pricePerUnit.text) ?? 0.0,
          freeUnitsPerMonth: double.tryParse(_model!.freeUnits.text) ?? 0.0,
          warningLimitUnits:
              double.tryParse(_model!.warningLimit.text) ?? 1000.0,
        ),
      );

      if (mounted) {
        FlutterToastX.success('House created successfully!');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        FlutterToastX.error('Failed to create house: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        _model!.isSubmitting.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return HouseFormScaffold(
      title: 'Add New House',
      model: _model!,
      houseTypes: _houseTypes,
      ownershipTypes: _ownershipTypes,
      onSubmit: _createHouse,
      submitButtonText: 'Create House',
      showDeleteButton: false,
    );
  }
}

/// Screen for editing an existing house
class EditHouseScreen extends StatefulWidget {
  final String houseId;

  const EditHouseScreen({super.key, required this.houseId});

  @override
  State<EditHouseScreen> createState() => _EditHouseScreenState();
}

class _EditHouseScreenState extends State<EditHouseScreen> {
  HouseFormModel? _model;
  bool _createdLocalModel = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_model != null) return;

    // Try to obtain a provided HouseFormModel; if none exists, create one
    try {
      _model = Provider.of<HouseFormModel>(context, listen: false);
    } catch (_) {
      _createdLocalModel = true;
      _model = HouseFormModel();
    }

    _loadHouseData();
  }

  @override
  void dispose() {
    if (_createdLocalModel) {
      _model?.dispose();
    }
    super.dispose();
  }

  void _loadHouseData() async {
    final house = await context.read<HousesBloc>().getHouseById(widget.houseId);
    if (house != null && mounted) {
      // Populate the model's controllers and simple fields
      _model!.houseId = house.id;
      _model!.name.text = house.name;
      _model!.address.text = house.address;
      _model!.notes.text = house.notes ?? '';
      _model!.houseType = house.houseType;
      _model!.ownershipType = house.ownershipType;
      _model!.meterNumber.text = house.meterNumber;
      _model!.pricePerUnit.text = house.defaultPricePerUnit.toString();
      _model!.freeUnits.text = house.freeUnitsPerMonth.toString();
      _model!.warningLimit.text = house.warningLimitUnits.toString();
      _model!.validateNow();
      setState(() {});
    }
  }

  Future<void> _updateHouse() async {
    // Validate form
    _model!.validateNow();
    if (!_model!.formKey.currentState!.validate() || !_model!.isValid.value) {
      FlutterToastX.warning('Please fix the form errors before submitting.');
      return;
    }

    // Mark submitting
    _model!.isSubmitting.value = true;

    try {
      final existingHouse = await context.read<HousesBloc>().getHouseById(
        widget.houseId,
      );

      if (existingHouse == null) {
        FlutterToastX.error('House not found. It may have been deleted.');
        if (mounted) context.pop();
        return;
      }

      if (mounted) {
        final updatedHouse = existingHouse.copyWith(
          name: _model!.name.text.trim(),
          address: _model!.address.text.trim(),
          houseType: _model!.houseType ?? 'House',
          ownershipType: _model!.ownershipType ?? 'Owned',
          notes: _model!.notes.text.trim().isEmpty
              ? null
              : _model!.notes.text.trim(),
          meterNumber: _model!.meterNumber.text.trim(),
          defaultPricePerUnit:
              double.tryParse(_model!.pricePerUnit.text) ?? 0.0,
          freeUnitsPerMonth: double.tryParse(_model!.freeUnits.text) ?? 0.0,
          warningLimitUnits:
              double.tryParse(_model!.warningLimit.text) ?? 1000.0,
        );

        context.read<HousesBloc>().add(UpdateHouse(updatedHouse));
        FlutterToastX.success('House updated successfully!');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        FlutterToastX.error('Failed to update house: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        _model!.isSubmitting.value = false;
      }
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.delete_forever, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete House'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this house? This will also delete all associated electricity cycles and readings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteHouse();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteHouse() {
    try {
      context.read<HousesBloc>().add(DeleteHouse(widget.houseId));
      FlutterToastX.success('House deleted successfully!');
      if (mounted) context.pop();
    } catch (e) {
      FlutterToastX.error('Failed to delete house: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return HouseFormScaffold(
      title: 'Edit House',
      model: _model!,
      houseTypes: _houseTypes,
      ownershipTypes: _ownershipTypes,
      onSubmit: _updateHouse,
      submitButtonText: 'Update House',
      showDeleteButton: true,
      onDeleteRequested: _showDeleteConfirmation,
    );
  }
}

/// Legacy screen kept for compatibility - routes should use AddHouseScreen/EditHouseScreen instead
@Deprecated('Use AddHouseScreen or EditHouseScreen instead')
class HouseFormScreen extends StatelessWidget {
  final String? houseId;

  const HouseFormScreen({super.key, this.houseId});

  @override
  Widget build(BuildContext context) {
    if (houseId == null) {
      return const AddHouseScreen();
    } else {
      return EditHouseScreen(houseId: houseId!);
    }
  }
}

// Scaffold + responsive layout wrapper
class HouseFormScaffold extends StatelessWidget {
  final String title;
  final HouseFormModel model;
  final List<String> houseTypes;
  final List<String> ownershipTypes;
  final VoidCallback onSubmit;
  final String submitButtonText;
  final bool showDeleteButton;
  final VoidCallback? onDeleteRequested;

  const HouseFormScaffold({
    super.key,
    required this.title,
    required this.model,
    required this.houseTypes,
    required this.ownershipTypes,
    required this.onSubmit,
    required this.submitButtonText,
    this.showDeleteButton = false,
    this.onDeleteRequested,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (showDeleteButton && onDeleteRequested != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDeleteRequested,
            ),
        ],
      ),
      body: ResponsiveConstrainedBox(
        child: Form(
          key: model.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              // Responsive form content
              Expanded(
                child: ResponsiveLayout(
                  mobile: ResponsivePadding(
                    child: ListView(
                      children: [
                        HouseFormFields(
                          model: model,
                          houseTypes: houseTypes,
                          ownershipTypes: ownershipTypes,
                        ),
                      ],
                    ),
                  ),
                  desktop: ResponsivePadding(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 32),
                                  _DesktopTwoColumnFields(
                                    model: model,
                                    houseTypes: houseTypes,
                                    ownershipTypes: ownershipTypes,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Single shared actions at bottom
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
                ),
                child: ResponsivePadding(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: HouseFormActions(
                      model: model,
                      submitButtonText: submitButtonText,
                      onSubmit: onSubmit,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fields widget
class HouseFormFields extends StatefulWidget {
  final HouseFormModel model;
  final List<String> houseTypes;
  final List<String> ownershipTypes;

  const HouseFormFields({
    super.key,
    required this.model,
    required this.houseTypes,
    required this.ownershipTypes,
  });

  @override
  State<HouseFormFields> createState() => _HouseFormFieldsState();
}

class _HouseFormFieldsState extends State<HouseFormFields> {
  @override
  Widget build(BuildContext context) {
    final m = widget.model;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: m.name,
          decoration: const InputDecoration(
            labelText: 'House Name *',
            hintText: 'e.g., Main House, Apartment 2B',
            prefixIcon: Icon(Icons.home),
          ),
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Please enter a house name'
              : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: m.address,
          decoration: const InputDecoration(
            labelText: 'Address *',
            hintText: 'Full address or description',
            prefixIcon: Icon(Icons.location_on),
          ),
          maxLines: 2,
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Please enter an address'
              : null,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: m.houseType,
          decoration: const InputDecoration(
            labelText: 'House Type *',
            prefixIcon: Icon(Icons.home_work),
          ),
          items: widget.houseTypes
              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
          onChanged: (value) => setState(() => m.houseType = value),
          validator: (value) =>
              value == null ? 'Please select a house type' : null,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: m.ownershipType,
          decoration: const InputDecoration(
            labelText: 'Ownership Type *',
            prefixIcon: Icon(Icons.key),
          ),
          items: widget.ownershipTypes
              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
          onChanged: (value) => setState(() => m.ownershipType = value),
          validator: (value) =>
              value == null ? 'Please select ownership type' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: m.notes,
          decoration: const InputDecoration(
            labelText: 'Notes (Optional)',
            hintText: 'Additional information about this house',
            prefixIcon: Icon(Icons.note),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        Text(
          'Electricity Tracking',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: m.meterNumber,
          decoration: const InputDecoration(
            labelText: 'Meter Number *',
            hintText: 'e.g., MTR-123456',
            prefixIcon: Icon(Icons.electrical_services),
          ),
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Please enter meter number'
              : null,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: m.pricePerUnit,
                decoration: const InputDecoration(
                  labelText: 'Price per Unit (₹)',
                  hintText: '5.00',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final price = double.tryParse(value);
                    if (price == null || price < 0) {
                      return 'Enter valid price';
                    }
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: m.freeUnits,
                decoration: const InputDecoration(
                  labelText: 'Free Units/Month',
                  hintText: '100',
                  prefixIcon: Icon(Icons.loyalty),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final units = double.tryParse(value);
                    if (units == null || units < 0) {
                      return 'Enter valid units';
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: m.warningLimit,
          decoration: const InputDecoration(
            labelText: 'Warning Limit (Units)',
            hintText: '1000',
            prefixIcon: Icon(Icons.warning_amber),
            helperText: 'Get notified when consumption exceeds this limit',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final limit = double.tryParse(value);
              if (limit == null || limit < 0) {
                return 'Enter valid limit';
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}

// Actions row widget
class HouseFormActions extends StatelessWidget {
  final HouseFormModel model;
  final String submitButtonText;
  final VoidCallback onSubmit;

  const HouseFormActions({
    super.key,
    required this.model,
    required this.submitButtonText,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: model.isSubmitting,
            builder: (context, isSubmitting, _) {
              return ValueListenableBuilder<bool>(
                valueListenable: model.isValid,
                builder: (context, isValid, child) {
                  final enabled = isValid && !isSubmitting;
                  return ElevatedButton(
                    onPressed: enabled ? onSubmit : null,
                    child: isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(submitButtonText),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// Desktop specific grouped layout
class _DesktopTwoColumnFields extends StatelessWidget {
  final HouseFormModel model;
  final List<String> houseTypes;
  final List<String> ownershipTypes;

  const _DesktopTwoColumnFields({
    required this.model,
    required this.houseTypes,
    required this.ownershipTypes,
  });

  @override
  Widget build(BuildContext context) {
    final m = model;
    return LayoutBuilder(
      builder: (context, constraints) {
        final double gap = 24;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column - Basic Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Basic Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: m.name,
                    decoration: const InputDecoration(
                      labelText: 'House Name *',
                      hintText: 'e.g., Main House, Apartment 2B',
                      prefixIcon: Icon(Icons.home),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? 'Please enter a house name'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: m.address,
                    decoration: const InputDecoration(
                      labelText: 'Address *',
                      hintText: 'Full address or description',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    maxLines: 2,
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? 'Please enter an address'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: m.houseType,
                    decoration: const InputDecoration(
                      labelText: 'House Type *',
                      prefixIcon: Icon(Icons.home_work),
                    ),
                    items: houseTypes
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                    onChanged: (value) => m.houseType = value,
                    validator: (value) =>
                        value == null ? 'Please select a house type' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: m.ownershipType,
                    decoration: const InputDecoration(
                      labelText: 'Ownership Type *',
                      prefixIcon: Icon(Icons.key),
                    ),
                    items: ownershipTypes
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                    onChanged: (value) => m.ownershipType = value,
                    validator: (value) =>
                        value == null ? 'Please select ownership type' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: m.notes,
                    decoration: const InputDecoration(
                      labelText: 'Notes (Optional)',
                      hintText: 'Additional information about this house',
                      prefixIcon: Icon(Icons.note),
                    ),
                    maxLines: 5,
                  ),
                ],
              ),
            ),
            SizedBox(width: gap),
            // Right Column - Electricity Tracking
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Electricity Tracking',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: m.meterNumber,
                    decoration: const InputDecoration(
                      labelText: 'Meter Number *',
                      hintText: 'e.g., MTR-123456',
                      prefixIcon: Icon(Icons.electrical_services),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? 'Please enter meter number'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: m.pricePerUnit,
                          decoration: const InputDecoration(
                            labelText: 'Price per Unit (₹)',
                            hintText: '5.00',
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final price = double.tryParse(value);
                              if (price == null || price < 0) {
                                return 'Enter valid price';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: m.freeUnits,
                          decoration: const InputDecoration(
                            labelText: 'Free Units/Month',
                            hintText: '100',
                            prefixIcon: Icon(Icons.loyalty),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final units = double.tryParse(value);
                              if (units == null || units < 0) {
                                return 'Enter valid units';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: m.warningLimit,
                    decoration: const InputDecoration(
                      labelText: 'Warning Limit (Units)',
                      hintText: '1000',
                      prefixIcon: Icon(Icons.warning_amber),
                      helperText:
                          'Get notified when consumption exceeds this limit',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final limit = double.tryParse(value);
                        if (limit == null || limit < 0) {
                          return 'Enter valid limit';
                        }
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
