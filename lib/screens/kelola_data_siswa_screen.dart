import 'package:flutter/material.dart';

class KelolaDataSiswaScreen extends StatefulWidget {
  const KelolaDataSiswaScreen({super.key});

  @override
  State<KelolaDataSiswaScreen> createState() => _KelolaDataSiswaScreenState();
}

class _KelolaDataSiswaScreenState extends State<KelolaDataSiswaScreen> {
  final List<Map<String, dynamic>> _listSiswa = [
    {
      'nama': 'Andi Pratama',
      'kelas': 'X RPL 1',
      'nis': '001',
      'status': 'SP 1',
      'warnaStatus': Colors.redAccent
    },
    {
      'nama': 'Budi Santoso',
      'kelas': 'X RPL 1',
      'nis': '002',
      'status': 'Normal',
      'warnaStatus': Colors.green
    },
    {
      'nama': 'Citra Lestari',
      'kelas': 'X RPL 1',
      'nis': '003',
      'status': 'SP 2',
      'warnaStatus': Colors.orange
    },
    {
      'nama': 'Deni Kurniawan',
      'kelas': 'X RPL 2',
      'nis': '004',
      'status': 'Normal',
      'warnaStatus': Colors.green
    },
    {
      'nama': 'Eka Putri',
      'kelas': 'X RPL 2',
      'nis': '005',
      'status': 'SP 1',
      'warnaStatus': Colors.redAccent
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Kelola Data Siswa',
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
          // Search & Filter Kelas
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari nama siswa...',
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
                  },
                  icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: const Text('Tambah Siswa',
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

          // List Siswa
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: _listSiswa.length,
              itemBuilder: (context, index) {
                var siswa = _listSiswa[index];
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: const Color(0xFFE8F1FF),
                        child: Text(
                          siswa['nama'][0],
                          style: const TextStyle(
                              color: Color(0xFF2C7DEB),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        siswa['nama'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0C356A),
                            fontSize: 14),
                      ),
                      subtitle: Text(
                        '${siswa['kelas']} • NIS: ${siswa['nis']}',
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            height: 1.4),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: siswa['warnaStatus'].withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          siswa['status'],
                          style: TextStyle(
                              color: siswa['warnaStatus'],
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey.shade200),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
