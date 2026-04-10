// lib/app.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'providers/plant_provider.dart';
import 'providers/planet_provider.dart';

class DelcomPlantsApp extends StatefulWidget {
  const DelcomPlantsApp({super.key});

  @override
  State<DelcomPlantsApp> createState() => _DelcomPlantsAppState();
}

class _DelcomPlantsAppState extends State<DelcomPlantsApp> {
  final ThemeNotifier _themeNotifier = ThemeNotifier(initial: ThemeMode.light);

  @override
  void dispose() {
    _themeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      notifier: _themeNotifier,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PlantProvider()),
          ChangeNotifierProvider(create: (_) => PlanetProvider()), // ✅ tambahkan ini
        ],
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: _themeNotifier,
          builder: (context, themeMode, child) {
            return MaterialApp.router(
              title: 'Delcom Planets',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              routerConfig: appRouter,
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}