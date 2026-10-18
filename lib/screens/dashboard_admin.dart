import 'package:flutter/material.dart';
import 'kelola_pengguna_screen.dart';
import 'kelola_data_siswa_screen.dart';
import 'pelanggaran_screen.dart';
import 'rekap_screen.dart';
import 'pengaturan_screen.dart';
import 'profil_admin_screen.dart';
import 'notifikasi_screen.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 1. DAFTAR HALAMAN UNTUK BOTTOM NAVIGATION
    final List<Widget> pages = [
      _BerandaAdminContent(
        onNavigate: (index) => setState(() => _selectedIndex = index),
      ),
      const PelanggaranScreen(),
      const RekapScreen(),
      const PengaturanScreen(),
      const ProfilAdminScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      body: pages[_selectedIndex],

      // 2. BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5)),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF246BCE),
          unselectedItemColor: Colors.grey.shade400,
          showUnselectedLabels: true,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: 'Beranda'),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_late_outlined),
                label: 'Pelanggaran'),
            BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart_outline), label: 'Rekap'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined), label: 'Pengaturan'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// KONTEN BERANDA ADMIN (Tampilan Utama Dashboard)
// ==========================================================
class _BerandaAdminContent extends StatelessWidget {
  final Function(int) onNavigate;

  const _BerandaAdminContent({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 3. HEADER MELENGKUNG BIRU
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 20,
                  right: 20,
                  bottom: 40),
              decoration: const BoxDecoration(
                color: Color(0xFF246BCE),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child:
                        Icon(Icons.person, size: 30, color: Color(0xFF246BCE)),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Halo, Admin 👋',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(height: 4),
                        Text('Administrator Sekolah',
                            style:
                                TextStyle(fontSize: 14, color: Colors.white70)),
                      ],
                    ),
                  ),
                  // Tombol Notifikasi (Lonceng)
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotifikasiScreen()));
                      },
                      icon: const Icon(Icons.notifications_none_rounded,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            ),

            // 4. GRID KARTU STATISTIK
            Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    _buildStatCard(
                      context,
                      'Total Siswa',
                      '4',
                      Icons.person_outline,
                      const Color(0xFF246BCE),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const KelolaDataSiswaScreen())),
                    ),
                    _buildStatCard(
                      context,
                      'Total Guru',
                      '2',
                      Icons.school_outlined,
                      const Color(0xFF246BCE),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const KelolaPenggunaScreen())),
                    ),
                    _buildStatCard(
                      context,
                      'Total Orang Tua',
                      '3',
                      Icons.family_restroom_outlined,
                      const Color(0xFFF59E0B),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const KelolaPenggunaScreen())),
                    ),
                    _buildStatCard(
                      context, 'Total Pelanggaran', '3',
                      Icons.warning_amber_rounded, const Color(0xFFE83E8C),
                      onTap: () => onNavigate(1), // Geser ke Tab Pelanggaran
                    ),
                  ],
                ),
              ),
            ),

            // 5. HEADER PELANGGARAN TERBARU
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pelanggaran Terbaru',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF163B75))),
                  TextButton(
                    onPressed: () => onNavigate(1), // Geser ke Tab Pelanggaran
                    child: const Text('Lihat Semua >',
                        style: TextStyle(
                            color: Color(0xFF246BCE),
                            fontSize: 13,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // 6. LIST PELANGGARAN TERBARU
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildViolationItem(
                      'A',
                      'Andi Pratama',
                      'Terlambat masuk sekolah\n12 Sep 2026 • 5 poin',
                      'SP 1',
                      const Color(0xFFFFE1E5),
                      const Color(0xFFE83E8C)),
                  _buildViolationItem(
                      'C',
                      'Citra Lestari',
                      'Membolos\n10 Sep 2026 • 20 poin',
                      'SP 2',
                      const Color(0xFFFFE8C7),
                      const Color(0xFFF59E0B)),
                  _buildViolationItem(
                      'B',
                      'Budi Santoso',
                      'Tidak memakai atribut\n09 Sep 2026 • 5 poin',
                      'Normal',
                      const Color(0xFFDDF5E3),
                      const Color(0xFF42A85F)),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // WIDGET REUSABLE (Fungsi untuk mencegah kode berulang)
  // ==========================================================

  Widget _buildStatCard(BuildContext context, String title, String count,
      IconData icon, Color iconColor,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(title,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600))),
                Icon(icon, color: iconColor, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Text(count,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163B75))),
          ],
        ),
      ),
    );
  }

  Widget _buildViolationItem(String initial, String name, String desc,
      String status, Color statusBg, Color statusText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 5,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFF246BCE).withValues(alpha: 0.1),
            child: Text(initial,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF246BCE),
                    fontSize: 16)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF163B75))),
                const SizedBox(height: 4),
                Text(desc,
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                        height: 1.4)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: statusBg, borderRadius: BorderRadius.circular(20)),
            child: Text(status,
                style: TextStyle(
                    color: statusText,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
