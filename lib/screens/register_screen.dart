import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun DAMPING'),
        backgroundColor: const Color(0xFF2C7DEB),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Halaman Pendaftaran Akun',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
