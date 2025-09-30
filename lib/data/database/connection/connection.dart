import 'package:drift/drift.dart';

// Conditional import: pick web implementation when running in the browser.
import 'connection_native.dart' if (dart.library.html) 'connection_web.dart';

QueryExecutor openConnection() => createExecutor();
