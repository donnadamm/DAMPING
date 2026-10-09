import 'package:flutter/material.dart';

class NotifikasiParentScreen extends StatefulWidget {
  const NotifikasiParentScreen({super.key});

  @override
  State<NotifikasiParentScreen> createState() => _NotifikasiParentScreenState();
}

class _NotifikasiParentScreenState extends State<NotifikasiParentScreen> {
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterBtn('Semua'),
                  const SizedBox(width: 12),
                  _buildFilterBtn('Pelanggaran'),
                  const SizedBox(width: 12),
                  _buildFilterBtn('Informasi'),
                ],
              ),
            ),
          ),

          // List Notifikasi
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildNotifItem(
                  icon: Icons.assignment_late_outlined,
                  iconColor: Colors.redAccent,
                  title: 'Pelanggaran Baru',
                  desc: 'Andi Pratama - Terlambat masuk sekolah',
                  time: '12 Sep 2026 • 08:15',
                  poin: '+5 poin',
                ),
                _buildNotifItem(
                  icon: Icons.warning_amber_rounded,
                  iconColor: Colors.orange,
                  title: 'Status Berubah',
                  desc: 'Andi Pratama kini berstatus SP 1',
                  time: '10 Sep 2026 • 10:20',
                ),
                _buildNotifItem(
                  icon: Icons.info_outline_rounded,
                  iconColor: const Color(0xFF2C7DEB),
                  title: 'Informasi',
                  desc:
                      'Rekap pelanggaran bulan September 2026 telah tersedia.',
                  time: '01 Sep 2026 • 14:15',
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
      String? poin}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
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
                    if (poin != null)
                      Text(poin,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.redAccent)),
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