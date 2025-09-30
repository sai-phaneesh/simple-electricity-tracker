import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:electricity/features/houses/domain/entities/house.dart';
import 'package:electricity/features/houses/presentation/bloc/houses_bloc.dart';
import 'package:electricity/features/readings/domain/entities/electricity_reading.dart';
import 'package:electricity/features/readings/presentation/form/add_reading_form_model.dart';
import 'package:electricity/features/readings/presentation/screens/add_reading_screen.dart';
import 'package:electricity/shared/widgets/responsive_layout.dart';
import 'package:electricity/core/widgets/flutter_toast_x.dart';

class HouseReadingsScreen extends StatefulWidget {
  final String houseId;
  final String? cycleId;

  const HouseReadingsScreen({super.key, required this.houseId, this.cycleId});

  @override
  State<HouseReadingsScreen> createState() => _HouseReadingsScreenState();
}

class _HouseReadingsScreenState extends State<HouseReadingsScreen> {
  House? house;
  bool isLoading = true;
  List<ElectricityReading> readings = [];

  @override
  void initState() {
    super.initState();
    _loadHouse();
    _loadReadings();
  }

  Future<void> _loadHouse() async {
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

  Future<void> _loadReadings() async {
    // TODO: Load actual readings from data source
    // For now, create some dummy data
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      readings = _generateDummyReadings();
    });
  }

  List<ElectricityReading> _generateDummyReadings() {
    final now = DateTime.now();
    return List.generate(10, (index) {
      // Generate readings with decreasing dates (latest first)
      final date = now.subtract(Duration(days: index * 30));
      final reading = 1000 + (index * 50) + (index * 5);
      final unitsConsumed = index == 0 ? 0 : 45 + (index * 3);
      final cost = unitsConsumed * (house?.defaultPricePerUnit ?? 5.0);

      return ElectricityReading(
        id: 'reading_$index',
        houseId: widget.houseId,
        cycleId: widget.cycleId!,
        date: date,
        meterReading: reading,
        unitsConsumed: unitsConsumed,
        totalCost: cost,
        notes: index == 0 ? 'Latest reading' : null,
        createdAt: date,
        updatedAt: date,
      );
    }); // Removed .reversed.toList() since we want latest first
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
    final title = widget.cycleId != null
        ? '${house?.name ?? 'House'} - Cycle Readings'
        : '${house?.name ?? 'House'} - All Readings';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddReadingDialog,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildTabletLayout() {
    final title = widget.cycleId != null
        ? '${house?.name ?? 'House'} - Cycle Readings'
        : '${house?.name ?? 'House'} - All Readings';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Reading'),
            onPressed: _showAddReadingDialog,
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
    final title = widget.cycleId != null
        ? '${house?.name ?? 'House'} - Cycle Readings'
        : '${house?.name ?? 'House'} - All Readings';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Reading'),
            onPressed: _showAddReadingDialog,
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    'Latest Reading',
                    readings.isNotEmpty
                        ? '${readings.first.meterReading}'
                        : '-',
                    Icons.electric_meter,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryItem(
                    'This Month',
                    readings.isNotEmpty
                        ? '${readings.first.unitsConsumed} units'
                        : '-',
                    Icons.bolt,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryItem(
                    'Total Cost',
                    readings.isNotEmpty
                        ? '₹${readings.first.totalCost.toStringAsFixed(2)}'
                        : '-',
                    Icons.currency_rupee,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Readings List
        Expanded(
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Text(
                        widget.cycleId != null
                            ? 'Cycle Reading History'
                            : 'Reading History',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      Text(
                        '${readings.length} readings',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: readings.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.electric_meter,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No readings yet',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add your first electricity reading',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text('Add Reading'),
                                onPressed: _showAddReadingDialog,
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: readings.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final reading = readings[index];
                            final isLatest = index == 0;
                            return _buildReadingCard(reading, isLatest);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 24,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildReadingCard(ElectricityReading reading, bool isLatest) {
    return Card(
      color: isLatest
          ? Theme.of(
              context,
            ).colorScheme.primaryContainer.withValues(alpha: 0.3)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isLatest
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.electric_meter,
                color: isLatest ? Colors.white : Colors.grey[600],
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _formatDate(reading.date),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (isLatest) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Latest',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Reading: ${reading.meterReading}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (reading.unitsConsumed > 0) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${reading.unitsConsumed} units consumed',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                  if (reading.notes?.isNotEmpty == true) ...[
                    const SizedBox(height: 4),
                    Text(
                      reading.notes!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${reading.totalCost.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  '₹${house?.defaultPricePerUnit ?? 5.0}/unit',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _showEditReadingDialog(reading);
                    break;
                  case 'delete':
                    _showDeleteReadingDialog(reading);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete', style: TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAddReadingDialog() {
    Navigator.of(context)
        .push(
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
        )
        .then((result) {
          // Refresh readings if a new reading was added
          if (result == true) {
            _loadReadings();
          }
        });
  }

  void _showEditReadingDialog(ElectricityReading reading) {
    FlutterToastX.info('Edit reading feature coming soon!');
  }

  void _showDeleteReadingDialog(ElectricityReading reading) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Reading'),
        content: Text(
          'Are you sure you want to delete the reading from ${_formatDate(reading.date)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                readings.remove(reading);
              });
              FlutterToastX.success('Reading deleted successfully');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
