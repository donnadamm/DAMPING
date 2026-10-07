import 'package:flutter/material.dart';

class DashboardParentScreen extends StatelessWidget {
  const DashboardParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Orang Tua'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Selamat datang di Dashboard Orang Tua!',
            style: TextStyle(fontSize: 18)),
      ),
    );
  }
}