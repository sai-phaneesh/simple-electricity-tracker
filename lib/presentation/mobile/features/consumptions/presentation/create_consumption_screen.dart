import 'package:collection/collection.dart';
import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/core/utils/extensions/toast.dart';
import 'package:electricity/core/utils/formatters/meter_reading_input_formatter.dart';
import 'package:electricity/core/utils/formatters/number_formatter.dart';
import 'package:electricity/core/utils/helpers/focus_remove_wrapper.dart';
import 'package:electricity/presentation/shared/widgets/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateConsumptionScreen extends ConsumerStatefulWidget {
  const CreateConsumptionScreen({super.key});

  @override
  ConsumerState<CreateConsumptionScreen> createState() =>
      _CreateConsumptionScreenState();
}

class _CreateConsumptionScreenState
    extends ConsumerState<CreateConsumptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _meterReadingController = TextEditingController();
  bool _isSubmitting = false;
  String? _previewUnits;
  String? _previewCost;

  @override
  void initState() {
    super.initState();
  }

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
    final cycleAsync = ref.watch(selectedCycleProvider);
    final readingsAsync = ref.watch(readingsForSelectedCycleStreamProvider);
    final latestReading = readingsAsync.maybeWhen(
      data: (readings) => readings.sortedBy((r) => r.date).lastOrNull,
      orElse: () => null,
    );

    return FocusRemoveWrapper(
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Consumption')),
        body: cycleAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Error loading cycle: $error')),
          data: (cycle) {
            if (cycle == null) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No cycle selected. Please select a cycle first.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final previousReading =
                latestReading?.meterReading ?? cycle.initialMeterReading;

            return SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Cycle Info Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Cycle Information',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow(context, 'Cycle', cycle.name),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              context,
                              'Max Units',
                              '${cycle.maxUnits} units',
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              context,
                              'Price/Unit',
                              AppNumberFormatter.formatCurrency(
                                cycle.pricePerUnit,
                              ),
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(
                              context,
                              latestReading != null
                                  ? 'Latest Reading'
                                  : 'Initial Reading',
                              AppNumberFormatter.formatMeterReading(
                                previousReading,
                              ),
                              isHighlighted: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Meter Reading Input
                      TextFormField(
                        controller: _meterReadingController,
                        onChanged: (value) {
                          final inputValue = double.tryParse(value.trim());
                          if (inputValue != null &&
                              inputValue > previousReading) {
                            final units = inputValue - previousReading;
                            final cost = units * cycle.pricePerUnit;
                            setState(() {
                              _previewUnits = AppNumberFormatter.formatNumber(
                                units,
                              );
                              _previewCost = AppNumberFormatter.formatCurrency(
                                cost,
                              );
                            });
                          } else {
                            setState(() {
                              _previewUnits = null;
                              _previewCost = null;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'New Meter Reading',
                          hintText: 'Must be greater than $previousReading',
                          border: const OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          helperText:
                              'Enter a value greater than $previousReading',
                          helperMaxLines: 2,
                        ),
                        inputFormatters: const [
                          MeterReadingTextInputFormatter(),
                        ],
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a meter reading';
                          }

                          final reading = double.tryParse(value.trim());
                          if (reading == null) {
                            return 'Please enter a valid number';
                          }

                          if (reading <= previousReading) {
                            return 'Must be greater than $previousReading';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Live calculation preview
                      if (_previewUnits != null && _previewCost != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Preview:',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Units: $_previewUnits',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Cost: $_previewCost',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                final input = _meterReadingController.text
                                    .trim();
                                final meterReadingValue = double.tryParse(
                                  input,
                                )!;

                                if (!context.mounted) return;
                                setState(() => _isSubmitting = true);

                                try {
                                  final meterReading = meterReadingValue;

                                  final unitsConsumed =
                                      meterReading - previousReading;
                                  final totalCost =
                                      unitsConsumed * cycle.pricePerUnit;

                                  await ref
                                      .read(
                                        electricityReadingsControllerProvider,
                                      )
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
            color: isHighlighted ? Theme.of(context).colorScheme.primary : null,
            fontSize: isHighlighted ? 16 : null,
          ),
        ),
      ],
    );
  }
}
