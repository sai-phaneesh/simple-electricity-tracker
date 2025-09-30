import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/core/utils/extensions/toast.dart';
import 'package:electricity/core/utils/formatters/meter_reading_input_formatter.dart';
import 'package:electricity/core/utils/helpers/focus_remove_wrapper.dart';
import 'package:electricity/presentation/shared/widgets/actions.dart';
import 'package:electricity/presentation/shared/widgets/text_fields/date_picker_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateCycleScreen extends ConsumerStatefulWidget {
  const CreateCycleScreen({this.cycleId, super.key});

  final String? cycleId;

  @override
  ConsumerState<CreateCycleScreen> createState() => _CreateCycleScreenState();
}

class _CreateCycleScreenState extends ConsumerState<CreateCycleScreen> {
  final _nameController = TextEditingController();
  final _meterReadingController = TextEditingController();
  final _maxUnitsController = TextEditingController();
  final _pricePerUnitController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCycleData();
  }

  Future<void> _loadCycleData() async {
    if (widget.cycleId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final cycle = await ref
          .read(cyclesRepositoryProvider)
          .getCycleById(widget.cycleId!);

      if (cycle != null && mounted) {
        setState(() {
          _nameController.text = cycle.name;
          _meterReadingController.text = cycle.initialMeterReading.toString();
          _maxUnitsController.text = cycle.maxUnits.toString();
          _pricePerUnitController.text = cycle.pricePerUnit.toStringAsFixed(2);
          _startDate = cycle.startDate;
          _endDate = cycle.endDate;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        context.showFlushbar(
          'Failed to load cycle data',
          backgroundColor: FlushbarColor.error,
        );
      }
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
    final isEditMode = widget.cycleId != null;

    return FocusRemoveWrapper(
      child: Scaffold(
        appBar: AppBar(title: Text(isEditMode ? 'Edit Cycle' : 'Add Cycle')),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // If there's no selected house, show a dropdown to pick one
                      // (but not in edit mode, since house can't be changed)
                      if (!isEditMode)
                        Builder(
                          builder: (context) {
                            final selectedHouse = ref
                                .watch(selectedHouseProvider)
                                .valueOrNull;
                            if (selectedHouse != null) {
                              return const SizedBox.shrink();
                            }

                            final housesAsync = ref.watch(housesStreamProvider);
                            return housesAsync.when(
                              loading: () => const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              error: (err, st) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                ),
                                child: Center(
                                  child: Text('Failed to load houses: $err'),
                                ),
                              ),
                              data: (houses) {
                                if (houses.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                    ),
                                    child: Text(
                                      'No houses available. Create one from the drawer to continue.',
                                    ),
                                  );
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      labelText: 'Select house',
                                      border: OutlineInputBorder(),
                                    ),
                                    items: houses
                                        .map(
                                          (h) => DropdownMenuItem(
                                            value: h.id,
                                            child: Text(h.name),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      if (value == null) return;
                                      ref
                                          .read(
                                            selectedHouseIdProvider.notifier,
                                          )
                                          .setHouse(value);
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),

                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUnfocus,
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                hintText: 'Ex: Jan-24',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            AppDatepicker(
                              labelText: 'Start Date',
                              value: _startDate,
                              // In edit mode, allow selecting any past date
                              // In create mode, use default (year 2000)
                              firstDate: isEditMode ? DateTime(2000) : null,
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
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
                            AppDatepicker(
                              labelText: 'End Date',
                              value: _endDate,
                              firstDate: _startDate,
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
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
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUnfocus,
                              controller: _meterReadingController,
                              decoration: const InputDecoration(
                                labelText: 'Initial meter reading',
                                hintText: 'Ex: 12345',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
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
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUnfocus,
                              controller: _maxUnitsController,
                              decoration: const InputDecoration(
                                labelText: 'Max units',
                                hintText: 'Ex: 200',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
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
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUnfocus,
                              controller: _pricePerUnitController,
                              decoration: const InputDecoration(
                                labelText: 'Price per unit',
                                hintText: 'Ex: 7.50',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
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
                            AppActions(
                              spacing: 15,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              onCancel: context.pop,
                              onSubmit: () async {
                                final isValid =
                                    _formKey.currentState?.validate() ?? false;
                                if (!isValid) {
                                  context.showFlushbar(
                                    'Please complete all fields',
                                    backgroundColor: FlushbarColor.warning,
                                  );
                                  return;
                                }

                                final selectedHouse = ref
                                    .read(selectedHouseProvider)
                                    .valueOrNull;
                                if (!isEditMode && selectedHouse == null) {
                                  context.showFlushbar(
                                    'Please select or create a house first',
                                    backgroundColor: FlushbarColor.warning,
                                  );
                                  return;
                                }

                                final initialReading = double.parse(
                                  _meterReadingController.text.trim(),
                                );
                                final maxUnits = int.parse(
                                  _maxUnitsController.text.trim(),
                                );
                                final pricePerUnit = double.parse(
                                  _pricePerUnitController.text.trim(),
                                );

                                if (isEditMode) {
                                  // Update existing cycle
                                  final existingCycle = await ref
                                      .read(cyclesRepositoryProvider)
                                      .getCycleById(widget.cycleId!);

                                  if (existingCycle == null) {
                                    if (context.mounted) {
                                      context.showFlushbar(
                                        'Cycle not found',
                                        backgroundColor: FlushbarColor.error,
                                      );
                                    }
                                    return;
                                  }

                                  // Check if price or initial reading is changing
                                  final priceChanged =
                                      pricePerUnit !=
                                      existingCycle.pricePerUnit;
                                  final initialReadingChanged =
                                      initialReading !=
                                      existingCycle.initialMeterReading;
                                  final willRecalculate =
                                      priceChanged || initialReadingChanged;

                                  await ref
                                      .read(cyclesControllerProvider)
                                      .updateCycle(
                                        id: widget.cycleId!,
                                        name: _nameController.text.trim(),
                                        startDate: _startDate!,
                                        endDate: _endDate!,
                                        initialMeterReading: initialReading,
                                        maxUnits: maxUnits,
                                        pricePerUnit: pricePerUnit,
                                        isActive: existingCycle.isActive,
                                      );

                                  if (context.mounted) {
                                    await context.showFlushbar(
                                      willRecalculate
                                          ? 'Cycle updated and consumptions recalculated'
                                          : 'Cycle updated successfully',
                                    );
                                    if (context.mounted) context.pop();
                                  }
                                } else {
                                  // Create new cycle
                                  await ref
                                      .read(cyclesControllerProvider)
                                      .createCycle(
                                        houseId: selectedHouse!.id,
                                        name: _nameController.text.trim(),
                                        startDate: _startDate!,
                                        endDate: _endDate!,
                                        initialMeterReading: initialReading,
                                        maxUnits: maxUnits,
                                        pricePerUnit: pricePerUnit,
                                      );

                                  if (context.mounted) {
                                    await context.showFlushbar(
                                      'Cycle created successfully',
                                    );
                                    if (context.mounted) context.pop();
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
