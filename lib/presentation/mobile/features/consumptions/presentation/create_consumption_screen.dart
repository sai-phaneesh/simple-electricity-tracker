import 'package:collection/collection.dart';
import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/core/utils/extensions/toast.dart';
import 'package:electricity/core/utils/formatters/meter_reading_input_formatter.dart';
import 'package:electricity/core/utils/helpers/focus_remove_wrapper.dart';
import 'package:electricity/presentation/shared/widgets/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateConsumptionScreen extends ConsumerStatefulWidget {
  const CreateConsumptionScreen({super.key, required this.cycleId});
  final String cycleId;

  @override
  ConsumerState<CreateConsumptionScreen> createState() =>
      _CreateConsumptionScreenState();
}

class _CreateConsumptionScreenState
    extends ConsumerState<CreateConsumptionScreen> {
  final _meterReadingController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _showMessage(
    String message, {
    FlushbarColor background = FlushbarColor.info,
  }) async {
    if (!context.mounted) return;
    await context.showFlushbar(message, backgroundColor: background);
  }

  @override
  void dispose() {
    _meterReadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final readingsAsync = ref.watch(readingsForSelectedCycleStreamProvider);
    final latestReading = readingsAsync.maybeWhen(
      data: (readings) => readings.sortedBy((r) => r.date).lastOrNull,
      orElse: () => null,
    );

    return FocusRemoveWrapper(
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Consumption')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _meterReadingController,
                  decoration: const InputDecoration(
                    labelText: 'Meter reading',
                    hintText: 'Ex: 12345',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  inputFormatters: const [MeterReadingTextInputFormatter()],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 12),
                if (latestReading != null)
                  Text(
                    'Last recorded reading: ${latestReading.meterReading}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                const SizedBox(height: 12),
                if (_isSubmitting)
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                AppActions(
                  mainAxisAlignment: MainAxisAlignment.end,
                  onCancel: _isSubmitting ? null : context.pop,
                  onSubmit: _isSubmitting
                      ? null
                      : () async {
                          final input = _meterReadingController.text.trim();
                          final meterReadingValue = double.tryParse(input);

                          if (meterReadingValue == null) {
                            await _showMessage(
                              'Enter a valid meter reading',
                              background: FlushbarColor.warning,
                            );
                            return;
                          }

                          if (!context.mounted) return;
                          setState(() => _isSubmitting = true);

                          try {
                            final cycle = await ref
                                .read(cyclesRepositoryProvider)
                                .getCycleById(widget.cycleId);

                            if (cycle == null) {
                              await _showMessage(
                                'Selected cycle not found',
                                background: FlushbarColor.error,
                              );
                              return;
                            }

                            final meterReading = meterReadingValue.round();

                            final readingsRepo = ref.read(
                              electricityReadingsRepositoryProvider,
                            );
                            final latest = await readingsRepo
                                .getLatestReadingForCycle(cycle.id);
                            final previousReading =
                                latest?.meterReading ??
                                cycle.initialMeterReading;

                            if (meterReading <= previousReading) {
                              await _showMessage(
                                'Meter reading must be greater than '
                                '$previousReading',
                                background: FlushbarColor.warning,
                              );
                              return;
                            }

                            final unitsConsumed =
                                meterReading - previousReading;
                            final totalCost =
                                unitsConsumed * cycle.pricePerUnit;

                            await ref
                                .read(electricityReadingsControllerProvider)
                                .createReading(
                                  houseId: cycle.houseId,
                                  cycleId: cycle.id,
                                  date: DateTime.now(),
                                  meterReading: meterReading,
                                  unitsConsumed: unitsConsumed,
                                  totalCost: totalCost,
                                );

                            if (!context.mounted) return;
                            context.showFlushbar('Consumption recorded');
                            if (!context.mounted) return;
                            context.pop();
                          } on ArgumentError catch (error) {
                            await _showMessage(
                              error.message,
                              background: FlushbarColor.warning,
                            );
                          } catch (error) {
                            await _showMessage(
                              'Failed to save consumption',
                              background: FlushbarColor.error,
                            );
                          } finally {
                            if (mounted) {
                              setState(() => _isSubmitting = false);
                            }
                          }
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
