import 'package:flutter/material.dart';

class RekapGuruScreen extends StatelessWidget {
  const RekapGuruScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF163B75),
        automaticallyImplyLeading:
            false, // Tidak butuh tombol back karena di menu bawah
        title: const Text(
          'Rekapitulasi Pelanggaran',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Tanggal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1 Sep 2026 - 30 Sep 2026',
                      style:
                          TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Filter Kelas & Jenis
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Semua Kelas',
                            style: TextStyle(
                                color: Colors.grey.shade700, fontSize: 13)),
                        const Icon(Icons.keyboard_arrow_down,
                            color: Colors.grey, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Semua Jenis',
                            style: TextStyle(
                                color: Colors.grey.shade700, fontSize: 13)),
                        const Icon(Icons.keyboard_arrow_down,
                            color: Colors.grey, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Kartu Total (Grid 4 Kotak)
            Row(
              children: [
                Expanded(
                    child: _buildSummaryBox('Total\nPelanggaran', '52',
                        const Color(0xFF2C7DEB), Colors.blue.shade50)),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildSummaryBox('SP 1', '28',
                        const Color(0xFFE5394F), const Color(0xFFFFE1E5))),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildSummaryBox('SP 2', '16',
                        const Color(0xFFE88A00), const Color(0xFFFFE8C7))),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildSummaryBox('Normal', '8',
                        const Color(0xFF42A85F), const Color(0xFFDDF5E3))),
              ],
            ),
            const SizedBox(height: 30),

            // Grafik Pelanggaran per Kelas
            const Text(
              'Grafik Pelanggaran per Kelas',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF163B75)),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Column(
                children: [
                  _buildBarItem('X RPL 1', 18, 20, const Color(0xFF2C7DEB)),
                  _buildBarItem('X RPL 2', 14, 20, const Color(0xFFE5394F)),
                  _buildBarItem('XI RPL 1', 11, 20, const Color(0xFFE88A00)),
                  _buildBarItem('XI RPL 2', 9, 20, const Color(0xFF27A9D6)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Jenis Pelanggaran Terbanyak
            const Text(
              'Jenis Pelanggaran Terbanyak',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF163B75)),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Column(
                children: [
                  _buildViolationList('Terlambat masuk sekolah', '20 (38%)',
                      const Color(0xFF2C7DEB)),
                  _buildViolationList('Tidak memakai atribut', '12 (23%)',
                      const Color(0xFFE5394F)),
                  _buildViolationList(
                      'Membolos', '8 (15%)', const Color(0xFFE88A00)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBox(
      String title, String value, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11,
                  color: textColor.withValues(alpha: 0.8),
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }

  Widget _buildBarItem(String title, int value, int max, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(
              width: 60,
              child: Text(title,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: value / max,
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(value.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF163B75))),
        ],
      ),
    );
  }

  Widget _buildViolationList(String title, String value, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
              width: 10,
              height: 10,
              decoration:
                  BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(
              child: Text(title,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700))),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF163B75))),
        ],
      ),
    );
  }
}
