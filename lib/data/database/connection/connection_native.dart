import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

QueryExecutor createExecutor() {
  return driftDatabase(name: 'electricity_tracker_db');
}
