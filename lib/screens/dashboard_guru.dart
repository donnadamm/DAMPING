import 'package:flutter/material.dart';
import 'pelanggaran_screen.dart';

class DashboardGuruScreen extends StatefulWidget {
  const DashboardGuruScreen({super.key});

  @override
  State<DashboardGuruScreen> createState() => _DashboardGuruScreenState();
}

class _DashboardGuruScreenState extends State<DashboardGuruScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),

      // =========================
      // APP BAR
      // =========================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF2C7DEB),
        foregroundColor: Colors.white,
        title: const Text(
          'Dashboard Guru',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =========================
      // BODY (KONTEN BERANDA)
      // =========================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SAPAAN
            const Text(
              'Halo, Bu Dona 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF163B75),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Selamat datang di DAMPING',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 25),

            // STATISTIK
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.people,
                    title: 'Total Siswa',
                    value: '32',
                    color: const Color(0xFF2C7DEB),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.warning_amber_rounded,
                    title: 'Pelanggaran',
                    value: '3',
                    color: const Color(0xFFE88A00),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.calendar_month,
                    title: 'Bulan Ini',
                    value: '25',
                    color: const Color(0xFF27A9D6),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.warning,
                    title: 'Siswa SP',
                    value: '2',
                    color: const Color(0xFFE5394F),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // JUDUL PELANGGARAN
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pelanggaran Terbaru',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163B75),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PelanggaranScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Lihat Semua >',
                    style: TextStyle(
                      color: Color(0xFF2C7DEB),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // CARD PELANGGARAN
            _buildViolationCard(
              nama: 'Andi Pratama',
              pelanggaran: 'Terlambat masuk sekolah',
              tanggal: '12 Sep 2026',
              poin: '5 poin',
              status: 'SP 1',
              statusColor: const Color(0xFFFFE1E5),
              statusTextColor: const Color(0xFFE5394F),
            ),
            _buildViolationCard(
              nama: 'Citra Lestari',
              pelanggaran: 'Membolos',
              tanggal: '10 Sep 2026',
              poin: '20 poin',
              status: 'SP 2',
              statusColor: const Color(0xFFFFE8C7),
              statusTextColor: const Color(0xFFE88A00),
            ),
            _buildViolationCard(
              nama: 'Budi Santoso',
              pelanggaran: 'Tidak memakai atribut',
              tanggal: '09 Sep 2026',
              poin: '5 poin',
              status: 'Normal',
              statusColor: const Color(0xFFDDF5E3),
              statusTextColor: const Color(0xFF42A85F),
            ),
            const SizedBox(height: 25),

            // TOMBOL KELOLA PELANGGARAN
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PelanggaranScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.warning_amber_rounded),
                label: const Text(
                  'Kelola Pelanggaran',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C7DEB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // =========================
      // BOTTOM NAVIGATION BAR
      // =========================
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });

            // Logika perpindahan halaman saat menu diklik
            if (index == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PelanggaranScreen()));
            } else if (index == 2) {
              // TODO: Arahkan ke Rekap Guru
            } else if (index == 3) {
              // TODO: Arahkan ke Notifikasi
            } else if (index == 4) {
              // TODO: Arahkan ke Profil Guru
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF2C7DEB),
          unselectedItemColor: Colors.grey.shade400,
          showUnselectedLabels: true,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.rule_folder_outlined),
              label: 'Pelanggaran',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_outline),
              label: 'Rekap',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_rounded),
              label: 'Notifikasi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // WIDGET BANTUAN STATISTIK & CARD
  // ==========================================================
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              Icon(icon, color: color, size: 25),
            ],
          ),
          const SizedBox(height: 12),
          Text(value,
              style: TextStyle(
                  fontSize: 27, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildViolationCard({
    required String nama,
    required String pelanggaran,
    required String tanggal,
    required String poin,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFFE5F0FF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                nama[0],
                style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C7DEB)),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nama,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF163B75))),
                const SizedBox(height: 4),
                Text(pelanggaran,
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF64748B))),
                const SizedBox(height: 5),
                Text('$tanggal • $poin',
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: statusTextColor),
            ),
          ),
        ],
      ),
    );
  }
}
