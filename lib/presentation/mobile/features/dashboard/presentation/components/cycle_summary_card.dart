import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/core/utils/extensions/theme.dart';
import 'package:electricity/core/utils/formatters/number_formatter.dart';
import 'package:electricity/data/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

        final totalUnits = readings.fold<double>(
          0,
          (sum, reading) => sum + reading.unitsConsumed,
        );
        final totalCost = readings.fold<double>(
          0,
          (sum, reading) => sum + reading.totalCost,
        );
        final durationDays =
            cycle.endDate.difference(cycle.startDate).inDays + 1;

        // Calculate daily average
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final cycleStart = DateTime(
          cycle.startDate.year,
          cycle.startDate.month,
          cycle.startDate.day,
        );
        final cycleEnd = DateTime(
          cycle.endDate.year,
          cycle.endDate.month,
          cycle.endDate.day,
        );

        final daysPassed = today.isBefore(cycleStart)
            ? 0
            : (today.isAfter(cycleEnd)
                  ? durationDays
                  : today.difference(cycleStart).inDays + 1);
        final dailyAverage = daysPassed > 0 ? totalUnits / daysPassed : 0.0;
        final remainingUnits = cycle.maxUnits - totalUnits;

        // Calculate days remaining (inclusive of today and end date)
        final daysRemaining = today.isAfter(cycleEnd)
            ? 0
            : (today.isBefore(cycleStart)
                  ? durationDays
                  : cycleEnd.difference(today).inDays + 1);

        final dailyLimit = daysRemaining > 0
            ? remainingUnits / daysRemaining
            : 0.0;
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
                  const SizedBox(width: 8),
                  _CycleMenuButton(cycleId: cycle.id, cycleName: cycle.name),
                ],
              ),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _SummaryChip(
                    label: 'Units',
                    value:
                        '${AppNumberFormatter.formatNumber(totalUnits)}/${AppNumberFormatter.formatUnits(cycle.maxUnits)}',
                    isHighlighted: totalUnits > cycle.maxUnits,
                  ),
                  _SummaryChip(
                    label: 'Daily Avg',
                    value:
                        '${AppNumberFormatter.formatNumber(dailyAverage)} units',
                  ),
                  _SummaryChip(
                    label: 'Daily Limit',
                    value:
                        '${AppNumberFormatter.formatNumber(dailyLimit)} units',
                    isWarning: dailyLimit < dailyAverage && daysRemaining > 0,
                  ),
                  _SummaryChip(
                    label: 'Cost',
                    value: AppNumberFormatter.formatCurrency(totalCost),
                  ),
                  _SummaryChip(
                    label: 'Price / unit',
                    value: AppNumberFormatter.formatCurrency(
                      cycle.pricePerUnit,
                    ),
                  ),
                  _SummaryChip(
                    label: 'Meter start',
                    value: AppNumberFormatter.formatMeterReading(
                      cycle.initialMeterReading,
                    ),
                  ),
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
                    _dateFormatter.format(now),
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      color: context.theme.colorScheme.primary,
                    ),
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
  const _SummaryChip({
    required this.label,
    required this.value,
    this.isHighlighted = false,
    this.isWarning = false,
  });

  final String label;
  final String value;
  final bool isHighlighted;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine background and text color based on state
    Color backgroundColor;
    Color? textColor;

    if (isHighlighted) {
      backgroundColor = theme.colorScheme.error.withValues(alpha: 0.12);
      textColor = theme.colorScheme.error;
    } else if (isWarning) {
      backgroundColor = theme.colorScheme.tertiary.withValues(alpha: 0.12);
      textColor = theme.colorScheme.tertiary;
    } else {
      backgroundColor = theme.colorScheme.primary.withValues(alpha: 0.08);
      textColor = null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: textColor),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: textColor,
              fontWeight: isHighlighted || isWarning ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _CycleMenuButton extends ConsumerWidget {
  const _CycleMenuButton({required this.cycleId, required this.cycleName});

  final String cycleId;
  final String cycleName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<_CycleAction>(
      icon: Icon(
        Icons.more_vert,
        color: context.theme.colorScheme.onSurfaceVariant,
      ),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (action) async {
        switch (action) {
          case _CycleAction.edit:
            context.pushNamed(
              'edit-cycle',
              pathParameters: {'cycleId': cycleId},
            );
            break;
          case _CycleAction.delete:
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Cycle?'),
                content: Text(
                  'Are you sure you want to delete "$cycleName"? This will also delete all associated readings. This action cannot be undone.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: context.theme.colorScheme.error,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );

            if (confirmed == true && context.mounted) {
              try {
                await ref.read(cyclesControllerProvider).deleteCycle(cycleId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cycle "$cycleName" deleted'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete cycle: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            }
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _CycleAction.edit,
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: 20,
                color: context.theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
              const Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: _CycleAction.delete,
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                size: 20,
                color: context.theme.colorScheme.error,
              ),
              const SizedBox(width: 12),
              Text(
                'Delete',
                style: TextStyle(color: context.theme.colorScheme.error),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum _CycleAction { edit, delete }
