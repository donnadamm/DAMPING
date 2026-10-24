import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  static const Color blueTop = Color(0xFF62A7FB);
  static const Color blueMiddle = Color(0xFF4390F6);
  static const Color blueBottom = Color(0xFF2C7DEB);

  @override
  void initState() {
    super.initState();

    debugPrint('DAMPING: SplashScreen Flutter berhasil dibuka');

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.88,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Latar belakang gradasi biru.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    blueTop,
                    blueMiddle,
                    blueBottom,
                  ],
                ),
              ),
              child: SizedBox.expand(),
            ),

            // Ornamen transparan di sudut layar.
            const Positioned(
              top: -65,
              left: -75,
              child: _CircleDecoration(
                size: 210,
                opacity: 0.13,
              ),
            ),
            const Positioned(
              top: 130,
              right: -65,
              child: _CircleDecoration(
                size: 150,
                opacity: 0.12,
              ),
            ),
            const Positioned(
              top: 260,
              left: -25,
              child: _CircleDecoration(
                size: 70,
                opacity: 0.12,
              ),
            ),
            const Positioned(
              top: 340,
              right: 35,
              child: _CircleDecoration(
                size: 24,
                opacity: 0.25,
              ),
            ),

            // Gelombang dekoratif di bagian bawah.
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 210,
              child: CustomPaint(
                painter: _WavePainter(),
              ),
            ),

            // Konten utama.
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo aplikasi.
                          Image.asset(
                            'assets/android_fg.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint('Gagal memuat logo DAMPING: $error');

                              return const Icon(
                                Icons.school_rounded,
                                size: 120,
                                color: Colors.white,
                              );
                            },
                          ),

                          const SizedBox(height: 8),

                          // Nama aplikasi.
                          const Text(
                            'DAMPING',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              color: Color(0xFF0C356A),
                            ),
                          ),

                          const SizedBox(height: 5),

                          // Deskripsi aplikasi.
                          const Text(
                            'Aplikasi Pengelolaan Pelanggaran Siswa',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF123F77),
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 42),

                          // Tagline aplikasi.
                          const Text(
                            'Catat. Pantau. Dampingi.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Lingkaran dekoratif transparan.
class _CircleDecoration extends StatelessWidget {
  final double size;
  final double opacity;

  const _CircleDecoration({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}

// Membuat gelombang dekoratif menggunakan CustomPainter.
class _WavePainter extends CustomPainter {
  const _WavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final waveOne = Paint()
      ..color = Colors.white.withValues(alpha: 0.20)
      ..style = PaintingStyle.fill;

    final waveTwo = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final waveThree = Paint()
      ..color = const Color(0xFFB9DEFF).withValues(alpha: 0.13)
      ..style = PaintingStyle.fill;

    // Gelombang pertama.
    final pathOne = Path()
      ..moveTo(0, size.height * 0.12)
      ..cubicTo(
        size.width * 0.28,
        -size.height * 0.02,
        size.width * 0.43,
        size.height * 0.68,
        size.width * 0.68,
        size.height * 0.73,
      )
      ..cubicTo(
        size.width * 0.83,
        size.height * 0.78,
        size.width * 0.91,
        size.height * 0.70,
        size.width,
        size.height * 0.74,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(pathOne, waveOne);

    // Gelombang kedua.
    final pathTwo = Path()
      ..moveTo(0, size.height * 0.66)
      ..cubicTo(
        size.width * 0.24,
        size.height * 0.88,
        size.width * 0.48,
        size.height * 0.72,
        size.width * 0.70,
        size.height * 0.49,
      )
      ..cubicTo(
        size.width * 0.83,
        size.height * 0.36,
        size.width * 0.92,
        size.height * 0.36,
        size.width,
        size.height * 0.40,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(pathTwo, waveTwo);

    // Gelombang ketiga.
    final pathThree = Path()
      ..moveTo(0, size.height * 0.80)
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.98,
        size.width * 0.60,
        size.height * 0.73,
        size.width,
        size.height * 0.65,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(pathThree, waveThree);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
