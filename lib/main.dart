import 'package:electricity/bloc/dashboard_bloc.dart';
import 'package:electricity/bloc/theme/theme_bloc.dart';
import 'package:electricity/bloc/font_size/font_size_bloc.dart';
import 'package:electricity/core/di/service_locator_new.dart';
import 'package:electricity/core/router/app_router.dart';
import 'package:electricity/core/widgets/flutter_toast_x.dart';
import 'package:electricity/core/bloc/app_bloc_observer.dart';
import 'package:electricity/features/houses/presentation/bloc/houses_bloc.dart';
import 'package:electricity/shared/theme/app_theme.dart';
import 'package:electricity/shared/enums/theme_mode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set BLoC observer for debugging hot reload issues
  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  }

  // Initialize GetIt service locator
  await configureDependencies();

  // Initialize HydratedBloc storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  // Database is now initialized through GetIt

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()..add(ThemeInitialized())),
        BlocProvider(
          create: (context) => FontSizeBloc()..add(FontSizeInitialized()),
        ),
        BlocProvider(create: (context) => DashboardBloc()),
        BlocProvider(
          create: (context) => getIt<HousesBloc>()..add(LoadHouses()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, themeState) {
        return BlocBuilder<FontSizeBloc, FontSizeState>(
          buildWhen: (previous, current) =>
              previous.fontSize != current.fontSize,
          builder: (context, fontState) {
            // Convert our custom AppThemeMode to Flutter's ThemeMode
            final ThemeMode flutterThemeMode = switch (themeState.themeMode) {
              AppThemeMode.light => ThemeMode.light,
              AppThemeMode.dark => ThemeMode.dark,
              AppThemeMode.system => ThemeMode.system,
            };

            return Stack(
              textDirection: TextDirection.ltr,
              children: [
                MaterialApp.router(
                  title: 'Electricity Tracker',
                  themeMode: flutterThemeMode,
                  theme: AppThemes.lightTheme(fontState.fontSize),
                  darkTheme: AppThemes.darkTheme(fontState.fontSize),
                  routerConfig: AppRouter.router,
                ),
                const ToastContainer(),
              ],
            );
          },
        );
      },
    );
  }
}
