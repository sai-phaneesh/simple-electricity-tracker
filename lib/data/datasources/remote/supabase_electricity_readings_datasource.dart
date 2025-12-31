import 'package:electricity/core/config/supabase_config.dart';
import 'package:electricity/data/datasources/electricity_readings_datasource.dart';
import 'package:electricity/domain/entities/electricity_reading.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseElectricityReadingsDataSource
    implements ElectricityReadingsDataSource {
  final SupabaseClient _supabase;

  SupabaseElectricityReadingsDataSource(this._supabase);

  @override
  Future<List<ElectricityReading>> getAllReadings() async {
    final response = await _supabase
        .from(SupabaseConfig.readingsTable)
        .select()
        .order('date', ascending: false);

    return (response as List)
        .map((json) => ElectricityReading.fromJson(json))
        .toList();
  }

  @override
  Future<List<ElectricityReading>> getReadingsByHouseId(String houseId) async {
    final response = await _supabase
        .from(SupabaseConfig.readingsTable)
        .select()
        .eq('house_id', houseId)
        .order('date', ascending: false);

    return (response as List)
        .map((json) => ElectricityReading.fromJson(json))
        .toList();
  }

  @override
  Future<List<ElectricityReading>> getReadingsByCycleId(String cycleId) async {
    final response = await _supabase
        .from(SupabaseConfig.readingsTable)
        .select()
        .eq('cycle_id', cycleId)
        .order('date', ascending: false);

    return (response as List)
        .map((json) => ElectricityReading.fromJson(json))
        .toList();
  }

  @override
  Future<ElectricityReading?> getReadingById(String id) async {
    final response = await _supabase
        .from(SupabaseConfig.readingsTable)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return ElectricityReading.fromJson(response);
  }

  @override
  Stream<List<ElectricityReading>> watchAllReadings() {
    return _supabase
        .from(SupabaseConfig.readingsTable)
        .stream(primaryKey: ['id'])
        .order('date', ascending: false)
        .map(
          (data) =>
              data.map((json) => ElectricityReading.fromJson(json)).toList(),
        );
  }

  @override
  Stream<List<ElectricityReading>> watchReadingsByHouseId(String houseId) {
    return _supabase
        .from(SupabaseConfig.readingsTable)
        .stream(primaryKey: ['id'])
        .eq('house_id', houseId)
        .order('date', ascending: false)
        .map(
          (data) =>
              data.map((json) => ElectricityReading.fromJson(json)).toList(),
        );
  }

  @override
  Stream<List<ElectricityReading>> watchReadingsByCycleId(String cycleId) {
    return _supabase
        .from(SupabaseConfig.readingsTable)
        .stream(primaryKey: ['id'])
        .eq('cycle_id', cycleId)
        .order('date', ascending: false)
        .map(
          (data) =>
              data.map((json) => ElectricityReading.fromJson(json)).toList(),
        );
  }

  @override
  Stream<ElectricityReading?> watchReadingById(String id) {
    return _supabase
        .from(SupabaseConfig.readingsTable)
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map(
          (data) =>
              data.isEmpty ? null : ElectricityReading.fromJson(data.first),
        );
  }

  @override
  Future<void> createReading(ElectricityReading reading) async {
    final userId = _supabase.auth.currentUser?.id;
    final data = reading.toJson();
    if (userId != null) {
      data['user_id'] = userId;
    }
    await _supabase.from(SupabaseConfig.readingsTable).insert(data);
  }

  @override
  Future<void> updateReading(ElectricityReading reading) async {
    await _supabase
        .from(SupabaseConfig.readingsTable)
        .update(reading.toJson())
        .eq('id', reading.id);
  }

  @override
  Future<void> deleteReading(String id) async {
    await _supabase.from(SupabaseConfig.readingsTable).delete().eq('id', id);
  }

  @override
  Future<ElectricityReading?> getLatestReadingForCycle(String cycleId) async {
    final response = await _supabase
        .from(SupabaseConfig.readingsTable)
        .select()
        .eq('cycle_id', cycleId)
        .order('date', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    return ElectricityReading.fromJson(response);
  }

  @override
  Future<ElectricityReading?> getLatestReadingForHouse(String houseId) async {
    final response = await _supabase
        .from(SupabaseConfig.readingsTable)
        .select()
        .eq('house_id', houseId)
        .order('date', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    return ElectricityReading.fromJson(response);
  }

  @override
  Future<int> getReadingsCount({String? houseId, String? cycleId}) async {
    var query = _supabase.from(SupabaseConfig.readingsTable).select('id');
    if (houseId != null) {
      query = query.eq('house_id', houseId);
    }
    if (cycleId != null) {
      query = query.eq('cycle_id', cycleId);
    }
    final response = await query;
    return (response as List).length;
  }

  @override
  Future<ElectricityReading?> getPreviousReading(
    String cycleId,
    DateTime currentDate,
  ) async {
    final response = await _supabase
        .from(SupabaseConfig.readingsTable)
        .select()
        .eq('cycle_id', cycleId)
        .lt('date', currentDate.toIso8601String())
        .order('date', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    return ElectricityReading.fromJson(response);
  }
}
