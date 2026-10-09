import 'package:flutter/material.dart';

class RiwayatParentScreen extends StatelessWidget {
  const RiwayatParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF163B75),
        elevation: 0,
        title: const Text(
          'Riwayat Pelanggaran',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: Column(
        children: [
          // Header Identitas Anak
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                      color: Color(0xFFE5F0FF), shape: BoxShape.circle),
                  child: const Center(
                      child: Text('A',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C7DEB)))),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Andi Pratama',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF163B75))),
                      SizedBox(height: 4),
                      Text('X RPL 1',
                          style: TextStyle(
                              fontSize: 13, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Filter Kategori
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Semua Kategori',
                      style: TextStyle(color: Colors.black87, fontSize: 13)),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // List Riwayat
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildRiwayatItem(
                    '12 Sep 2026',
                    'Terlambat masuk sekolah',
                    '+5 poin',
                    'SP 1',
                    const Color(0xFFFFE1E5),
                    const Color(0xFFE5394F)),
                _buildRiwayatItem(
                    '10 Sep 2026',
                    'Tidak memakai atribut lengkap',
                    '+5 poin',
                    'Normal',
                    const Color(0xFFDDF5E3),
                    const Color(0xFF42A85F)),
                _buildRiwayatItem(
                    '08 Sep 2026',
                    'Membolos saat jam pelajaran',
                    '+20 poin',
                    'SP 2',
                    const Color(0xFFFFE8C7),
                    const Color(0xFFE88A00)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatItem(String date, String title, String poin,
      String status, Color statusBg, Color statusText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date,
                    style:
                        TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                const SizedBox(height: 6),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF163B75))),
                const SizedBox(height: 6),
                Text(poin,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.redAccent)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
                color: statusBg, borderRadius: BorderRadius.circular(20)),
            child: Text(status,
                style: TextStyle(
                    color: statusText,
                    fontWeight: FontWeight.bold,
                    fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
