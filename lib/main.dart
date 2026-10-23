import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_admin.dart';
import 'screens/dashboard_guru.dart';
import 'screens/dashboard_parent.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

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
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard_admin': (context) => const DashboardAdminScreen(),
        '/dashboard_guru': (context) => const DashboardGuruScreen(),
        '/dashboard_parent': (context) => const DashboardParentScreen(),
      },
    );
  }
}
