import 'package:flutter/material.dart';
import 'kelola_pengguna_screen.dart';
import 'kelola_data_siswa_screen.dart';
import 'pelanggaran_screen.dart';
import 'rekap_screen.dart';
import 'pengaturan_screen.dart';
import 'profil_admin_screen.dart';
import 'notifikasi_screen.dart';
import '../services/local_database.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _BerandaAdminContent(
        onNavigate: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
      const PelanggaranScreen(),
      const RekapScreen(),
      const PengaturanScreen(),
      const ProfilAdminScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
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
            setState(() => _selectedIndex = index);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF246BCE),
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
              icon: Icon(Icons.assignment_late_outlined),
              label: 'Pelanggaran',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_outline),
              label: 'Rekap',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'Pengaturan',
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
// KONTEN BERANDA ADMIN
// ==========================================================

class _BerandaAdminContent extends StatefulWidget {
  final Function(int) onNavigate;

  const _BerandaAdminContent({
    required this.onNavigate,
  });

  @override
  State<_BerandaAdminContent> createState() => _BerandaAdminContentState();
}

class _BerandaAdminContentState extends State<_BerandaAdminContent> {
  static const Color primaryBlue = Color(0xFF246BCE);
  static const Color deepBlue = Color(0xFF163B75);
  static const Color backgroundColor = Color(0xFFF5F8FC);

  int totalSiswa = 0;
  int totalGuru = 0;
  int totalOrangTua = 0;
  int totalPelanggaran = 0;

  bool isLoadingStats = true;
  String? statsError;

  List<Map<String, Object?>> pelanggaranTerbaru = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    if (mounted) {
      setState(() {
        isLoadingStats = true;
        statsError = null;
      });
    }

    try {
      final db = await LocalDatabase.instance.database;

      final siswaResult = await db.rawQuery(
        'SELECT COUNT(*) AS total FROM students',
      );

      final guruResult = await db.rawQuery(
        "SELECT COUNT(*) AS total FROM users "
        "WHERE role = 'guru' AND is_active = 1",
      );

      final orangTuaResult = await db.rawQuery(
        "SELECT COUNT(*) AS total FROM users "
        "WHERE role = 'orang_tua' AND is_active = 1",
      );

      final pelanggaranResult = await db.rawQuery(
        'SELECT COUNT(*) AS total FROM violations',
      );

      // Mengambil maksimal 3 pelanggaran terbaru.
      // Nama siswa diambil dari tabel students.
      final terbaruResult = await db.rawQuery('''
        SELECT
          v.id,
          v.violation_name,
          v.points,
          v.sp_status,
          v.status,
          v.occurred_at,
          s.name AS student_name
        FROM violations v
        INNER JOIN students s ON s.id = v.student_id
        ORDER BY v.occurred_at DESC, v.id DESC
        LIMIT 3
      ''');

      if (!mounted) return;

      setState(() {
        totalSiswa = (siswaResult.first['total'] as int?) ?? 0;
        totalGuru = (guruResult.first['total'] as int?) ?? 0;
        totalOrangTua = (orangTuaResult.first['total'] as int?) ?? 0;
        totalPelanggaran = (pelanggaranResult.first['total'] as int?) ?? 0;

        pelanggaranTerbaru = terbaruResult;
        isLoadingStats = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingStats = false;
        statsError = 'Data dashboard gagal dimuat.';
      });

      debugPrint('Gagal memuat dashboard: $e');
    }
  }

  String _formatTanggal(dynamic value) {
    if (value == null) return '-';

    final parsed = DateTime.tryParse(value.toString());
    if (parsed == null) return value.toString();

    const bulan = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${parsed.day} ${bulan[parsed.month - 1]} ${parsed.year}';
  }

  Color _warnaStatus(String status) {
    final value = status.toLowerCase();

    if (value.contains('sp 3') || value.contains('sp-3')) {
      return const Color(0xFFE83E8C);
    }
    if (value.contains('sp 2') || value.contains('sp-2')) {
      return const Color(0xFFF59E0B);
    }
    if (value.contains('sp 1') || value.contains('sp-1')) {
      return const Color(0xFF246BCE);
    }
    return const Color(0xFF42A85F);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER ADMIN
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 20,
                    left: 20,
                    right: 20,
                    bottom: 40,
                  ),
                  decoration: const BoxDecoration(
                    color: primaryBlue,
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
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: primaryBlue,
                        ),
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
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          tooltip: 'Notifikasi',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotifikasiScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // KARTU STATISTIK
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        const spacing = 16.0;
                        final cardWidth = (constraints.maxWidth - spacing) / 2;
                        final cardHeight = cardWidth * 0.82;

                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: [
                            SizedBox(
                              width: cardWidth,
                              height: cardHeight,
                              child: _buildStatCard(
                                title: 'Total Siswa',
                                count: isLoadingStats ? '...' : '$totalSiswa',
                                icon: Icons.person_outline,
                                iconColor: primaryBlue,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const KelolaDataSiswaScreen(),
                                    ),
                                  ).then((_) => _loadDashboardData());
                                },
                              ),
                            ),
                            SizedBox(
                              width: cardWidth,
                              height: cardHeight,
                              child: _buildStatCard(
                                title: 'Total Guru',
                                count: isLoadingStats ? '...' : '$totalGuru',
                                icon: Icons.school_outlined,
                                iconColor: primaryBlue,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const KelolaPenggunaScreen(),
                                    ),
                                  ).then((_) => _loadDashboardData());
                                },
                              ),
                            ),
                            SizedBox(
                              width: cardWidth,
                              height: cardHeight,
                              child: _buildStatCard(
                                title: 'Total Orang Tua',
                                count:
                                    isLoadingStats ? '...' : '$totalOrangTua',
                                icon: Icons.family_restroom_outlined,
                                iconColor: const Color(0xFFF59E0B),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const KelolaPenggunaScreen(),
                                    ),
                                  ).then((_) => _loadDashboardData());
                                },
                              ),
                            ),
                            SizedBox(
                              width: cardWidth,
                              height: cardHeight,
                              child: _buildStatCard(
                                title: 'Total Pelanggaran',
                                count: isLoadingStats
                                    ? '...'
                                    : '$totalPelanggaran',
                                icon: Icons.warning_amber_rounded,
                                iconColor: const Color(0xFFE83E8C),
                                onTap: () => widget.onNavigate(1),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // JUDUL PELANGGARAN TERBARU
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Pelanggaran Terbaru',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: deepBlue,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => widget.onNavigate(1),
                        child: const Text(
                          'Lihat Semua >',
                          style: TextStyle(
                            color: primaryBlue,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // STATUS MEMUAT / ERROR / DAFTAR PELANGGARAN
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Builder(
                    builder: (context) {
                      if (isLoadingStats) {
                        return const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (statsError != null) {
                        return Center(
                          child: Column(
                            children: [
                              Text(statsError!),
                              TextButton(
                                onPressed: _loadDashboardData,
                                child: const Text('Coba lagi'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (pelanggaranTerbaru.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.assignment_outlined,
                                size: 36,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Belum ada data pelanggaran.',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: pelanggaranTerbaru.map((item) {
                          final nama =
                              item['student_name']?.toString() ?? 'Siswa';
                          final jenis = item['violation_name']?.toString() ??
                              'Pelanggaran';
                          final poin = item['points'] ?? 0;
                          final tanggal = _formatTanggal(item['occurred_at']);
                          final status =
                              item['sp_status']?.toString() ?? 'Normal';
                          final warna = _warnaStatus(status);

                          return _buildViolationItem(
                            nama.isNotEmpty ? nama[0].toUpperCase() : '?',
                            nama,
                            '$jenis\n$tanggal • $poin poin',
                            status,
                            warna.withValues(alpha: 0.15),
                            warna,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // KARTU STATISTIK
  Widget _buildStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.25,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    icon,
                    color: iconColor,
                    size: 23,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: deepBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ITEM PELANGGARAN TERBARU
  Widget _buildViolationItem(
    String initial,
    String name,
    String desc,
    String status,
    Color statusBg,
    Color statusText,
  ) {
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFF246BCE).withValues(alpha: 0.1),
            child: Text(
              initial,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF246BCE),
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF163B75),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusText,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
