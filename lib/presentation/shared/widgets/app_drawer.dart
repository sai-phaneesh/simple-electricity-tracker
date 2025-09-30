import 'package:electricity/core/providers/app_providers.dart';
import 'package:electricity/core/router/app_router.dart';
import 'package:electricity/core/utils/extensions/strings.dart';
import 'package:electricity/presentation/shared/widgets/delete_confirmation_modal.dart';
import 'package:electricity/presentation/shared/widgets/theme_handler_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedHouse = ref.watch(selectedHouseProvider).valueOrNull;

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Electricity Tracker',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (selectedHouse != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${selectedHouse.name} • ${selectedHouse.meterNumber ?? 'No meter'}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: const [
                    _SectionTitle('Houses'),
                    SizedBox(height: 8),
                    HouseSelectorList(),
                  ],
                ),
              ),
              const DrawerActions(),
            ],
          ),
        ),
      ),
    );
  }
}

class HouseSelectorList extends ConsumerWidget {
  const HouseSelectorList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final housesAsync = ref.watch(housesStreamProvider);
    final selectedHouseId = ref.watch(selectedHouseIdProvider);

    return housesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        stackTrace;
        return Center(child: Text('Failed to load houses\n$error'));
      },
      data: (houses) {
        if (houses.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('No houses yet. Add one to begin tracking.'),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: houses.length,
          itemBuilder: (context, index) {
            final house = houses[index];
            final isSelected = house.id == selectedHouseId;
            return ListTile(
              title: Text(house.name),
              subtitle: Text(
                [
                  house.address,
                  house.meterNumber,
                ].where((e) => (e ?? '').isNotEmpty).join(' • '),
              ),
              trailing: isSelected ? const Icon(Icons.check) : null,
              selected: isSelected,
              onTap: () {
                ref.read(selectedHouseIdProvider.notifier).setHouse(house.id);
                ref.read(selectedCycleIdProvider.notifier).clear();
              },
              onLongPress: () async {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => const DeleteConfirmationModal(),
                );
                if (shouldDelete != true || !context.mounted) return;

                await ref.read(housesControllerProvider).deleteHouse(house.id);
              },
            );
          },
        );
      },
    );
  }
}

class CycleSelectorList extends ConsumerWidget {
  const CycleSelectorList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cyclesAsync = ref.watch(cyclesForSelectedHouseStreamProvider);
    final selectedCycleId = ref.watch(selectedCycleIdProvider);

    return cyclesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        stackTrace;
        return Center(child: Text('Failed to load cycles\n$error'));
      },
      data: (cycles) {
        if (cycles.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('No cycles for this house yet.'),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cycles.length,
          itemBuilder: (context, index) {
            final cycle = cycles[index];
            final isSelected = cycle.id == selectedCycleId;
            return ListTile(
              title: Text(cycle.name),
              subtitle: Text(
                '${_formatDate(cycle.startDate)} - ${_formatDate(cycle.endDate)}',
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: isSelected ? null : Colors.grey,
              ),
              selected: isSelected,
              onTap: () {
                ref.read(selectedCycleIdProvider.notifier).setCycle(cycle.id);
                context.pop();
              },
              onLongPress: () async {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => const DeleteConfirmationModal(),
                );
                if (shouldDelete != true || !context.mounted) return;

                await ref.read(cyclesControllerProvider).deleteCycle(cycle.id);
              },
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
}

class DrawerActions extends ConsumerWidget {
  const DrawerActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      top: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(),
          ListTile(
            onTap: () async {
              // context.pop();
              await _showCreateHouseDialog(context, ref);
            },
            title: const Text('Create House'),
            trailing: const Icon(Icons.home_work_outlined),
          ),
          ListTile(
            onTap: () {
              context.pop();
              context.push(AppRouteNames.settings);
            },
            title: const Text('Settings'),
            trailing: const Icon(Icons.settings_outlined),
          ),
          // ListTile(
          //   onTap: () {
          //     context.pop();
          //     context.pushNamed(AppRouteNames.createCycle);
          //   },
          //   title: const Text('Create Cycle'),
          //   trailing: const Icon(Icons.add_circle_outline),
          // ),
          // const ThemeHandlerListTile(),
          // const AboutTile(),
        ],
      ),
    );
  }

  Future<void> _showCreateHouseDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final nameController = TextEditingController();
    final defaultPriceController = TextEditingController();
    final addressController = TextEditingController();
    final meterNumberController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create House'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Name is required'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: meterNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Meter number',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: defaultPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Default price per unit',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Price per unit is required';
                      }
                      return double.tryParse(value.trim()) == null
                          ? 'Enter a valid number'
                          : null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                if (!(formKey.currentState?.validate() ?? false)) {
                  return;
                }
                final defaultPrice = double.parse(
                  defaultPriceController.text.trim(),
                );
                await ref
                    .read(housesControllerProvider)
                    .createHouse(
                      name: nameController.text.trim(),
                      address: addressController.text.trim().isEmpty
                          ? null
                          : addressController.text.trim(),
                      meterNumber: meterNumberController.text.trim().isEmpty
                          ? null
                          : meterNumberController.text.trim(),
                      defaultPricePerUnit: defaultPrice,
                    );
                if (context.mounted) Navigator.of(dialogContext).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    defaultPriceController.dispose();
    addressController.dispose();
    meterNumberController.dispose();
  }
}

class AboutTile extends StatelessWidget {
  const AboutTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('About'),
      trailing: const Icon(Icons.info),
      onTap: () {
        context.pop();
        context.pushNamed(AppRouteNames.about);
      },
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('About')));
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase().toCapitalized(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }
}
