import 'package:flutter/material.dart';
import '../core/constants/app_color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Logo Aplikasi DAMPING
              Image.asset(
                'assets/android_fg.png',
                height: 90,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.favorite,
                    size: 80,
                    color: AppColors.primaryBlue,
                  );
                },
              ),
              const SizedBox(height: 12),

              // Judul & Subtitle
              const Text(
                'DAMPING',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Aplikasi Pengelolaan Pelanggaran Siswa',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 36),

              // Teks Selamat Datang
              const Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Masuk dengan nomor HP dan password untuk melanjutkan.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Field Input Nomor HP
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone_outlined,
                      color: AppColors.textSecondary),
                  hintText: 'Nomor HP (Contoh: 08123456789)',
                  hintStyle:
                      TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 16),

              // Field Input Password
              TextField(
                controller: _passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: AppColors.textSecondary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                  hintText: 'Password',
                  hintStyle: const TextStyle(
                      fontSize: 14, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 28),

              // Tombol Masuk
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Logika login / navigasi ke Dashboard (Layar 3)
                  },
                  child: const Text('Masuk'),
                ),
              ),
              const SizedBox(height: 16),

              // Tombol Lupa Password
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Lupa Password?',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
