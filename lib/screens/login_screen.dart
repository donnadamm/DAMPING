import 'package:flutter/material.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. ELEMEN HIASAN BACKGROUND

          // Lingkaran Kiri Atas
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8F1FF).withOpacity(0.8),
              ),
            ),
          ),

          // Lingkaran Bulat Kanan Tengah (Lapisan Luar)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.38,
            right: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE3EEFF).withOpacity(0.5),
              ),
            ),
          ),

          // Lingkaran Bulat Kanan Tengah (Lapisan Dalam)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.42,
            right: -30,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD4E5FF).withOpacity(0.6),
              ),
            ),
          ),

          // Gelombang Bawah Lapis 1 (Kontras Lebih Jelas)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: BottomWaveClipperBack(),
              child: Container(
                height: 170,
                color: const Color(0xFFB8D5FF).withOpacity(0.7),
              ),
            ),
          ),

          // Gelombang Bawah Lapis 2 (Depan)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: BottomWaveClipperFront(),
              child: Container(
                height: 135,
                color: const Color(0xFFEBF3FF).withOpacity(0.95),
              ),
            ),
          ),

          // Rangkaian Ornamen Daun (3 Daun) di Atas Gelombang Bawah
          Positioned(
            bottom: 22,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Transform.rotate(
                    angle: -0.3,
                    child: Icon(
                      Icons.eco,
                      size: 20,
                      color: const Color(0xFF629BF2).withOpacity(0.75),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.park_rounded,
                    size: 28,
                    color: const Color(0xFF2C7DEB).withOpacity(0.85),
                  ),
                  const SizedBox(width: 2),
                  Transform.rotate(
                    angle: 0.3,
                    child: Icon(
                      Icons.eco,
                      size: 22,
                      color: const Color(0xFF629BF2).withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. KONTEN UTAMA HALAMAN LOGIN
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Logo DAMPING
                  Image.asset(
                    'assets/android_fg.png',
                    width: 105,
                    height: 105,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),

                  // Judul & Subtitle
                  const Text(
                    'DAMPING',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0C356A),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Aplikasi Pengelolaan Pelanggaran Siswa',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E56A0),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Teks Salam
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Selamat Datang',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0C356A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Masuk dengan nomor HP dan password\nuntuk melanjutkan.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  // Input Nomor HP
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Nomor HP (contoh: 08123456789)',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400, fontSize: 13.5),
                      prefixIcon: const Icon(Icons.smartphone_rounded,
                          color: Color(0xFF2C7DEB)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: Color(0xFF2C7DEB), width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Input Password
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400, fontSize: 13.5),
                      prefixIcon: const Icon(Icons.lock_outline_rounded,
                          color: Color(0xFF2C7DEB)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: Color(0xFF2C7DEB), width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tombol Masuk
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2C7DEB), Color(0xFF1E56A0)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2C7DEB).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Lupa Password
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Lupa Password?',
                      style: TextStyle(
                        color: Color(0xFF2C7DEB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Link Daftar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun? ',
                        style: TextStyle(color: Colors.black54, fontSize: 13.5),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Daftar Sekarang',
                          style: TextStyle(
                            color: Color(0xFF2C7DEB),
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Clipper Gelombang Lapis Belakang
class BottomWaveClipperBack extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.15);

    var firstControlPoint = Offset(size.width * 0.35, size.height * 0.65);
    var firstEndPoint = Offset(size.width * 0.7, size.height * 0.25);

    var secondControlPoint = Offset(size.width * 0.88, size.height * 0.05);
    var secondEndPoint = Offset(size.width, size.height * 0.35);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Clipper Gelombang Lapis Depan
class BottomWaveClipperFront extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.55);

    var firstControlPoint = Offset(size.width * 0.3, size.height * 0.1);
    var firstEndPoint = Offset(size.width * 0.62, size.height * 0.45);

    var secondControlPoint = Offset(size.width * 0.85, size.height * 0.7);
    var secondEndPoint = Offset(size.width, size.height * 0.3);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
