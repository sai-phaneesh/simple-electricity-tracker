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
  const CreateCycleScreen({super.key});

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
    return FocusRemoveWrapper(
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Cycle')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
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
                      AppDatepicker(
                        labelText: 'Start Date',
                        value: _startDate,
                        onChange: (value) {
                          if (value == null) return;
                          setState(() {
                            _startDate = value;
                            if (_startDate != null &&
                                _endDate != null &&
                                _startDate!.isAfter(_endDate!)) {
                              _endDate = null;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      AppDatepicker(
                        labelText: 'End Date',
                        value: _endDate,
                        firstDate: _startDate,
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        onChange: (value) {
                          if (value == null) return;
                          setState(() {
                            _endDate = value;
                          });
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
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                      AppActions(
                        spacing: 15,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        onCancel: context.pop,
                        onSubmit: () async {
                          final isValid =
                              _formKey.currentState?.validate() ?? false;
                          if (!isValid ||
                              _startDate == null ||
                              _endDate == null) {
                            context.showFlushbar(
                              'Please complete all fields',
                              backgroundColor: FlushbarColor.warning,
                            );
                            return;
                          }

                          final selectedHouse = ref
                              .read(selectedHouseProvider)
                              .valueOrNull;
                          if (selectedHouse == null) {
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

                          await ref
                              .read(cyclesControllerProvider)
                              .createCycle(
                                houseId: selectedHouse.id,
                                name: _nameController.text.trim(),
                                startDate: _startDate!,
                                endDate: _endDate!,
                                initialMeterReading: initialReading.round(),
                                maxUnits: maxUnits,
                                pricePerUnit: pricePerUnit,
                              );

                          if (context.mounted) {
                            await context.showFlushbar(
                              'Cycle created successfully',
                            );
                            if (context.mounted) context.pop();
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
