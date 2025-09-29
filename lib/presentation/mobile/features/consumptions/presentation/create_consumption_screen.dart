import 'package:electricity/core/utils/extensions/toast.dart';
import 'package:electricity/core/utils/formatters/meter_reading_input_formatter.dart';
import 'package:electricity/core/utils/helpers/focus_remove_wrapper.dart';
import 'package:electricity/presentation/shared/bloc/dashboard/dashboard_bloc.dart';
import 'package:electricity/presentation/shared/widgets/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateConsumptionScreen extends StatefulWidget {
  const CreateConsumptionScreen({super.key, required this.cycleId});
  final String cycleId;

  @override
  State<CreateConsumptionScreen> createState() =>
      _CreateConsumptionScreenState();
}

class _CreateConsumptionScreenState extends State<CreateConsumptionScreen> {
  final _meterReadingController = TextEditingController();

  @override
  void dispose() {
    _meterReadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardState>(
      listener: (context, state) async {
        if (state is ConsumptionCreationFailed) {
          context.showFlushbar(
            state.error,
            backgroundColor: FlushbarColor.warning,
          );
          return;
        }
        if (state is ConsumptionCreatedSuccessfully) {
          await context.showFlushbar('Consumption created successfully');
          if (context.mounted) context.pop();
          return;
        }
      },
      child: FocusRemoveWrapper(
        child: Scaffold(
          appBar: AppBar(title: const Text('Create Consumption')),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                spacing: 20,
                children: [
                  TextFormField(
                    controller: _meterReadingController,
                    decoration: const InputDecoration(
                      labelText: 'Meter Reading',
                      hintText: 'Ex: 12345',
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: const [MeterReadingTextInputFormatter()],
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  AppActions(
                    mainAxisAlignment: MainAxisAlignment.end,
                    onCancel: context.pop,
                    onSubmit: () {
                      final double? meterReading = double.tryParse(
                        _meterReadingController.text.trim(),
                      );

                      final String cycleId = widget.cycleId;

                      context.read<DashboardBloc>().add(
                        CreateConsumptionEvent(
                          cycleId: cycleId,
                          meterReading: meterReading!,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
