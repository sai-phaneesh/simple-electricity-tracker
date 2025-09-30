import 'package:electricity/core/utils/extensions/theme.dart';
import 'package:electricity/core/utils/formatters/number_formatter.dart';
import 'package:electricity/data/database/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConsumptionCard extends StatelessWidget {
  const ConsumptionCard({
    required this.reading,
    required this.index,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final ElectricityReading reading;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static final _dateFormatter = DateFormat('dd-MM-yyyy');
  static final _timeFormatter = DateFormat('hh:mm a');

  String _getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      return _dateFormatter.format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Index badge
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: context.theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$index',
                  style: context.theme.textTheme.labelLarge?.copyWith(
                    color: context.theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Main content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meter reading
                  Text(
                    // '${AppNumberFormatter.formatMeterReading(reading.meterReading)} kWh',
                    AppNumberFormatter.formatMeterReading(reading.meterReading),
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: context.theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getRelativeDate(reading.date),
                        style: context.theme.textTheme.bodySmall?.copyWith(
                          color: context.theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Time
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: context.theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _timeFormatter.format(reading.date),
                        style: context.theme.textTheme.bodySmall?.copyWith(
                          color: context.theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Stats section
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Units consumed
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${AppNumberFormatter.formatNumber(reading.unitsConsumed)} units',
                    style: context.theme.textTheme.labelSmall?.copyWith(
                      color: context.theme.colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // Total cost
                Text(
                  AppNumberFormatter.formatCurrency(reading.totalCost),
                  style: context.theme.textTheme.titleSmall?.copyWith(
                    color: context.theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 8),

            // More options button
            _MoreOptionsButton(onEdit: onEdit, onDelete: onDelete),
          ],
        ),
      ),
    );
  }
}

class _MoreOptionsButton extends StatelessWidget {
  const _MoreOptionsButton({required this.onEdit, required this.onDelete});

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_ConsumptionAction>(
      icon: Icon(
        Icons.more_vert,
        color: context.theme.colorScheme.onSurfaceVariant,
      ),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (action) {
        switch (action) {
          case _ConsumptionAction.edit:
            onEdit();
            break;
          case _ConsumptionAction.delete:
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _ConsumptionAction.edit,
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
          value: _ConsumptionAction.delete,
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

enum _ConsumptionAction { edit, delete }
