import 'package:flutter/material.dart';

class DashboardGuruScreen extends StatelessWidget {
  const DashboardGuruScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Guru'),
        backgroundColor: const Color(0xFF2C7DEB),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Selamat datang di Dashboard Guru!',
            style: TextStyle(fontSize: 18)),
      ),
    );
  }
}