import 'package:flutter/material.dart';

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  String _selectedFilter = 'Semua';

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
          'Notifikasi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Tab
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                _buildFilterBtn('Semua'),
                const SizedBox(width: 12),
                _buildFilterBtn('Belum Dibaca'),
              ],
            ),
          ),

          // List Notifikasi
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildNotifItem(
                  icon: Icons.family_restroom,
                  iconColor: Colors.orange,
                  title: 'Parent Alert',
                  desc:
                      'Orang tua Rizky Ardiansyah telah membaca catatan pelanggaran.',
                  time: 'Hari ini, 09:15',
                  isUnread: true,
                ),
                _buildNotifItem(
                  icon: Icons.assignment_late_outlined,
                  iconColor: Colors.redAccent,
                  title: 'Pelanggaran Baru',
                  desc: 'Rizky Ardiansyah tercatat terlambat masuk sekolah.',
                  time: '12 Sep 2026 • 07:10',
                  isUnread: true,
                ),
                _buildNotifItem(
                  icon: Icons.assignment_late_outlined,
                  iconColor: Colors.redAccent,
                  title: 'Pelanggaran Baru',
                  desc: 'Citra Lestari tercatat tidak memakai atribut lengkap.',
                  time: '10 Sep 2026 • 07:15',
                  isUnread: false,
                ),
                _buildNotifItem(
                  icon: Icons.info_outline_rounded,
                  iconColor: const Color(0xFF2C7DEB),
                  title: 'Informasi',
                  desc:
                      'Rapat guru wali kelas besok pukul 10:00 di ruang guru.',
                  time: '08 Sep 2026 • 14:30',
                  isUnread: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBtn(String label) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C7DEB) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color:
                  isSelected ? const Color(0xFF2C7DEB) : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildNotifItem(
      {required IconData icon,
      required Color iconColor,
      required String title,
      required String desc,
      required String time,
      required bool isUnread}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xFFF0F6FF) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isUnread
                ? const Color(0xFF2C7DEB).withValues(alpha: 0.3)
                : Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF163B75))),
                    if (isUnread)
                      Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: Color(0xFF2C7DEB),
                              shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(desc,
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                        height: 1.4)),
                const SizedBox(height: 8),
                Text(time,
                    style:
                        TextStyle(color: Colors.grey.shade500, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
