import 'app_database.dart';

class DatabaseProvider {
  static AppDatabase? _database;

  static AppDatabase get database {
    _database ??= _createDatabase();
    return _database!;
  }

  static AppDatabase _createDatabase() {
    // For now, we'll use the default constructor for both web and mobile
    // Web support can be enhanced later with proper WASM setup
    return AppDatabase();
  }

  static Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
