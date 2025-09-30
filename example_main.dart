// Example of how to initialize dependency injection in main.dart

import 'package:flutter/material.dart';
import 'package:electricity/core/di/service_locator_new.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await configureDependencies();

  // Seed initial data (optional - only for first run)
  // await DataSeeder.seedInitialData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Electricity Tracker',
      home: Scaffold(
        appBar: AppBar(title: const Text('Electricity Tracker')),
        body: const Center(child: Text('App with GetIt DI Setup Complete!')),
      ),
    );
  }
}
