import 'package:electricity/core/config/supabase_config.dart';
import 'package:electricity/data/datasources/houses_datasource.dart';
import 'package:electricity/domain/entities/house.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHousesDataSource implements HousesDataSource {
  final SupabaseClient _supabase;

  SupabaseHousesDataSource(this._supabase);

  @override
  Future<List<House>> getAllHouses() async {
    final response = await _supabase
        .from(SupabaseConfig.housesTable)
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((json) => House.fromJson(json)).toList();
  }

  @override
  Future<House?> getHouseById(String id) async {
    final response = await _supabase
        .from(SupabaseConfig.housesTable)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return House.fromJson(response);
  }

  @override
  Stream<List<House>> watchAllHouses() {
    return _supabase
        .from(SupabaseConfig.housesTable)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => House.fromJson(json)).toList());
  }

  @override
  Stream<House?> watchHouseById(String id) {
    return _supabase
        .from(SupabaseConfig.housesTable)
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((data) => data.isEmpty ? null : House.fromJson(data.first));
  }

  @override
  Future<void> createHouse(House house) async {
    final userId = _supabase.auth.currentUser?.id;
    final data = house.toJson();
    if (userId != null) {
      data['user_id'] = userId;
    }
    await _supabase.from(SupabaseConfig.housesTable).insert(data);
  }

  @override
  Future<void> updateHouse(House house) async {
    await _supabase
        .from(SupabaseConfig.housesTable)
        .update(house.toJson())
        .eq('id', house.id);
  }

  @override
  Future<void> deleteHouse(String id) async {
    await _supabase.from(SupabaseConfig.housesTable).delete().eq('id', id);
  }

  @override
  Future<List<House>> searchHouses(String query) async {
    final response = await _supabase
        .from(SupabaseConfig.housesTable)
        .select()
        .ilike('name', '%$query%')
        .order('name');

    return (response as List).map((json) => House.fromJson(json)).toList();
  }

  @override
  Future<int> getHousesCount() async {
    final response = await _supabase
        .from(SupabaseConfig.housesTable)
        .select('id');

    return (response as List).length;
  }
}
