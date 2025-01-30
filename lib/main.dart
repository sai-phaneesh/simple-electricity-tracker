import 'package:electricity/bloc/dashboard_bloc.dart';
import 'package:electricity/features/dashboard/presentation/screens/dashboard.dart';
import 'package:electricity/manager/shared_pref_manager.dart';
import 'package:electricity/shared/theme_cubit/theme_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  await SharedPrefManager.init();
  final pref = SharedPrefManager();
  final theme = pref.getThemeMode();

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
      providers: [
        BlocProvider(
          create: (context) => DashboardBloc(),
        ),
      ],
      child: MaterialApp(
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
        home: const Dashboard(),
      ),
    );
  }
}
