import 'package:electricity/core/utils/extensions/strings.dart';
import 'package:electricity/presentation/shared/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Map<ThemeMode, IconData> _themeModeIconMap = {
  ThemeMode.system: Icons.brightness_6,
  ThemeMode.light: Icons.wb_sunny,
  ThemeMode.dark: Icons.nights_stay,
};

class ThemeHandlerListTile extends ConsumerWidget {
  const ThemeHandlerListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeNotifierProvider);
    return ListTile(
      onTap: ref.read(themeNotifierProvider.notifier).toggleThemeMode,
      title: Text(themeState.mode.name.toCapitalized()),
      trailing: Icon(_themeModeIconMap[themeState.mode]!),
    );
  }
}

class ThemeHandlerIconButton extends ConsumerWidget {
  const ThemeHandlerIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeNotifierProvider);

    return IconButton(
      onPressed: ref.read(themeNotifierProvider.notifier).toggleThemeMode,
      icon: Icon(_themeModeIconMap[themeState.mode]!),
    );
  }
}
