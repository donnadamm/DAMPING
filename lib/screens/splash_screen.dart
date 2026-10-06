import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() async {
    // Beri jeda 2 detik agar logo terlihat sempurna lalu pindah ke Login
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Gradasi warna biru presisi sesuai rancangan gambar
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF62A7FB), // Biru terang atas
              Color(0xFF4390F6), // Biru sedang
              Color(0xFF2C7DEB), // Biru lembut bawah
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Logo Utama (android_fg.png)
              Image.asset(
                'assets/android_fg.png',
                width: 190,
                height: 190,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),

              // Judul DAMPING
              const Text(
                'DAMPING',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0C356A), // Biru tua gelap agar tajam & jelas
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              const Text(
                'Aplikasi Pengelolaan Pelanggaran Siswa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0C356A),
                ),
              ),

              const Spacer(flex: 2),

              // Tagline bawah
              const Text(
                'Catat. Pantau. Dampingi.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
