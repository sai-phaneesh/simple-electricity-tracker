import 'package:electricity/presentation/shared/widgets/theme_handler_widgets.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(child: Column(children: [const ThemeHandlerListTile()])),
    );
  }
}
