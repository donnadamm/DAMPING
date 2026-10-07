import 'package:flutter/material.dart';

class DashboardAdminScreen extends StatelessWidget {
  const DashboardAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Selamat datang di Dashboard Admin!',
            style: TextStyle(fontSize: 18)),
      ),
    );
  }
}