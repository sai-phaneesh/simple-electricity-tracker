import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:electricity/features/houses/domain/entities/house.dart';
import 'package:electricity/features/houses/presentation/bloc/houses_bloc.dart';
import 'package:electricity/features/cycles/domain/entities/cycle.dart';
import 'package:electricity/features/readings/presentation/form/add_reading_form_model.dart';
import 'package:electricity/features/readings/presentation/screens/add_reading_screen.dart';
import 'package:electricity/shared/widgets/responsive_layout.dart';
import 'package:electricity/core/widgets/flutter_toast_x.dart';

class CycleDetailScreen extends StatefulWidget {
  final String houseId;
  final String cycleId;

  const CycleDetailScreen({
    super.key,
    required this.houseId,
    required this.cycleId,
  });

  @override
  State<CycleDetailScreen> createState() => _CycleDetailScreenState();
}

class _CycleDetailScreenState extends State<CycleDetailScreen> {
  House? house;
  Cycle? cycle;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final housesBloc = context.read<HousesBloc>();
      final loadedHouse = await housesBloc.getHouseById(widget.houseId);

      // TODO: Load actual cycle from data source
      // For now, create dummy cycle data
      final dummyCycle = _generateDummyCycle();

      setState(() {
        house = loadedHouse;
        cycle = dummyCycle;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      FlutterToastX.error('Failed to load cycle details');
    }
  }

  Cycle _generateDummyCycle() {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime(now.year, now.month + 1, 0);

    return Cycle(
      id: widget.cycleId,
      houseId: widget.houseId,
      name: 'Billing Period ${now.month}/${now.year}',
      startDate: startDate,
      endDate: endDate,
      initialMeterReading: 1000,
      maxUnits: 300,
      pricePerUnit: 5.0,
      notes: 'Monthly billing cycle',
      createdAt: startDate,
      updatedAt: startDate,
      isActive: true,
    );
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
        title: Text(cycle?.name ?? 'Cycle Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.electric_meter),
            onPressed: _navigateToReadings,
            tooltip: 'View Readings',
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit Cycle'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'readings',
                child: ListTile(
                  leading: Icon(Icons.electric_meter),
                  title: Text('View Readings'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToReadings,
        icon: const Icon(Icons.electric_meter),
        label: const Text('View Readings'),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text(cycle?.name ?? 'Cycle Details'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
            onPressed: () => _handleMenuAction('edit'),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.electric_meter),
            label: const Text('View Readings'),
            onPressed: _navigateToReadings,
          ),
          const SizedBox(width: 16),
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
        title: Text(cycle?.name ?? 'Cycle Details'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
            onPressed: () => _handleMenuAction('edit'),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.electric_meter),
            label: const Text('View Readings'),
            onPressed: _navigateToReadings,
          ),
          const SizedBox(width: 16),
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

    if (house == null || cycle == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_month, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Cycle not found',
              style: Theme.of(context).textTheme.headlineSmall,
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
          // House Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.home,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          house!.name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (house!.address.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            house!.address,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Cycle Details Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Cycle Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: cycle!.isActive ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          cycle!.isActive ? 'ACTIVE' : 'INACTIVE',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          'Start Date',
                          _formatDate(cycle!.startDate),
                          Icons.calendar_today,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoItem(
                          'End Date',
                          _formatDate(cycle!.endDate),
                          Icons.event,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          'Initial Reading',
                          '${cycle!.initialMeterReading}',
                          Icons.electric_meter,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoItem(
                          'Max Units',
                          '${cycle!.maxUnits} units',
                          Icons.bolt,
                        ),
                      ),
                    ],
                  ),

                  if (cycle!.notes?.isNotEmpty == true) ...[
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 12),
                    Text(
                      'Notes',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cycle!.notes!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quick Actions Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildActionChip(
                        'View Readings',
                        Icons.electric_meter,
                        _navigateToReadings,
                        isPrimary: true,
                      ),
                      _buildActionChip(
                        'Add Reading',
                        Icons.add,
                        _showAddReadingDialog,
                      ),
                      _buildActionChip(
                        'Edit Cycle',
                        Icons.edit,
                        () => _handleMenuAction('edit'),
                      ),
                      _buildActionChip(
                        'Generate Report',
                        Icons.description,
                        () => FlutterToastX.info(
                          'Report generation coming soon!',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildActionChip(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool isPrimary = false,
  }) {
    return ActionChip(
      avatar: Icon(
        icon,
        size: 18,
        color: isPrimary
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSurface,
      ),
      label: Text(label),
      onPressed: onPressed,
      backgroundColor: isPrimary ? Theme.of(context).colorScheme.primary : null,
      labelStyle: TextStyle(
        color: isPrimary ? Theme.of(context).colorScheme.onPrimary : null,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navigateToReadings() {
    context.pushNamed(
      'cycle-readings',
      pathParameters: {'houseId': widget.houseId, 'cycleId': widget.cycleId},
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'edit':
        FlutterToastX.info('Edit cycle feature coming soon!');
        break;
      case 'readings':
        _navigateToReadings();
        break;
    }
  }

  void _showAddReadingDialog() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => AddReadingFormModel(
            houseId: widget.houseId,
            cycleId: widget.cycleId,
            defaultPricePerUnit: house?.defaultPricePerUnit,
          ),
          child: AddReadingScreen(
            houseId: widget.houseId,
            cycleId: widget.cycleId,
            houseName: house?.name ?? 'House',
            defaultPricePerUnit: house?.defaultPricePerUnit,
          ),
        ),
      ),
    );
  }
}
