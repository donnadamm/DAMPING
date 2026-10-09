import 'package:flutter/material.dart';

class DashboardParentScreen extends StatefulWidget {
  const DashboardParentScreen({super.key});

  @override
  State<DashboardParentScreen> createState() => _DashboardParentScreenState();
}

class _DashboardParentScreenState extends State<DashboardParentScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Daftar halaman untuk Bottom Navigation Orang Tua
    final List<Widget> pages = [
      _BerandaParentContent(
        onNavigate: (index) => setState(() => _selectedIndex = index),
      ),
      const Scaffold(
          body: Center(child: Text('Halaman Notifikasi Belum Dibuat'))),
      const Scaffold(body: Center(child: Text('Halaman Riwayat Belum Dibuat'))),
      const Scaffold(body: Center(child: Text('Halaman Profil Belum Dibuat'))),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),

      // Menampilkan halaman sesuai tab yang aktif
      body: pages[_selectedIndex],

      // Bottom Navigation Bar Orang Tua (4 Menu)
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
              icon: Icon(Icons.notifications_none_rounded),
              label: 'Notifikasi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: 'Riwayat',
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
}

// ==========================================================
// KONTEN BERANDA ORANG TUA
// ==========================================================
class _BerandaParentContent extends StatelessWidget {
  final Function(int) onNavigate;

  const _BerandaParentContent({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),

      // HEADER PROFIL CUSTOM
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(110), // <-- Tinggi diperbesar agar lega
        child: Container(
          // Menggunakan MediaQuery agar padding atas otomatis menyesuaikan (Aman untuk HP maupun Web)
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              left: 20,
              right: 20,
              bottom: 20),
          decoration: const BoxDecoration(
            color: Color(0xFF2C7DEB),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment
                .center, // Memastikan konten rata tengah secara vertikal
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'), // Placeholder Ibu
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize
                      .min, // Penting agar tinggi kolom menyesuaikan teks
                  children: [
                    Text(
                      'Halo, Ibu Sari',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Orang Tua dari Andi Pratama',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => onNavigate(1), // Pindah ke tab notifikasi
                icon: const Icon(Icons.notifications_none_rounded,
                    color: Colors.white),
              )
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KARTU IDENTITAS ANAK
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
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
                    child: const Center(
                      child: Text('A',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C7DEB))),
                    ),
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
                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.grey, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // KARTU SKOR PELANGGARAN
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFE8C7), width: 1.5),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Skor',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFF64748B))),
                          SizedBox(height: 4),
                          Text('35 Poin',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF163B75))),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE8C7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Text('Status: ',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xFFE88A00))),
                            Text('SP 1',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE88A00))),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Menuju SP 2 (50 poin)',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFF64748B))),
                      Text('35 / 50',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF163B75))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 35 / 50,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFE88A00)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // JUDUL NOTIFIKASI TERBARU
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notifikasi Terbaru',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF163B75)),
                ),
                TextButton(
                  onPressed: () => onNavigate(1), // Ke tab Notifikasi
                  child: const Text('Lihat Semua >',
                      style: TextStyle(
                          color: Color(0xFF2C7DEB),
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // KARTU NOTIFIKASI ALERT
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFF2C7DEB).withValues(alpha: 0.2)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Color(0xFFE8F1FF), shape: BoxShape.circle),
                        child: const Icon(Icons.notifications_active_outlined,
                            color: Color(0xFF2C7DEB), size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Pelanggaran Baru',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF163B75))),
                                Text('+5 poin',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.redAccent)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Andi Pratama melakukan pelanggaran "Terlambat masuk sekolah".',
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 13,
                                  height: 1.4),
                            ),
                            const SizedBox(height: 8),
                            Text('12 Sep 2026 • 08:15',
                                style: TextStyle(
                                    color: Colors.grey.shade500, fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        // Nanti arahkan ke Detail Parent Alert
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C7DEB),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: const Text('Lihat Detail',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
