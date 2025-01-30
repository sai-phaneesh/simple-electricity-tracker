import 'package:electricity/bloc/dashboard_bloc.dart';
import 'package:electricity/utils/extensions/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CycleSummaryCard extends StatelessWidget {
  const CycleSummaryCard({super.key});

  static final _formatter = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    final selectedCycle = context.watch<DashboardBloc>().selectedCycle;

    if (selectedCycle == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.onSurface.withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 10,
            children: [
              Flexible(
                child: Text(
                  selectedCycle.name,
                  style: context.theme.textTheme.titleLarge,
                ),
              ),
              Text(
                "(${selectedCycle.durationInDays} day${selectedCycle.durationInDays == 1 ? '' : 's'})",
                style: context.theme.textTheme.bodySmall,
              ),
            ],
          ),
          Text(
            "${selectedCycle.totalConsumptions} units",
            style: context.theme.textTheme.titleLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatter.format(selectedCycle.startDate),
                style: context.theme.textTheme.bodyMedium,
              ),
              Text(
                _formatter.format(selectedCycle.endDate),
                style: context.theme.textTheme.bodyMedium,
              ),
            ],
          )
        ],
      ),
    );
  }
}
