import 'package:electricity/bloc/dashboard_bloc.dart';
import 'package:electricity/components/actions.dart';
import 'package:electricity/components/text_fields/date_picker_textfield.dart';
import 'package:electricity/utils/extensions/navigation.dart';
import 'package:electricity/utils/extensions/toast.dart';
import 'package:electricity/utils/helpers/focus_remove_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCycleScreen extends StatefulWidget {
  const CreateCycleScreen({super.key});

  @override
  State<CreateCycleScreen> createState() => _CreateCycleScreenState();
}

class _CreateCycleScreenState extends State<CreateCycleScreen> {
  final _nameController = TextEditingController();
  final _meterReadingController = TextEditingController();
  final _maxUnitsController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _meterReadingController.dispose();
    _maxUnitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardState>(
      listener: (context, state) async {
        if (state is CycleCreationFailed) {
          context.showFlushbar(
            state.error,
            backgroundColor: FlushbarColor.warning,
          );
          return;
        }
        if (state is CycleCreatedSuccessfully) {
          await context.showFlushbar('Cycle created successfully');
          if (context.mounted) context.pop();
          return;
        }
      },
      child: FocusRemoveWrapper(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Cycle'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      spacing: 20,
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
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        AppDatepicker(
                          labelText: 'Start Date',
                          value: _startDate,
                          onChange: (value) {
                            if (value == null) return;
                            setState(() {
                              _startDate = value;
                              if (_startDate
                                  .isStartDateAfterEndDate(_endDate)) {
                                _endDate = null;
                              }
                            });
                          },
                        ),
                        AppDatepicker(
                          labelText: 'End Date',
                          value: _endDate,
                          firstDate: _startDate,
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                          onChange: (value) {
                            if (value == null) return;
                            setState(() {
                              _endDate = value;
                            });
                          },
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUnfocus,
                          controller: _meterReadingController,
                          decoration: const InputDecoration(
                            labelText: 'Initial Readings',
                            hintText: 'Ex: 12345',
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the meter reading';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUnfocus,
                          controller: _maxUnitsController,
                          decoration: const InputDecoration(
                            labelText: 'Max Units',
                            hintText: 'Ex: 200',
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the max units';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 50),
                        AppActions(
                          spacing: 15,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          onCancel: context.pop,
                          onSubmit: () {
                            final validate =
                                _formKey.currentState?.validate() ?? false;
                            if (!validate) return;
                            final name = _nameController.text.trim();
                            final initialReading = double.tryParse(
                                _meterReadingController.text.trim());
                            final maxUnits = double.tryParse(
                                _maxUnitsController.text.trim());

                            context.showFlushbar('Please fill all the fields');

                            context.read<DashboardBloc>().add(
                                  CreateCycleEvent(
                                    startDate: _startDate!,
                                    endDate: _endDate!,
                                    name: name,
                                    meterReading: initialReading!,
                                    maxUnits: maxUnits!,
                                  ),
                                );
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
      ),
    );
  }

  // bool _validateForm() {
  //   final name = _nameController.text.trim();

  //   final meterReading = double.tryParse(_meterReadingController.text.trim());
  //   final maxUnits = double.tryParse(_maxUnitsController.text.trim());

  //   if (name.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Name cannot be empty'),
  //       ),
  //     );
  //     return false;
  //   }
  // }

  // void _prompt(String message) =>
  //     context.showFlushbar(message, backgroundColor: FlushbarColor.warning);
}

extension on DateTime? {
  bool isStartDateAfterEndDate(DateTime? endDate) {
    if (this == null || endDate == null) return false;
    return this!.isAfter(endDate);
  }
}
