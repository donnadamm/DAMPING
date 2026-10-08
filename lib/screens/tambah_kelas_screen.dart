import 'package:flutter/material.dart';

class TambahKelasScreen extends StatefulWidget {
  const TambahKelasScreen({super.key});

  @override
  State<TambahKelasScreen> createState() => _TambahKelasScreenState();
}

class _TambahKelasScreenState extends State<TambahKelasScreen> {
  final _namaKelasController = TextEditingController();
  final _jumlahSiswaController = TextEditingController();
  // Solusi: Gunakan controller khusus untuk Tahun Ajaran
  final _tahunAjaranController = TextEditingController(text: '2025/2026');
  String _selectedWali = 'Bu Dona';

  @override
  void dispose() {
    _namaKelasController.dispose();
    _jumlahSiswaController.dispose();
    _tahunAjaranController.dispose(); // Pastikan di-dispose
    super.dispose();
  }

  void _simpanKelas() {
    if (_namaKelasController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Nama kelas wajib diisi!'),
            backgroundColor: Colors.redAccent),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Kelas berhasil ditambahkan!'),
          backgroundColor: Colors.green),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tambah Kelas',
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
            _buildLabel('Nama Kelas *'),
            _buildTextField(
                controller: _namaKelasController,
                hint: 'Contoh: X RPL 1',
                icon: Icons.class_outlined),
            const SizedBox(height: 20),
            _buildLabel('Wali Kelas *'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedWali,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF2C7DEB)),
                  items: [
                    'Bu Dona',
                    'Pak Budi',
                    'Bu Sari',
                    'Pak Ahmad',
                    'Bu Risa'
                  ].map((String wali) {
                    return DropdownMenuItem<String>(
                      value: wali,
                      child: Text(wali, style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedWali = val!),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel('Tahun Ajaran *'),
            _buildTextField(
                controller: _tahunAjaranController,
                hint: '2025/2026',
                icon: Icons.calendar_today_outlined),
            const SizedBox(height: 20),
            _buildLabel('Jumlah Siswa *'),
            _buildTextField(
                controller: _jumlahSiswaController,
                hint: 'Masukkan jumlah siswa',
                icon: Icons.group_outlined,
                isNumber: true),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(12)),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: Color(0xFF2C7DEB), size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Setelah kelas dibuat, Anda dapat menambahkan data siswa melalui Kelola Data Siswa.',
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
                onPressed: _simpanKelas,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C7DEB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Simpan Kelas',
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
      bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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