import 'package:flutter/material.dart';
import 'package:damping_app/data/dummy_data.dart';
import 'kelola_pengguna_screen.dart';
import 'kelola_kelas_screen.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF8FAFC), // Warna latar belakang abu-abu sangat muda
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER (Bagian Atas Biru Melengkung)
            Container(
              padding: const EdgeInsets.only(
                  top: 60, left: 24, right: 24, bottom: 40),
              decoration: const BoxDecoration(
                color: Color(0xFF2C7DEB),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                        'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'), // Placeholder profil
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, Admin 👋',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Administrator Sekolah',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_none_rounded,
                        color: Colors.white),
                  ),
                ],
              ),
            ),

            // 2. KARTU STATISTIK (Grid 2x2)
            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Angka diambil dari jumlah data siswa
                        Expanded(
                            child: _buildStatCard(
                                'Total Siswa',
                                DummyData.siswa.length.toString(),
                                Icons.person_outline,
                                const Color(0xFF2C7DEB))),
                        const SizedBox(width: 16),
                        // Angka diambil dari jumlah data guru
                        Expanded(
                            child: _buildStatCard(
                                'Total Guru',
                                DummyData.guru.length.toString(),
                                Icons.school_outlined,
                                const Color(0xFF2C7DEB))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Angka diambil dari jumlah data orang tua
                        Expanded(
                            child: _buildStatCard(
                                'Total Orang Tua',
                                DummyData.orangTua.length.toString(),
                                Icons.family_restroom,
                                Colors.orange)),
                        const SizedBox(width: 16),
                        // Angka diambil dari jumlah data pelanggaran
                        Expanded(
                            child: _buildStatCard(
                                'Total Pelanggaran',
                                DummyData.pelanggaran.length.toString(),
                                Icons.warning_amber_rounded,
                                Colors.redAccent)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 3. DAFTAR PELANGGARAN TERBARU
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pelanggaran Terbaru',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0C356A)),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Lihat Semua >',
                        style:
                            TextStyle(color: Color(0xFF2C7DEB), fontSize: 13)),
                  ),
                ],
              ),
            ),

            // List Pelanggaran Dinamis
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: DummyData.pelanggaran.map((data) {
                  // Logika sederhana untuk menentukan warna badge
                  Color badgeBg = Colors.green.shade100;
                  Color badgeText = Colors.green;
                  if (data['status'] == 'SP 1') {
                    badgeBg = Colors.red.shade100;
                    badgeText = Colors.red;
                  } else if (data['status'] == 'SP 2') {
                    badgeBg = Colors.orange.shade100;
                    badgeText = Colors.orange.shade800;
                  }

                  return _buildViolationItem(data['nama'], data['kasus'],
                      data['status'], badgeBg, badgeText);
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // 4. AKSES CEPAT
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Akses Cepat',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0C356A)),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const KelolaKelasScreen()),
                        );
                      },
                      child: _buildQuickAccessBtn(
                          Icons.folder_shared_outlined, 'Kelola Data Kelas'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _buildQuickAccessBtn(
                          Icons.folder_shared_outlined, 'Kelola Data Siswa')),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),

      // 5. BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
          },
          type: BottomNavigationBarType
              .fixed, // Wajib 'fixed' agar label 5 menu tetap terlihat
          selectedItemColor: const Color(0xFF2C7DEB),
          unselectedItemColor: Colors.grey.shade400,
          showUnselectedLabels: true,
          selectedFontSize:
              11, // Diperkecil sedikit agar 5 menu tidak berdesakan
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: 'Beranda'),
            BottomNavigationBarItem(
                icon: Icon(Icons
                    .rule_folder_outlined), // Sesuai ikon pelanggaran/aturan
                label: 'Pelanggaran'),
            BottomNavigationBarItem(
                icon: Icon(
                    Icons.pie_chart_outline), // Sesuai ikon rekap/statistik
                label: 'Rekap'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined), label: 'Pengaturan'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'Profil'),
          ],
        ),
      ),
    );
  }

  // WIDGET BANTUAN: KARTU STATISTIK
  Widget _buildStatCard(
      String title, String count, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              Expanded(
                // <-- Ditambahkan Expanded agar aman dari overflow
                child: Text(title,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                    overflow: TextOverflow.ellipsis),
              ),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C356A)),
          ),
        ],
      ),
    );
  }

  // WIDGET BANTUAN: DAFTAR PELANGGARAN
  Widget _buildViolationItem(String name, String desc, String status,
      Color badgeBgColor, Color badgeTextColor) {
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
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFE8F1FF),
            child: Text(name[0],
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF2C7DEB))),
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
                        color: Color(0xFF0C356A))),
                const SizedBox(height: 4),
                Text(desc,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black54, height: 1.4)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: badgeTextColor),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET BANTUAN: TOMBOL AKSES CEPAT
  Widget _buildQuickAccessBtn(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF2C7DEB), size: 24),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C356A)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
