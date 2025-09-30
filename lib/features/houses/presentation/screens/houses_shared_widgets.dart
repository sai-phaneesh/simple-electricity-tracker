import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electricity/features/houses/presentation/bloc/houses_bloc.dart';
import 'package:electricity/features/houses/domain/entities/house.dart';
import 'package:electricity/features/houses/presentation/widgets/house_card.dart';
import 'package:electricity/shared/navigation/responsive_form_navigator.dart';
import 'package:electricity/shared/widgets/responsive_layout.dart';

class SearchAndFilters extends StatefulWidget {
  const SearchAndFilters({super.key});

  @override
  State<SearchAndFilters> createState() => _SearchAndFiltersState();
}

class _SearchAndFiltersState extends State<SearchAndFilters> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = context.read<HousesBloc>().filter.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<HousesBloc>();
    final filter = bloc.filter;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SearchBar(
            controller: _searchController,
            hintText: 'Search houses...',
            leading: const Icon(Icons.search),
            trailing: _searchController.text.isNotEmpty
                ? [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        bloc.add(
                          UpdateHousesFilter(filter.copyWith(searchQuery: '')),
                        );
                      },
                    ),
                  ]
                : null,
            onChanged: (query) {
              bloc.add(UpdateHousesFilter(filter.copyWith(searchQuery: query)));
            },
          ),
          const SizedBox(height: 16),
          ResponsiveLayout(
            mobile: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'House Type',
                          border: OutlineInputBorder(),
                        ),
                        value: filter.houseType ?? 'All',
                        items: [
                          const DropdownMenuItem(
                            value: 'All',
                            child: Text('All'),
                          ),
                          ...[
                            'House',
                            'Apartment',
                            'Condo',
                            'Villa',
                            'Townhouse',
                          ].map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          bloc.add(
                            UpdateHousesFilter(
                              filter.copyWith(
                                houseType: value == 'All' ? null : value,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Ownership',
                          border: OutlineInputBorder(),
                        ),
                        value: filter.ownershipType ?? 'All',
                        items: [
                          const DropdownMenuItem(
                            value: 'All',
                            child: Text('All'),
                          ),
                          ...[
                            'Owned',
                            'Rented',
                            'Family Property',
                            'Shared',
                          ].map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          bloc.add(
                            UpdateHousesFilter(
                              filter.copyWith(
                                ownershipType: value == 'All' ? null : value,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _searchController.clear();
                      bloc.add(ClearFilters());
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear Filters'),
                  ),
                ),
              ],
            ),
            desktop: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'House Type',
                      border: OutlineInputBorder(),
                    ),
                    value: filter.houseType ?? 'All',
                    items: [
                      const DropdownMenuItem(value: 'All', child: Text('All')),
                      ...[
                        'House',
                        'Apartment',
                        'Condo',
                        'Villa',
                        'Townhouse',
                      ].map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      ),
                    ],
                    onChanged: (value) {
                      bloc.add(
                        UpdateHousesFilter(
                          filter.copyWith(
                            houseType: value == 'All' ? null : value,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Ownership',
                      border: OutlineInputBorder(),
                    ),
                    value: filter.ownershipType ?? 'All',
                    items: [
                      const DropdownMenuItem(value: 'All', child: Text('All')),
                      ...['Owned', 'Rented', 'Family Property', 'Shared'].map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      ),
                    ],
                    onChanged: (value) {
                      bloc.add(
                        UpdateHousesFilter(
                          filter.copyWith(
                            ownershipType: value == 'All' ? null : value,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                ActionChip(
                  label: const Text('Clear Filters'),
                  onPressed: () {
                    _searchController.clear();
                    bloc.add(ClearFilters());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorWidgetHouses extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorWidgetHouses({
    required this.message,
    required this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text('Error', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class EmptyWidgetHouses extends StatelessWidget {
  const EmptyWidgetHouses({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No houses found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Start by adding your first house',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () =>
                ResponsiveFormNavigator.navigateToAddHouse(context),
            icon: const Icon(Icons.add),
            label: const Text('Add House'),
          ),
        ],
      ),
    );
  }
}

class HousesList extends StatelessWidget {
  final List<House> houses;

  const HousesList({required this.houses, super.key});

  @override
  Widget build(BuildContext context) {
    if (houses.isEmpty) {
      return const EmptyWidgetHouses();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: houses.length,
      itemBuilder: (context, index) {
        final house = houses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: HouseCard(
            house: house,
            onEdit: () =>
                ResponsiveFormNavigator.navigateToEditHouse(context, house.id),
            onDelete: () => _confirmDelete(context, house),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, House house) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete House'),
        content: Text(
          'Are you sure you want to delete "${house.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              context.read<HousesBloc>().add(DeleteHouse(house.id));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class HousesGrid extends StatelessWidget {
  final List<House> houses;
  final int crossAxisCount;

  const HousesGrid({
    required this.houses,
    required this.crossAxisCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (houses.isEmpty) {
      return const EmptyWidgetHouses();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: houses.length,
      itemBuilder: (context, index) {
        final house = houses[index];
        return HouseCard(
          house: house,
          onEdit: () =>
              ResponsiveFormNavigator.navigateToEditHouse(context, house.id),
          onDelete: () => _confirmDelete(context, house),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, House house) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete House'),
        content: Text(
          'Are you sure you want to delete "${house.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              context.read<HousesBloc>().add(DeleteHouse(house.id));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
