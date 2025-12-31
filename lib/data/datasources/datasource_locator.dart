import 'package:electricity/data/datasources/houses_datasource.dart';
import 'package:electricity/data/datasources/cycles_datasource.dart';
import 'package:electricity/data/datasources/electricity_readings_datasource.dart';
import 'package:electricity/data/datasources/remote/supabase_houses_datasource.dart';
import 'package:electricity/data/datasources/remote/supabase_cycles_datasource.dart';
import 'package:electricity/data/datasources/remote/supabase_electricity_readings_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service locator for datasource instances following Clean Architecture principles
/// This uses remote datasources (Supabase) for online-only functionality
class DataSourceLocator {
  final SupabaseClient _supabase;

  // Singleton instances
  HousesDataSource? _housesDataSource;
  CyclesDataSource? _cyclesDataSource;
  ElectricityReadingsDataSource? _electricityReadingsDataSource;

  DataSourceLocator(this._supabase);

  /// Get the Houses datasource (remote implementation)
  HousesDataSource get houses {
    _housesDataSource ??= SupabaseHousesDataSource(_supabase);
    return _housesDataSource!;
  }

  /// Get the Cycles datasource (remote implementation)
  CyclesDataSource get cycles {
    _cyclesDataSource ??= SupabaseCyclesDataSource(_supabase);
    return _cyclesDataSource!;
  }

  /// Get the Electricity Readings datasource (remote implementation)
  ElectricityReadingsDataSource get electricityReadings {
    _electricityReadingsDataSource ??= SupabaseElectricityReadingsDataSource(
      _supabase,
    );
    return _electricityReadingsDataSource!;
  }

  /// Reset all datasource instances
  void reset() {
    _housesDataSource = null;
    _cyclesDataSource = null;
    _electricityReadingsDataSource = null;
  }
}
