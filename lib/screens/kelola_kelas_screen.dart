import 'package:flutter/material.dart';

class KelolaKelasScreen extends StatefulWidget {
  const KelolaKelasScreen({super.key});

  @override
  State<KelolaKelasScreen> createState() => _KelolaKelasScreenState();
}

class _KelolaKelasScreenState extends State<KelolaKelasScreen> {
  // Data dummy untuk daftar kelas
  final List<Map<String, dynamic>> _listKelas = [
    {
      'nama': 'X RPL 1',
      'wali': 'Bu Dona',
      'jumlahSiswa': '32 Siswa',
      'warna': Colors.blue
    },
    {
      'nama': 'X RPL 2',
      'wali': 'Pak Budi',
      'jumlahSiswa': '30 Siswa',
      'warna': Colors.blue
    },
    {
      'nama': 'XI RPL 1',
      'wali': 'Bu Sari',
      'jumlahSiswa': '28 Siswa',
      'warna': Colors.purple
    },
    {
      'nama': 'XI RPL 2',
      'wali': 'Pak Ahmad',
      'jumlahSiswa': '35 Siswa',
      'warna': Colors.orange
    },
    {
      'nama': 'XII RPL 1',
      'wali': 'Bu Risa',
      'jumlahSiswa': '34 Siswa',
      'warna': Colors.redAccent
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Kelola Kelas',
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
      body: Column(
        children: [
          // Search Bar & Tombol Tambah Kelas
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari nama kelas...',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade400, fontSize: 13),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigasi ke Form Tambah Kelas
                  },
                  icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: const Text('Tambah Kelas',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C7DEB),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),

          // Daftar Kelas (ListView)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: _listKelas.length,
              itemBuilder: (context, index) {
                var kelas = _listKelas[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 5,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: kelas['warna'].withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.class_outlined,
                            color: kelas['warna'], size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kelas['nama'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFF0C356A)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Wali Kelas: ${kelas['wali']} • ${kelas['jumlahSiswa']}',
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.grey, size: 16),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
