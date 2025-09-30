import 'package:electricity/core/di/dependency_injection.dart';
import 'package:electricity/core/router/app_router.dart';
import 'package:electricity/data/datasources/local/preferences/shared_pref_manager.dart';
import 'package:electricity/presentation/shared/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

final _router = createAppRouter();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DependencyInjection.init();

  await SharedPrefManager.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      title: 'Electricity Tracker',
      themeMode: themeState.mode,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(24, 18, 43, 0),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      routerConfig: _router,
    );
  }
}
