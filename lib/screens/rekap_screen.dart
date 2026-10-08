import 'package:flutter/material.dart';

class RekapScreen extends StatefulWidget {
  const RekapScreen({super.key});

  @override
  State<RekapScreen> createState() => _RekapScreenState();
}

class _RekapScreenState extends State<RekapScreen> {
  String _selectedFilter = 'Bulan Ini';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Dihilangkan karena bagian dari Bottom Navigation
        title: const Text(
          'Rekap Laporan',
          style: TextStyle(
            color: Color(0xFF0C356A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Laporan PDF sedang diunduh...'),
                    backgroundColor: Colors.green),
              );
            },
            icon: const Icon(Icons.print_outlined, color: Color(0xFF2C7DEB)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Waktu (Pill Tabs)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  'Minggu Ini',
                  'Bulan Ini',
                  'Semester 1',
                  'Tahun 2026'
                ].map((filter) {
                  bool isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF2C7DEB)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF2C7DEB)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade600,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Ringkasan Cepat
            Row(
              children: [
                Expanded(
                    child: _buildSummaryCard('Total Kasus', '145',
                        Icons.assignment_late_outlined, Colors.redAccent)),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildSummaryCard('Siswa di-SP', '12',
                        Icons.warning_amber_rounded, Colors.orange)),
              ],
            ),
            const SizedBox(height: 24),

            // Statistik Jenis Pelanggaran (Progress Bar)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kasus Sering Terjadi',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0C356A)),
                  ),
                  const SizedBox(height: 16),
                  _buildStatBar('Terlambat Masuk', 65, 100, Colors.redAccent),
                  _buildStatBar('Tidak Bawa Atribut', 40, 100, Colors.orange),
                  _buildStatBar('Membolos', 25, 100, const Color(0xFF2C7DEB)),
                  _buildStatBar(
                      'Tidak Mengerjakan Tugas', 15, 100, Colors.purple),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Kelas dengan Pelanggaran Terbanyak
            const Text(
              'Kelas Pelanggaran Terbanyak',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C356A)),
            ),
            const SizedBox(height: 12),
            _buildRankItem('1', 'X RPL 1', '45 Pelanggaran', 'Wali: Bu Dona'),
            _buildRankItem(
                '2', 'XI TKJ 2', '38 Pelanggaran', 'Wali: Pak Ahmad'),
            _buildRankItem('3', 'XII RPL 1', '22 Pelanggaran', 'Wali: Bu Risa'),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // WIDGET BANTUAN: KARTU RINGKASAN
  Widget _buildSummaryCard(
      String title, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(count,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  // WIDGET BANTUAN: GRAFIK BAR HORIZONTAL
  Widget _buildStatBar(String title, int value, int maxValue, Color color) {
    double percent = value / maxValue;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0C356A))),
              Text('$value Kasus',
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET BANTUAN: LIST RANKING KELAS
  Widget _buildRankItem(
      String rank, String title, String subTitle, String wali) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F1FF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rank,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C7DEB),
                    fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF0C356A))),
                const SizedBox(height: 2),
                Text(wali,
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
          Text(
            subTitle,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
                fontSize: 12),
          ),
        ],
      ),
    );
  }
}