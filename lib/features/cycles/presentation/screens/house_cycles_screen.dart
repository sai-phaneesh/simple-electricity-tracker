import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:electricity/features/houses/domain/entities/house.dart';
import 'package:electricity/features/houses/presentation/bloc/houses_bloc.dart';
import 'package:electricity/shared/widgets/responsive_layout.dart';
import 'package:electricity/core/widgets/flutter_toast_x.dart';

class HouseCyclesScreen extends StatefulWidget {
  final String houseId;

  const HouseCyclesScreen({super.key, required this.houseId});

  @override
  State<HouseCyclesScreen> createState() => _HouseCyclesScreenState();
}

class _HouseCyclesScreenState extends State<HouseCyclesScreen> {
  House? house;
  bool isLoading = true;
  List<DummyCycle> cycles = [];

  @override
  void initState() {
    super.initState();
    _loadHouse();
    _loadCycles();
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

  Future<void> _loadCycles() async {
    // TODO: Load actual cycles from data source
    // For now, create some dummy data
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      cycles = _generateDummyCycles();
    });
  }

  List<DummyCycle> _generateDummyCycles() {
    final now = DateTime.now();
    return List.generate(5, (index) {
      final startDate = DateTime(now.year, now.month - index * 2, 1);
      final endDate = DateTime(now.year, now.month - index * 2 + 1, 0);
      final isActive = index == 0;

      return DummyCycle(
        id: 'cycle_$index',
        houseId: widget.houseId,
        name: '${_getMonthName(startDate.month)} ${startDate.year}',
        startDate: startDate,
        endDate: endDate,
        initialMeterReading: 1000 + (index * 100),
        maxUnits: 500,
        isActive: isActive,
        notes: isActive ? 'Current billing cycle' : null,
        createdAt: startDate,
        updatedAt: startDate,
      );
    });
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
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
        title: Text('${house?.name ?? 'House'} - Cycles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateCycleDialog,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text('${house?.name ?? 'House'} - Cycles'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Create Cycle'),
            onPressed: _showCreateCycleDialog,
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
        title: Text('${house?.name ?? 'House'} - Cycles'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Create Cycle'),
            onPressed: _showCreateCycleDialog,
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
                    'Total Cycles',
                    '${cycles.length}',
                    Icons.calendar_today,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryItem(
                    'Active Cycle',
                    cycles.any((c) => c.isActive) ? 'Current' : 'None',
                    Icons.schedule,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryItem(
                    'Max Units',
                    cycles.isNotEmpty ? '${cycles.first.maxUnits}' : '-',
                    Icons.bolt,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Cycles List
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
                        'Billing Cycles',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      Text(
                        '${cycles.length} cycles',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: cycles.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No cycles yet',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Create your first billing cycle',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text('Create Cycle'),
                                onPressed: _showCreateCycleDialog,
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: cycles.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final cycle = cycles[index];
                            return _buildCycleCard(cycle);
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

  Widget _buildCycleCard(DummyCycle cycle) {
    final progress = cycle.progress;
    final isActive = cycle.isActive;

    return Card(
      color: isActive
          ? Theme.of(
              context,
            ).colorScheme.primaryContainer.withValues(alpha: 0.3)
          : null,
      child: InkWell(
        onTap: () {
          // Navigate to cycle detail screen
          context.pushNamed(
            'cycle-detail',
            pathParameters: {'houseId': widget.houseId, 'cycleId': cycle.id},
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      color: isActive ? Colors.white : Colors.grey[600],
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
                              cycle.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            if (isActive) ...[
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
                                  'Active',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_formatDate(cycle.startDate)} - ${_formatDate(cycle.endDate)}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${cycle.durationInDays} days',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Max: ${cycle.maxUnits} units',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'view':
                          // Navigate to cycle readings screen
                          context.pushNamed(
                            'cycle-readings',
                            pathParameters: {
                              'houseId': widget.houseId,
                              'cycleId': cycle.id,
                            },
                          );
                          break;
                        case 'edit':
                          _showEditCycleDialog(cycle);
                          break;
                        case 'delete':
                          _showDeleteCycleDialog(cycle);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: ListTile(
                          leading: Icon(Icons.visibility),
                          title: Text('View Readings'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
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
                          title: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isActive) ...[
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
              if (cycle.notes?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Text(
                  cycle.notes!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showCreateCycleDialog() {
    FlutterToastX.info('Create cycle feature coming soon!');
  }

  void _showEditCycleDialog(DummyCycle cycle) {
    FlutterToastX.info('Edit cycle feature coming soon!');
  }

  void _showDeleteCycleDialog(DummyCycle cycle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Cycle'),
        content: Text(
          'Are you sure you want to delete "${cycle.name}"? This will also delete all readings in this cycle.',
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
                cycles.remove(cycle);
              });
              FlutterToastX.success('Cycle deleted successfully');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Dummy Cycle class - this should be replaced with the actual Cycle entity
class DummyCycle {
  final String id;
  final String houseId;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int initialMeterReading;
  final int maxUnits;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  DummyCycle({
    required this.id,
    required this.houseId,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.initialMeterReading,
    required this.maxUnits,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  int get durationInDays {
    return endDate.difference(startDate).inDays + 1;
  }

  double get progress {
    final now = DateTime.now();
    if (now.isBefore(startDate)) return 0.0;
    if (now.isAfter(endDate)) return 1.0;

    final totalDuration = endDate.difference(startDate).inDays;
    final elapsed = now.difference(startDate).inDays;
    return elapsed / totalDuration;
  }
}
