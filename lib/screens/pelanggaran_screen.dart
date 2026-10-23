import 'package:flutter/material.dart';
import '../services/local_database.dart';
import 'catat_pelanggaran_screen.dart';

class PelanggaranScreen extends StatefulWidget {
  const PelanggaranScreen({super.key});

  @override
  State<PelanggaranScreen> createState() => _PelanggaranScreenState();
}

class _PelanggaranScreenState extends State<PelanggaranScreen> {
  String selectedFilter = 'Semua';
  String searchQuery = '';
  bool isLoading = true;
  List<Map<String, dynamic>> pelanggaran = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPelanggaran();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPelanggaran() async {
    try {
      final db = await LocalDatabase.instance.database;
      final data = await db.rawQuery('''
        SELECT
          v.id,
          v.student_id,
          v.violation_name,
          v.points,
          v.sp_status,
          v.status,
          v.description,
          v.occurred_at,
          s.name AS nama_siswa,
          s.nis,
          c.name AS nama_kelas
        FROM violations v
        INNER JOIN students s ON s.id = v.student_id
        LEFT JOIN classes c ON c.id = s.class_id
        ORDER BY v.occurred_at DESC, v.id DESC
      ''');

      if (!mounted) return;

      setState(() {
        pelanggaran = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat pelanggaran: $e')),
      );
    }
  }

  List<Map<String, dynamic>> get filteredPelanggaran {
    return pelanggaran.where((item) {
      final status = (item['sp_status'] ?? 'Normal').toString();
      final nama = (item['nama_siswa'] ?? '').toString().toLowerCase();
      final jenis = (item['violation_name'] ?? '').toString().toLowerCase();
      final query = searchQuery.toLowerCase();

      final cocokFilter = selectedFilter == 'Semua' || status == selectedFilter;
      final cocokPencarian = nama.contains(query) || jenis.contains(query);

      return cocokFilter && cocokPencarian;
    }).toList();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'SP 1':
        return const Color(0xFFFFE1E5);
      case 'SP 2':
        return const Color(0xFFFFE8C7);
      case 'SP 3':
        return const Color(0xFFFFD8D8);
      default:
        return const Color(0xFFDDF5E3);
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case 'SP 1':
        return const Color(0xFFE5394F);
      case 'SP 2':
        return const Color(0xFFE88A00);
      case 'SP 3':
        return const Color(0xFFC62828);
      default:
        return const Color(0xFF42A85F);
    }
  }

  String _formatTanggal(dynamic value) {
    if (value == null) return '-';

    final date = DateTime.tryParse(value.toString());
    if (date == null) return value.toString();

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

    return '${date.day.toString().padLeft(2, '0')} '
        '${bulan[date.month - 1]} ${date.year}';
  }

  Future<void> _bukaForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CatatPelanggaranScreen(),
      ),
    );

    if (result == true) {
      await _loadPelanggaran();
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = filteredPelanggaran;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF2C7DEB),
        foregroundColor: const Color(0xFF0C356A),
        title: const Text(
          'Pelanggaran',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // Tidak ada actions: tombol tambah hanya satu di bawah.
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
              decoration: InputDecoration(
                hintText: 'Cari nama siswa atau pelanggaran...',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF2C7DEB),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildFilterButton('Semua'),
                _buildFilterButton('SP 1'),
                _buildFilterButton('SP 2'),
                _buildFilterButton('Normal'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  '${data.length} Pelanggaran',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163B75),
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Muat ulang',
                  onPressed: _loadPelanggaran,
                  icon: const Icon(
                    Icons.refresh,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : data.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'Belum ada data pelanggaran.\n'
                            'Tekan tombol + untuk mencatat pelanggaran.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF64748B)),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return _buildPelanggaranCard(data[index]);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2C7DEB),
        foregroundColor: Colors.white,
        onPressed: _bukaForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    final isSelected = selectedFilter == filter;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => selectedFilter = filter),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2C7DEB) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF2C7DEB)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Text(
            filter,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPelanggaranCard(Map<String, dynamic> item) {
    final nama = (item['nama_siswa'] ?? 'Siswa').toString();
    final kelas = (item['nama_kelas'] ?? '-').toString();
    final jenis = (item['violation_name'] ?? '-').toString();
    final status = (item['sp_status'] ?? 'Normal').toString();
    final poin = item['points'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _lihatDetail(item),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFE5F0FF),
                child: Text(
                  nama.isNotEmpty ? nama[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Color(0xFF2C7DEB),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF163B75),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      kelas,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      jenis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${_formatTanggal(item['occurred_at'])} • +$poin poin',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor(status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: getStatusTextColor(status),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _lihatDetail(Map<String, dynamic> item) async {
    final db = await LocalDatabase.instance.database;
    final id = item['student_id'];

    final riwayat = await db.query(
      'violations',
      where: 'student_id = ?',
      whereArgs: [id],
      orderBy: 'occurred_at DESC',
    );

    if (!mounted) return;

    final totalPoin = riwayat.fold<int>(
      0,
      (sum, row) => sum + ((row['points'] as num?)?.toInt() ?? 0),
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text((item['nama_siswa'] ?? 'Detail Siswa').toString()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NIS: ${item['nis'] ?? '-'}'),
            Text('Kelas: ${item['nama_kelas'] ?? '-'}'),
            Text('Jumlah catatan pelanggaran: ${riwayat.length}'),
            Text('Total poin tercatat: $totalPoin'),
            const SizedBox(height: 12),
            const Text(
              'Riwayat terbaru:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            ...riwayat.take(5).map(
                  (row) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      '• ${row['violation_name']} (+${row['points']} poin)',
                    ),
                  ),
                ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
