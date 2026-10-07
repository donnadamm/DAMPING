import 'package:flutter/material.dart';
import 'package:damping_app/data/dummy_data.dart';

class TambahPenggunaScreen extends StatefulWidget {
  const TambahPenggunaScreen({super.key});

  @override
  State<TambahPenggunaScreen> createState() => _TambahPenggunaScreenState();
}

class _TambahPenggunaScreenState extends State<TambahPenggunaScreen> {
  final _namaController = TextEditingController();
  final _hpController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Guru'; // Default pilihan role

  @override
  void dispose() {
    _namaController.dispose();
    _hpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _simpanPengguna() {
    if (_namaController.text.isEmpty || _hpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Nama dan Nomor HP wajib diisi!'),
            backgroundColor: Colors.redAccent),
      );
      return;
    }

    // Menambah data ke Dummy Database sesuai Role
    Map<String, dynamic> newUser = {
      'nama': _namaController.text.trim(),
      'hp': _hpController.text.trim(),
      'role':
          _selectedRole == 'Guru' ? 'Guru - Wali Kelas (Baru)' : 'Orang Tua',
    };

    if (_selectedRole == 'Guru') {
      DummyData.guru.add(newUser);
    } else if (_selectedRole == 'Orang Tua') {
      DummyData.orangTua.add(newUser);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Pengguna berhasil ditambahkan!'),
          backgroundColor: Colors.green),
    );

    // Kembali ke halaman sebelumnya dan mengirim sinyal (true) bahwa ada data baru
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tambah Pengguna',
            style: TextStyle(
                color: Color(0xFF0C356A),
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0C356A),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Nama Lengkap *'),
            _buildTextField(
                controller: _namaController,
                hint: 'Masukkan nama lengkap',
                icon: Icons.person_outline),
            const SizedBox(height: 20),

            _buildLabel('Nomor HP *'),
            _buildTextField(
                controller: _hpController,
                hint: '081xxxxxxxxxx',
                icon: Icons.phone_outlined,
                isNumber: true),
            const SizedBox(height: 20),

            _buildLabel('Password *'),
            _buildTextField(
                controller: _passwordController,
                hint: 'Minimal 6 karakter',
                icon: Icons.lock_outline,
                isObscure: true),
            const SizedBox(height: 20),

            _buildLabel('Role *'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedRole,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF2C7DEB)),
                  items: ['Guru', 'Orang Tua', 'Admin'].map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Row(
                        children: [
                          Icon(
                            role == 'Guru'
                                ? Icons.school_outlined
                                : role == 'Orang Tua'
                                    ? Icons.family_restroom
                                    : Icons.admin_panel_settings_outlined,
                            color: const Color(0xFF2C7DEB),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(role, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRole = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Info Box Biru (seperti di mockup)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: Color(0xFF2C7DEB), size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Untuk orang tua, pastikan sudah terdaftar sebagai wali dari siswa.',
                      style: TextStyle(
                          color: Color(0xFF1E56A0), fontSize: 12, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _simpanPengguna,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C7DEB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Simpan Pengguna',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Color(0xFF0C356A))),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String hint,
      required IconData icon,
      bool isNumber = false,
      bool isObscure = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2C7DEB), width: 1.5)),
      ),
    );
  }
}
