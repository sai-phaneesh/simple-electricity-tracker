import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/core/utils/extensions/toast.dart';
import 'package:electricity/core/utils/formatters/meter_reading_input_formatter.dart';
import 'package:electricity/core/utils/formatters/number_formatter.dart';
import 'package:electricity/domain/entities/cycle.dart';
import 'package:electricity/domain/entities/electricity_reading.dart';
import 'package:electricity/presentation/shared/widgets/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Shared form widget for creating and editing consumption readings.
///
/// This widget handles the form UI and validation logic, while the parent
/// screens handle data fetching and error states.
class ConsumptionForm extends ConsumerStatefulWidget {
  const ConsumptionForm({
    required this.cycle,
    required this.sortedReadings,
    this.editingReading,
    super.key,
  });

  /// The current cycle for the consumption.
  final Cycle cycle;

  /// All readings in the cycle, sorted by date (oldest first).
  final List<ElectricityReading> sortedReadings;

  /// The reading being edited. If null, creates a new reading.
  final ElectricityReading? editingReading;

  @override
  ConsumerState<ConsumptionForm> createState() => _ConsumptionFormState();
}

class _ConsumptionFormState extends ConsumerState<ConsumptionForm> {
  final _formKey = GlobalKey<FormState>();
  final _meterReadingController = TextEditingController();
  bool _isSubmitting = false;
  String? _previewUnits;
  String? _previewCost;

  bool get isEditing => widget.editingReading != null;

  @override
  void initState() {
    super.initState();
    if (widget.editingReading != null) {
      _meterReadingController.text = widget.editingReading!.meterReading
          .toString();
    }
  }

  @override
  void didUpdateWidget(ConsumptionForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update form if editing reading changed (e.g., data refreshed)
    if (widget.editingReading != oldWidget.editingReading &&
        widget.editingReading != null &&
        _meterReadingController.text.isEmpty) {
      _meterReadingController.text = widget.editingReading!.meterReading
          .toString();
    }
  }

  @override
  void dispose() {
    _meterReadingController.dispose();
    super.dispose();
  }

  Future<void> _showMessage(
    String message, {
    FlushbarColor background = FlushbarColor.info,
  }) async {
    if (!context.mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      context.showFlushbar(message, backgroundColor: background);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cycle = widget.cycle;
    final sortedReadings = widget.sortedReadings;

    // Calculate previous and next reading values
    final currentReadingIndex = isEditing
        ? sortedReadings.indexWhere((r) => r.id == widget.editingReading!.id)
        : -1;

    double previousReadingValue;
    if (isEditing && currentReadingIndex > 0) {
      previousReadingValue =
          sortedReadings[currentReadingIndex - 1].meterReading;
    } else if (isEditing && currentReadingIndex == 0) {
      previousReadingValue = cycle.initialMeterReading;
    } else {
      previousReadingValue = sortedReadings.isNotEmpty
          ? sortedReadings.last.meterReading
          : cycle.initialMeterReading;
    }

    final nextReadingValue = (isEditing && currentReadingIndex >= 0)
        ? (currentReadingIndex < sortedReadings.length - 1
              ? sortedReadings[currentReadingIndex + 1].meterReading
              : null)
        : null;

    final previousReadingLabel = isEditing
        ? 'Previous Reading'
        : (sortedReadings.isNotEmpty ? 'Latest Reading' : 'Initial Reading');

    final formattedPreviousReading = AppNumberFormatter.formatMeterReading(
      previousReadingValue,
    );
    final formattedNextReading = nextReadingValue != null
        ? AppNumberFormatter.formatMeterReading(nextReadingValue)
        : null;
    final nextReadingDisplay = formattedNextReading ?? '';
    final rangeHintText = nextReadingValue != null
        ? 'Must be between $formattedPreviousReading and $nextReadingDisplay'
        : 'Must be greater than $formattedPreviousReading';
    final rangeHelperText = nextReadingValue != null
        ? 'Enter a value between $formattedPreviousReading and $nextReadingDisplay'
        : 'Enter a value greater than $formattedPreviousReading';

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cycle Info Card
            _buildCycleInfoCard(
              context,
              cycle: cycle,
              previousReadingLabel: previousReadingLabel,
              formattedPreviousReading: formattedPreviousReading,
              formattedNextReading: formattedNextReading,
              nextReadingValue: nextReadingValue,
            ),
            const SizedBox(height: 24),

            // Meter Reading Input
            TextFormField(
              controller: _meterReadingController,
              onChanged: (value) => _updatePreview(
                value,
                previousReadingValue,
                nextReadingValue,
                cycle.pricePerUnit,
              ),
              decoration: InputDecoration(
                labelText: 'New Meter Reading',
                hintText: rangeHintText,
                border: const OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                helperText: rangeHelperText,
                helperMaxLines: 2,
              ),
              inputFormatters: const [MeterReadingTextInputFormatter()],
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => _validateReading(
                value,
                previousReadingValue,
                nextReadingValue,
                formattedPreviousReading,
                nextReadingDisplay,
              ),
            ),
            const SizedBox(height: 12),

            // Live calculation preview
            if (_previewUnits != null && _previewCost != null)
              _buildPreviewCard(context),
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
                  : () => _handleSubmit(cycle, previousReadingValue),
            ),
          ],
        ),
      ),
    );
  }

  void _updatePreview(
    String value,
    double previousReadingValue,
    double? nextReadingValue,
    double pricePerUnit,
  ) {
    final inputValue = double.tryParse(value.trim());
    if (inputValue != null &&
        inputValue > previousReadingValue &&
        (nextReadingValue == null || inputValue < nextReadingValue)) {
      final units = inputValue - previousReadingValue;
      final cost = units * pricePerUnit;
      setState(() {
        _previewUnits = AppNumberFormatter.formatNumber(units);
        _previewCost = AppNumberFormatter.formatCurrency(cost);
      });
    } else {
      setState(() {
        _previewUnits = null;
        _previewCost = null;
      });
    }
  }

  String? _validateReading(
    String? value,
    double previousReadingValue,
    double? nextReadingValue,
    String formattedPreviousReading,
    String nextReadingDisplay,
  ) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a meter reading';
    }

    final reading = double.tryParse(value.trim());
    if (reading == null) {
      return 'Please enter a valid number';
    }

    if (reading <= previousReadingValue) {
      return 'Must be greater than $formattedPreviousReading';
    }

    if (nextReadingValue != null && reading >= nextReadingValue) {
      return 'Must be less than $nextReadingDisplay';
    }

    return null;
  }

  Future<void> _handleSubmit(Cycle cycle, double previousReadingValue) async {
    if (!_formKey.currentState!.validate()) return;

    final input = _meterReadingController.text.trim();
    final meterReadingValue = double.tryParse(input)!;

    if (!context.mounted) return;
    setState(() => _isSubmitting = true);

    try {
      final unitsConsumed = meterReadingValue - previousReadingValue;
      final totalCost = unitsConsumed * cycle.pricePerUnit;

      if (isEditing) {
        await ref
            .read(electricityReadingsControllerProvider)
            .updateReading(
              id: widget.editingReading!.id,
              meterReading: meterReadingValue,
              unitsConsumed: unitsConsumed,
              totalCost: totalCost,
              date: DateTime.now(),
            );
      } else {
        await ref
            .read(electricityReadingsControllerProvider)
            .createReading(
              houseId: cycle.houseId,
              cycleId: cycle.id,
              date: DateTime.now(),
              meterReading: meterReadingValue,
              unitsConsumed: unitsConsumed,
              totalCost: totalCost,
            );
      }

      if (!mounted) return;
      if (context.mounted) context.pop();
    } on ArgumentError catch (error) {
      if (mounted) setState(() => _isSubmitting = false);
      await _showMessage(error.message, background: FlushbarColor.warning);
    } catch (error) {
      if (mounted) setState(() => _isSubmitting = false);
      await _showMessage(
        'Failed to save consumption',
        background: FlushbarColor.error,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _buildCycleInfoCard(
    BuildContext context, {
    required Cycle cycle,
    required String previousReadingLabel,
    required String formattedPreviousReading,
    required String? formattedNextReading,
    required double? nextReadingValue,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryContainer,
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
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(context, 'Cycle', cycle.name),
          const SizedBox(height: 8),
          _buildInfoRow(context, 'Max Units', '${cycle.maxUnits} units'),
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            'Price/Unit',
            AppNumberFormatter.formatCurrency(cycle.pricePerUnit),
          ),
          const Divider(height: 24),
          _buildInfoRow(
            context,
            previousReadingLabel,
            formattedPreviousReading,
            isHighlighted: true,
          ),
          if (nextReadingValue != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              'Next Reading',
              formattedNextReading!,
              isHighlighted: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreviewCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Preview:', style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Units: $_previewUnits',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                'Cost: $_previewCost',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
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
