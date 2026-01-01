import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/core/utils/extensions/toast.dart';
import 'package:electricity/core/utils/formatters/meter_reading_input_formatter.dart';
import 'package:electricity/domain/entities/cycle.dart';
import 'package:electricity/domain/entities/house.dart';
import 'package:electricity/presentation/shared/widgets/actions.dart';
import 'package:electricity/presentation/shared/widgets/text_fields/date_picker_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Shared form widget for creating and editing cycles.
///
/// This widget handles the form UI and validation logic, while the parent
/// screens handle data fetching and error states.
class CycleForm extends ConsumerStatefulWidget {
  const CycleForm({
    required this.selectedHouse,
    this.editingCycle,
    this.showHouseSelector = false,
    super.key,
  });

  /// The house this cycle belongs to.
  final House selectedHouse;

  /// The cycle being edited. If null, creates a new cycle.
  final Cycle? editingCycle;

  /// Whether to show a house selector dropdown (for create mode when no house pre-selected).
  final bool showHouseSelector;

  @override
  ConsumerState<CycleForm> createState() => _CycleFormState();
}

class _CycleFormState extends ConsumerState<CycleForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _meterReadingController = TextEditingController();
  final _maxUnitsController = TextEditingController();
  final _pricePerUnitController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSubmitting = false;

  bool get isEditing => widget.editingCycle != null;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.editingCycle != null) {
      final cycle = widget.editingCycle!;
      _nameController.text = cycle.name;
      _meterReadingController.text = cycle.initialMeterReading.toString();
      _maxUnitsController.text = cycle.maxUnits.toString();
      _pricePerUnitController.text = cycle.pricePerUnit.toStringAsFixed(2);
      _startDate = cycle.startDate;
      _endDate = cycle.endDate;
    }
  }

  @override
  void didUpdateWidget(CycleForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-initialize if editing cycle changed
    if (widget.editingCycle != oldWidget.editingCycle &&
        widget.editingCycle != null) {
      _initializeForm();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _meterReadingController.dispose();
    _maxUnitsController.dispose();
    _pricePerUnitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // House info card (read-only in edit mode)
            _buildHouseInfoCard(context),
            const SizedBox(height: 20),

            // Cycle name
            TextFormField(
              autovalidateMode: AutovalidateMode.onUnfocus,
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Ex: Jan-24',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Start date
            AppDatepicker(
              labelText: 'Start Date',
              value: _startDate,
              firstDate: isEditing ? DateTime(2000) : null,
              lastDate: DateTime.now().add(const Duration(days: 365)),
              onChange: (value) {
                setState(() {
                  _startDate = value;
                  if (_startDate != null &&
                      _endDate != null &&
                      _startDate!.isAfter(_endDate!)) {
                    _endDate = null;
                  }
                });
              },
              autovalidateMode: AutovalidateMode.onUnfocus,
              validator: (value) {
                if (value == null) {
                  return 'Please select a start date';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // End date
            AppDatepicker(
              labelText: 'End Date',
              value: _endDate,
              firstDate: _startDate,
              lastDate: DateTime.now().add(const Duration(days: 365)),
              onChange: (value) {
                setState(() {
                  _endDate = value;
                });
              },
              autovalidateMode: AutovalidateMode.onUnfocus,
              validator: (value) {
                if (value == null) {
                  return 'Please select an end date';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Initial meter reading
            TextFormField(
              autovalidateMode: AutovalidateMode.onUnfocus,
              controller: _meterReadingController,
              decoration: InputDecoration(
                labelText: 'Initial meter reading',
                hintText: 'Ex: 12345',
                border: const OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                helperText: isEditing
                    ? 'Changing this will recalculate all consumption readings'
                    : null,
                helperMaxLines: 2,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: const [
                MeterReadingTextInputFormatter(decimalRange: 2),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the meter reading';
                }
                return double.tryParse(value.trim()) == null
                    ? 'Enter a valid number'
                    : null;
              },
            ),
            const SizedBox(height: 20),

            // Max units
            TextFormField(
              autovalidateMode: AutovalidateMode.onUnfocus,
              controller: _maxUnitsController,
              decoration: const InputDecoration(
                labelText: 'Max units',
                hintText: 'Ex: 200',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the max units';
                }
                return int.tryParse(value.trim()) == null
                    ? 'Enter a valid whole number'
                    : null;
              },
            ),
            const SizedBox(height: 20),

            // Price per unit
            TextFormField(
              autovalidateMode: AutovalidateMode.onUnfocus,
              controller: _pricePerUnitController,
              decoration: InputDecoration(
                labelText: 'Price per unit',
                hintText: 'Ex: 7.50',
                border: const OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                helperText: isEditing
                    ? 'Changing this will recalculate all consumption costs'
                    : null,
                helperMaxLines: 2,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the price per unit';
                }
                return double.tryParse(value.trim()) == null
                    ? 'Enter a valid number'
                    : null;
              },
            ),
            const SizedBox(height: 40),

            // Recalculation warning for edit mode
            if (isEditing) _buildRecalculationWarning(context),

            if (_isSubmitting)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Center(child: CircularProgressIndicator()),
              ),

            AppActions(
              spacing: 15,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              onCancel: _isSubmitting ? null : context.pop,
              onSubmit: _isSubmitting ? null : _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHouseInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.home_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'House',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  widget.selectedHouse.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecalculationWarning(BuildContext context) {
    final existingCycle = widget.editingCycle!;
    final currentInitialReading = double.tryParse(
      _meterReadingController.text.trim(),
    );
    final currentPricePerUnit = double.tryParse(
      _pricePerUnitController.text.trim(),
    );

    final willRecalculate =
        (currentInitialReading != null &&
            currentInitialReading != existingCycle.initialMeterReading) ||
        (currentPricePerUnit != null &&
            currentPricePerUnit != existingCycle.pricePerUnit);

    if (!willRecalculate) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.tertiaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calculate_outlined,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Saving will recalculate units and costs for all consumption readings in this cycle.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      context.showFlushbar(
        'Please complete all fields',
        backgroundColor: FlushbarColor.warning,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final initialReading = double.parse(_meterReadingController.text.trim());
      final maxUnits = int.parse(_maxUnitsController.text.trim());
      final pricePerUnit = double.parse(_pricePerUnitController.text.trim());

      if (isEditing) {
        final existingCycle = widget.editingCycle!;

        // Check if we'll be recalculating
        final priceChanged = pricePerUnit != existingCycle.pricePerUnit;
        final initialReadingChanged =
            initialReading != existingCycle.initialMeterReading;
        final willRecalculate = priceChanged || initialReadingChanged;

        await ref
            .read(cyclesControllerProvider)
            .updateCycle(
              id: existingCycle.id,
              name: _nameController.text.trim(),
              startDate: _startDate!,
              endDate: _endDate!,
              initialMeterReading: initialReading,
              maxUnits: maxUnits,
              pricePerUnit: pricePerUnit,
              isActive: existingCycle.isActive,
            );

        if (!mounted) return;
        await context.showFlushbar(
          willRecalculate
              ? 'Cycle updated and consumptions recalculated'
              : 'Cycle updated successfully',
        );
        if (!mounted) return;
        context.pop();
      } else {
        await ref
            .read(cyclesControllerProvider)
            .createCycle(
              houseId: widget.selectedHouse.id,
              name: _nameController.text.trim(),
              startDate: _startDate!,
              endDate: _endDate!,
              initialMeterReading: initialReading,
              maxUnits: maxUnits,
              pricePerUnit: pricePerUnit,
            );

        if (!mounted) return;
        await context.showFlushbar('Cycle created successfully');
        if (!mounted) return;
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        context.showFlushbar(
          'Failed to save cycle: ${e.toString()}',
          backgroundColor: FlushbarColor.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
