import 'package:electricity/core/utils/extensions/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/theme_cubit.dart';

Map<ThemeMode, IconData> _themeModeIconMap = {
  ThemeMode.system: Icons.brightness_6,
  ThemeMode.light: Icons.wb_sunny,
  ThemeMode.dark: Icons.nights_stay,
};

class ThemeHandlerListTile extends StatelessWidget {
  const ThemeHandlerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return ListTile(
      onTap: context.read<ThemeCubit>().toggleThemeState,
      title: Text(themeState.mode.name.toCapitalized()),
      trailing: Icon(_themeModeIconMap[themeState.mode]!),
    );
  }
}

class ThemeHandlerIconButton extends StatelessWidget {
  const ThemeHandlerIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;

    return IconButton(
      onPressed: context.read<ThemeCubit>().toggleThemeState,
      icon: Icon(_themeModeIconMap[themeState.mode]!),
      // icon: switch (themeState.mode) {
      //   ThemeMode.system => const Icon(Icons.brightness_6),
      //   ThemeMode.light => const Icon(Icons.wb_sunny),
      //   ThemeMode.dark => const Icon(Icons.nights_stay),
      // },
    );
  }
}
