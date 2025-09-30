import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/core/utils/extensions/theme.dart';
import 'package:electricity/data/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CycleSummaryCard extends ConsumerWidget {
  const CycleSummaryCard({super.key});

  static final _dateFormatter = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleAsync = ref.watch(selectedCycleProvider);
    final readings = ref
        .watch(readingsForSelectedCycleStreamProvider)
        .maybeWhen(
          data: (value) => value,
          orElse: () => const <ElectricityReading>[],
        );

    return cycleAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, stackTrace) {
        // Intentionally ignore stack trace; expose consistent function signature.
        stackTrace;
        return const SizedBox.shrink();
      },
      data: (cycle) {
        if (cycle == null) {
          return const SizedBox.shrink();
        }

        final totalUnits = readings.fold<int>(
          0,
          (sum, reading) => sum + reading.unitsConsumed,
        );
        final totalCost = readings.fold<double>(
          0,
          (sum, reading) => sum + reading.totalCost,
        );
        final durationDays =
            cycle.endDate.difference(cycle.startDate).inDays + 1;

        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.onSurface.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      cycle.name,
                      style: context.theme.textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '($durationDays day${durationDays == 1 ? '' : 's'})',
                    style: context.theme.textTheme.bodySmall,
                  ),
                ],
              ),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _SummaryChip(label: 'Units', value: '$totalUnits'),
                  _SummaryChip(
                    label: 'Cost',
                    value: '₹${totalCost.toStringAsFixed(2)}',
                  ),
                  _SummaryChip(
                    label: 'Price / unit',
                    value: '₹${cycle.pricePerUnit.toStringAsFixed(2)}',
                  ),
                  _SummaryChip(
                    label: 'Meter start',
                    value: '${cycle.initialMeterReading}',
                  ),
                  _SummaryChip(label: 'Max units', value: '${cycle.maxUnits}'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _dateFormatter.format(cycle.startDate),
                    style: context.theme.textTheme.bodyMedium,
                  ),
                  Text(
                    _dateFormatter.format(cycle.endDate),
                    style: context.theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelSmall),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.titleSmall),
        ],
      ),
    );
  }
}
