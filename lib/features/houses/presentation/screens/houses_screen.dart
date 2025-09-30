import 'houses_mobile_layout.dart';
import 'houses_tablet_layout.dart';
import 'houses_desktop_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electricity/shared/widgets/responsive_layout.dart';
import 'package:electricity/features/houses/presentation/bloc/houses_bloc.dart';
import 'package:electricity/features/houses/data/datasources/houses_local_data_source.dart';
import 'package:electricity/core/di/service_locator_new.dart';
import 'package:electricity/shared/navigation/responsive_form_navigator.dart';
import 'package:electricity/core/dev/development_data.dart';
import 'package:flutter/foundation.dart';

/// Houses screen - Main screen showing list of houses
class HousesScreen extends StatefulWidget {
  const HousesScreen({super.key});

  @override
  State<HousesScreen> createState() => _HousesScreenState();
}

class _HousesScreenState extends State<HousesScreen> {
  /// Add dummy data for development/testing purposes
  void _addDummyData(BuildContext context) {
    final dummyHouses = DevelopmentData.generateDummyHouses();
    for (final house in dummyHouses) {
      context.read<HousesBloc>().add(
        AddHouse(
          name: house.name,
          address: house.address,
          houseType: house.houseType,
          ownershipType: house.ownershipType,
          notes: house.notes,
          meterNumber: house.meterNumber,
          defaultPricePerUnit: house.defaultPricePerUnit,
          freeUnitsPerMonth: house.freeUnitsPerMonth,
          warningLimitUnits: house.warningLimitUnits,
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${dummyHouses.length} dummy houses for testing'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Houses'),
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.data_object),
              onPressed: () => _addDummyData(context),
              tooltip: 'Add Dummy Data (Debug)',
            ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () async {
              // Debug: Check database state
              final dataSource = getIt<HousesLocalDataSource>();
              await dataSource.debugDatabaseState();
            },
            tooltip: 'Debug Database',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                ResponsiveFormNavigator.navigateToAddHouse(context),
            tooltip: 'Add House',
          ),
        ],
      ),
      body: const HousesBody(),
    );
  }
}

class HousesBody extends StatelessWidget {
  const HousesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HousesBloc, HousesState>(
      builder: (context, state) {
        return const ResponsiveLayout(
          mobile: HousesMobileLayout(),
          tablet: HousesTabletLayout(),
          desktop: HousesDesktopLayout(),
        );
      },
    );
  }
}
