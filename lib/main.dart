import 'package:electricity/core/router/app_router.dart';
import 'package:electricity/data/datasources/local/preferences/shared_pref_manager.dart';
import 'package:electricity/presentation/shared/bloc/dashboard/dashboard_bloc.dart';
import 'package:electricity/presentation/shared/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';

final _router = createAppRouter();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefManager.init();
  final pref = SharedPrefManager();
  final themeJson = pref.getThemeModeJson();
  final theme = themeJson == null
      ? ThemeState.initial()
      : ThemeState.fromJson(themeJson);

  runApp(
    BlocProvider(
      create: (context) => ThemeCubit(pref, initialTheme: theme),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;

    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => DashboardBloc())],
      child: MaterialApp.router(
        title: 'Flutter Demo',
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
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark(useMaterial3: true),
        routerConfig: _router,
      ),
    );
  }
}
