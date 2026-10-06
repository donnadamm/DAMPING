import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const DampingApp());
}

class DampingApp extends StatelessWidget {
  const DampingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DAMPING',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
