import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:electricity/features/houses/domain/entities/house.dart';
import 'package:electricity/features/houses/presentation/bloc/houses_bloc.dart';
import 'package:electricity/shared/widgets/responsive_layout.dart';
import 'package:electricity/core/widgets/flutter_toast_x.dart';

class HouseDetailScreen extends StatefulWidget {
  final String houseId;

  const HouseDetailScreen({super.key, required this.houseId});

  @override
  State<HouseDetailScreen> createState() => _HouseDetailScreenState();
}

class _HouseDetailScreenState extends State<HouseDetailScreen> {
  House? house;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHouse();
  }

  Future<void> _loadHouse() async {
    setState(() => isLoading = true);
    try {
      final housesBloc = context.read<HousesBloc>();
      final loadedHouse = await housesBloc.getHouseById(widget.houseId);
      setState(() {
        house = loadedHouse;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      FlutterToastX.error('Failed to load house details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text(house?.name ?? 'House Details'),
        actions: [
          if (house != null) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push('/houses/edit/${house!.id}'),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(),
            ),
          ],
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text(house?.name ?? 'House Details'),
        actions: [
          if (house != null) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push('/houses/edit/${house!.id}'),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(),
            ),
          ],
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(16),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text(house?.name ?? 'House Details'),
        actions: [
          if (house != null) ...[
            TextButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Edit'),
              onPressed: () => context.push('/houses/edit/${house!.id}'),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text('Delete'),
              onPressed: () => _showDeleteDialog(),
            ),
            const SizedBox(width: 16),
          ],
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.all(24),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (house == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'House not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The requested house could not be found.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.home,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              house!.name,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              house!.address,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      if (house!.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.green),
                          ),
                          child: const Text(
                            'Active',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quick Actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildActionButton(
                        icon: Icons.calendar_today,
                        label: 'View Cycles',
                        onPressed: () {
                          context.push('/houses/${house!.id}/cycles');
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.electric_meter,
                        label: 'Active Cycle Readings',
                        onPressed: () {
                          // TODO: Navigate to active cycle readings
                          FlutterToastX.info(
                            'Active cycle readings coming soon!',
                          );
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.analytics,
                        label: 'View Analytics',
                        onPressed: () {
                          // TODO: Navigate to house-specific analytics
                          FlutterToastX.info('House analytics coming soon!');
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.history,
                        label: 'View History',
                        onPressed: () {
                          // TODO: Navigate to history screen
                          FlutterToastX.info('History feature coming soon!');
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.settings,
                        label: 'House Settings',
                        onPressed: () {
                          context.push('/houses/edit/${house!.id}');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Property Details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Property Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('House Type', house!.houseType),
                  _buildDetailRow('Ownership Type', house!.ownershipType),
                  if (house!.meterNumber.isNotEmpty)
                    _buildDetailRow('Meter Number', house!.meterNumber),
                  if (house!.notes?.isNotEmpty == true)
                    _buildDetailRow('Notes', house!.notes!),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Electricity Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Electricity Settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    'Default Price per Unit',
                    '₹${house!.defaultPricePerUnit.toStringAsFixed(2)}',
                  ),
                  if (house!.freeUnitsPerMonth > 0)
                    _buildDetailRow(
                      'Free Units per Month',
                      '${house!.freeUnitsPerMonth} units',
                    ),
                  if (house!.warningLimitUnits > 0)
                    _buildDetailRow(
                      'Warning Limit',
                      '${house!.warningLimitUnits} units',
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Metadata
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Metadata',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Created', _formatDate(house!.createdAt)),
                  _buildDetailRow(
                    'Last Updated',
                    _formatDate(house!.updatedAt),
                  ),
                  _buildDetailRow('House ID', house!.id),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete House'),
        content: Text(
          'Are you sure you want to delete "${house!.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                context.read<HousesBloc>().add(DeleteHouse(house!.id));
                FlutterToastX.success('House deleted successfully');
                context.pop(); // Go back to houses list
              } catch (e) {
                FlutterToastX.error('Failed to delete house');
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
