import 'package:electricity/core/config/supabase_config.dart';
import 'package:electricity/data/datasources/cycles_datasource.dart';
import 'package:electricity/domain/entities/cycle.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseCyclesDataSource implements CyclesDataSource {
  final SupabaseClient _supabase;

  SupabaseCyclesDataSource(this._supabase);

  @override
  Future<List<Cycle>> getAllCycles() async {
    final response = await _supabase
        .from(SupabaseConfig.cyclesTable)
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((json) => Cycle.fromJson(json)).toList();
  }

  @override
  Future<List<Cycle>> getCyclesByHouseId(String houseId) async {
    final response = await _supabase
        .from(SupabaseConfig.cyclesTable)
        .select()
        .eq('house_id', houseId)
        .order('start_date', ascending: false);

    return (response as List).map((json) => Cycle.fromJson(json)).toList();
  }

  @override
  Future<Cycle?> getCycleById(String id) async {
    final response = await _supabase
        .from(SupabaseConfig.cyclesTable)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return Cycle.fromJson(response);
  }

  @override
  Stream<List<Cycle>> watchAllCycles() {
    return _supabase
        .from(SupabaseConfig.cyclesTable)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => Cycle.fromJson(json)).toList());
  }

  @override
  Stream<List<Cycle>> watchCyclesByHouseId(String houseId) {
    return _supabase
        .from(SupabaseConfig.cyclesTable)
        .stream(primaryKey: ['id'])
        .eq('house_id', houseId)
        .order('start_date', ascending: false)
        .map((data) => data.map((json) => Cycle.fromJson(json)).toList());
  }

  @override
  Stream<Cycle?> watchCycleById(String id) {
    return _supabase
        .from(SupabaseConfig.cyclesTable)
        .stream(primaryKey: ['id'])
        .map((data) {
          final filtered = data.where((json) => json['id'] == id);
          return filtered.isEmpty ? null : Cycle.fromJson(filtered.first);
        });
  }

  @override
  Stream<Cycle?> watchActiveCycleForHouse(String houseId) {
    return _supabase
        .from(SupabaseConfig.cyclesTable)
        .stream(primaryKey: ['id'])
        .map((data) {
          final filtered = data.where(
            (json) => json['house_id'] == houseId && json['is_active'] == true,
          );
          return filtered.isEmpty ? null : Cycle.fromJson(filtered.first);
        });
  }

  @override
  Future<void> createCycle(Cycle cycle) async {
    final userId = _supabase.auth.currentUser?.id;
    final data = cycle.toJson();
    if (userId != null) {
      data['user_id'] = userId;
    }
    await _supabase.from(SupabaseConfig.cyclesTable).insert(data);
  }

  @override
  Future<void> updateCycle(Cycle cycle) async {
    await _supabase
        .from(SupabaseConfig.cyclesTable)
        .update(cycle.toJson())
        .eq('id', cycle.id);
  }

  @override
  Future<void> deleteCycle(String id) async {
    await _supabase.from(SupabaseConfig.cyclesTable).delete().eq('id', id);
  }

  @override
  Future<Cycle?> getActiveCycleForHouse(String houseId) async {
    final response = await _supabase
        .from(SupabaseConfig.cyclesTable)
        .select()
        .eq('house_id', houseId)
        .eq('is_active', true)
        .maybeSingle();

    if (response == null) return null;
    return Cycle.fromJson(response);
  }

  @override
  Future<int> getCyclesCount({String? houseId}) async {
    var query = _supabase.from(SupabaseConfig.cyclesTable).select('id');
    if (houseId != null) {
      query = query.eq('house_id', houseId);
    }
    final response = await query;
    return (response as List).length;
  }

  @override
  Future<void> deactivateOtherCycles(
    String houseId,
    String activeCycleId,
  ) async {
    await _supabase
        .from(SupabaseConfig.cyclesTable)
        .update({'is_active': false})
        .eq('house_id', houseId)
        .neq('id', activeCycleId);
  }
}
