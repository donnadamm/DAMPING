import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pastikan menambahkan package intl di pubspec.yaml jika belum ada

class CatatPelanggaranScreen extends StatefulWidget {
  final String namaSiswa;
  final String kelasSiswa;
  final String fotoSiswaInitials;

  // Constructor menerima data siswa (bisa disesuaikan nanti jika pakai database asli)
  const CatatPelanggaranScreen({
    super.key,
    this.namaSiswa = 'Rizky Ardiansyah',
    this.kelasSiswa = 'X RPL 1',
    this.fotoSiswaInitials = 'R',
  });

  @override
  State<CatatPelanggaranScreen> createState() => _CatatPelanggaranScreenState();
}

class _CatatPelanggaranScreenState extends State<CatatPelanggaranScreen> {
  String? _selectedPelanggaran;
  final TextEditingController _poinController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // Daftar Dummy Pelanggaran & Poinnya
  final List<Map<String, dynamic>> _listJenisPelanggaran = [
    {'jenis': 'Terlambat masuk sekolah', 'poin': '5'},
    {'jenis': 'Tidak memakai atribut', 'poin': '5'},
    {'jenis': 'Tidak mengerjakan tugas', 'poin': '10'},
    {'jenis': 'Membolos', 'poin': '20'},
    {'jenis': 'Berkelahi', 'poin': '50'},
  ];

  @override
  void dispose() {
    _poinController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  // Fungsi untuk memunculkan Date Picker
  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2C7DEB), // Warna header
              onPrimary: Colors.white, // Warna teks header
              onSurface: Color(0xFF0C356A), // Warna teks tanggal
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _simpanPelanggaran() {
    if (_selectedPelanggaran == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Pilih jenis pelanggaran terlebih dahulu!'),
            backgroundColor: Colors.redAccent),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Pelanggaran berhasil dicatat!'),
          backgroundColor: Colors.green),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM yyyy').format(_selectedDate);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Catat Pelanggaran',
          style: TextStyle(
              color: Color(0xFF0C356A),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
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
            // 1. KARTU INFO SISWA (Sesuai Mockup)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFFE8F1FF),
                    child: Text(
                      widget.fotoSiswaInitials,
                      style: const TextStyle(
                          color: Color(0xFF2C7DEB),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.namaSiswa,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF0C356A)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.kelasSiswa,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Nanti diarahkan ke halaman Detail Siswa
                    },
                    icon: const Icon(Icons.remove_red_eye_outlined,
                        size: 16, color: Color(0xFF2C7DEB)),
                    label: const Text('Lihat Detail',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF2C7DEB))),
                  )
                ],
              ),
            ),
            const SizedBox(height: 28),

            // 2. FORM JENIS PELANGGARAN
            _buildLabel('Jenis Pelanggaran *'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedPelanggaran,
                  hint: Text('Pilih jenis pelanggaran',
                      style:
                          TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF2C7DEB)),
                  items: _listJenisPelanggaran.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['jenis'],
                      child: Text(item['jenis'],
                          style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedPelanggaran = val;
                      // Otomatis mengisi poin berdasarkan jenis pelanggaran yang dipilih
                      var selectedItem = _listJenisPelanggaran
                          .firstWhere((element) => element['jenis'] == val);
                      _poinController.text = selectedItem['poin'];
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. FORM TANGGAL
            _buildLabel('Tanggal *'),
            GestureDetector(
              onTap: () => _pilihTanggal(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: TextEditingController(text: formattedDate),
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.calendar_today_outlined,
                        color: Color(0xFF2C7DEB), size: 20),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 4. FORM POIN PELANGGARAN (Otomatis/Read Only)
            _buildLabel('Poin Pelanggaran *'),
            TextField(
              controller: _poinController,
              readOnly: true, // Tidak bisa diedit manual
              decoration: InputDecoration(
                hintText: 'Pilih poin',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200)),
              ),
            ),
            const SizedBox(height: 20),

            // 5. FORM CATATAN
            _buildLabel('Catatan (opsional)'),
            TextField(
              controller: _catatanController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Masukkan catatan tambahan...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF2C7DEB), width: 1.5)),
              ),
            ),
            const SizedBox(height: 40),

            // 6. TOMBOL SIMPAN
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _simpanPelanggaran,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C7DEB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Simpan',
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
      child: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Color(0xFF0C356A)),
      ),
    );
  }
}