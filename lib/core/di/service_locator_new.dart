import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'service_locator_new.config.dart';

// GetIt instance
final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

// Clean up dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
