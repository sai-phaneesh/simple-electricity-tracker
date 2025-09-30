import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electricity/bloc/theme/theme_bloc.dart';
import 'package:electricity/shared/enums/theme_mode.dart';

/// Theme selector dialog
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppThemeMode.values.map((themeMode) {
              return RadioListTile<AppThemeMode>(
                title: Text(themeMode.label),
                subtitle: Text(themeMode.description),
                value: themeMode,
                groupValue: state.themeMode,
                onChanged: state.isLoading
                    ? null
                    : (AppThemeMode? value) {
                        if (value != null) {
                          context.read<ThemeBloc>().add(ThemeChanged(value));
                          Navigator.of(context).pop();
                        }
                      },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// Show theme selector dialog
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => const ThemeSelector(),
    );
  }
}

/// Theme selector list tile for settings
class ThemeSelectorTile extends StatelessWidget {
  const ThemeSelectorTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return ListTile(
          leading: Icon(_getThemeIcon(state.themeMode)),
          title: const Text('Theme'),
          subtitle: Text(state.themeMode.label),
          trailing: state.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.chevron_right),
          onTap: state.isLoading
              ? null
              : () {
                  ThemeSelector.show(context);
                },
        );
      },
    );
  }

  IconData _getThemeIcon(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
