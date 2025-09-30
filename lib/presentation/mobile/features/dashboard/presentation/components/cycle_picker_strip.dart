import 'dart:math' as math;

import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/data/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CyclePickerStrip extends ConsumerWidget {
  const CyclePickerStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedHouseAsync = ref.watch(selectedHouseProvider);

    return selectedHouseAsync.when(
      loading: () => const _ShimmerLoadingStrip(),
      error: (error, stackTrace) {
        stackTrace;
        return SizedBox(
          height: 140,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Unable to load houses.\n$error',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
      data: (selectedHouse) {
        if (selectedHouse == null) {
          return const SizedBox(
            height: 140,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Create or select a house from the drawer to begin tracking cycles.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final cyclesAsync = ref.watch(cyclesForSelectedHouseStreamProvider);
        final selectedCycleId = ref.watch(selectedCycleIdProvider);

        return cyclesAsync.when(
          loading: () => const _ShimmerLoadingStrip(),
          error: (error, stackTrace) {
            stackTrace;
            return SizedBox(
              height: 140,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Failed to load cycles for ${selectedHouse.name}.\n$error',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
          data: (cycles) {
            // If there are no cycles, show an inline message next to the
            // AddCycleButton so the user sees the prompt instead of an empty
            // scroller.
            if (cycles.isEmpty) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AddCycleButton(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Text(
                          'No cycles yet for ${selectedHouse.name}. Tap the + card to add one.',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            // Build the list of cycle cards with separators.
            final cardChildren = <Widget>[];
            for (var i = 0; i < cycles.length; i++) {
              final cycle = cycles[i];
              cardChildren.add(
                CycleCard(
                  key: ValueKey(cycle.id),
                  cycle: cycle,
                  isSelected: cycle.id == selectedCycleId,
                  onTap: () {
                    ref
                        .read(selectedCycleIdProvider.notifier)
                        .setCycle(cycle.id);
                  },
                ),
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AddCycleButton(),
                const SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(right: 16),
                    scrollDirection: Axis.horizontal,
                    child: Row(spacing: 10, children: cardChildren),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class AddCycleButton extends ConsumerWidget {
  const AddCycleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedHouse = ref.watch(selectedHouseProvider).value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          minimumSize: const Size(0, 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        onPressed: () {
          if (selectedHouse == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Please create or select a house before adding a cycle.',
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
                backgroundColor: theme.colorScheme.errorContainer,
              ),
            );
            return;
          }
          context.push('/create-cycle');
        },
        child: Icon(Icons.add, color: theme.colorScheme.primary),
      ),
    );
  }
}

class CycleCard extends StatelessWidget {
  const CycleCard({
    super.key,
    required this.cycle,
    required this.isSelected,
    required this.onTap,
  });

  final Cycle cycle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Use Material button variants so the widget looks like an
    // OutlinedButton when not selected and an ElevatedButton when selected.
    final ButtonStyle commonStyle = ButtonStyle(
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      ),
      minimumSize: WidgetStateProperty.all(const Size(0, 0)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      textStyle: WidgetStateProperty.all(theme.textTheme.titleMedium),
    );

    if (isSelected) {
      return FilledButton(
        style: commonStyle.merge(
          FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            elevation: 0,
          ),
        ),
        onPressed: onTap,
        child: Text(
          cycle.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onPrimary,
          ),
        ),
      );
    }

    return OutlinedButton(
      style: commonStyle.merge(
        OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(color: colorScheme.outlineVariant, width: 1.5),
        ),
      ),
      onPressed: onTap,
      child: Text(
        cycle.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium,
      ),
    );
  }
}

class _ShimmerLoadingStrip extends StatefulWidget {
  const _ShimmerLoadingStrip();

  @override
  State<_ShimmerLoadingStrip> createState() => _ShimmerLoadingStripState();
}

class _ShimmerLoadingStripState extends State<_ShimmerLoadingStrip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.surfaceContainerHighest.withValues(
      alpha: 0.4,
    );
    final highlightColor =
        Color.lerp(
          baseColor,
          theme.colorScheme.primary.withValues(alpha: 0.6),
          0.4,
        ) ??
        baseColor;

    return SizedBox(
      height: 140,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final children = <Widget>[];
            for (var index = 0; index < 6; index++) {
              if (index != 0) {
                children.add(const SizedBox(width: 12));
              }
              final phase = (_controller.value + index * 0.18) % 1.0;
              final intensity = 0.5 * (math.sin(phase * 2 * math.pi) + 1);
              final color =
                  Color.lerp(baseColor, highlightColor, intensity) ?? baseColor;

              children.add(
                Container(
                  width: 60,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }

            return Row(mainAxisSize: MainAxisSize.min, children: children);
          },
        ),
      ),
    );
  }
}
