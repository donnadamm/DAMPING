import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';

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

      // Menggunakan sistem routes sebagai pengganti 'home:'
      initialRoute: '/splash', // Halaman pertama kali dibuka
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        // Nanti kamu bisa tambahkan rute dashboard di sini
        // '/dashboard_guru': (context) => const DashboardGuruScreen(),
      },
    );
  }
}
