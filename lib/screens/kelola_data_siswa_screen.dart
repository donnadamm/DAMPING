import 'package:flutter/material.dart';
import '../services/local_database.dart';

class KelolaDataSiswaScreen extends StatefulWidget {
  const KelolaDataSiswaScreen({super.key});

  @override
  State<KelolaDataSiswaScreen> createState() => _KelolaDataSiswaScreenState();
}

class _KelolaDataSiswaScreenState extends State<KelolaDataSiswaScreen> {
  final LocalDatabase _database = LocalDatabase.instance;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _listSiswa = [];
  List<Map<String, dynamic>> _listKelas = [];

  bool _isLoading = true;
  String _kataKunci = '';

  static const Color _primary = Color(0xFF2C7DEB);
  static const Color _navy = Color(0xFF0C356A);
  static const Color _background = Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _muatData() async {
    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      final db = await _database.database;

      final kelas = await db.query(
        'classes',
        orderBy: 'name ASC',
      );

      final siswa = await db.rawQuery('''
        SELECT
          s.id,
          s.nis,
          s.name AS nama,
          s.class_id,
          c.name AS kelas,
          COALESCE((
            SELECT SUM(v.points)
            FROM violations v
            WHERE v.student_id = s.id
              AND v.status IN ('Disetujui', 'Terverifikasi')
          ), 0) AS total_poin
        FROM students s
        LEFT JOIN classes c ON c.id = s.class_id
        ORDER BY s.name ASC
      ''');

      if (!mounted) return;

      setState(() {
        _listKelas = kelas;
        _listSiswa = siswa;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      _tampilkanPesan('Gagal memuat data siswa: $e');
    }
  }

  List<Map<String, dynamic>> get _siswaTerfilter {
    final kata = _kataKunci.toLowerCase().trim();

    return _listSiswa.where((siswa) {
      final nama = (siswa['nama'] ?? '').toString().toLowerCase();
      final nis = (siswa['nis'] ?? '').toString().toLowerCase();

      return nama.contains(kata) || nis.contains(kata);
    }).toList();
  }

  String _statusSiswa(Map<String, dynamic> siswa) {
    final poin = (siswa['total_poin'] as num?)?.toInt() ?? 0;

    // Batas ini adalah konfigurasi awal proyek.
    // Nanti akan diambil dari aturan SP yang dikelola Admin.
    if (poin >= 76) return 'SP 3';
    if (poin >= 51) return 'SP 2';
    if (poin >= 25) return 'SP 1';
    if (poin >= 10) return 'Peringatan';
    return 'Normal';
  }

  Color _warnaStatus(String status) {
    switch (status) {
      case 'SP 3':
        return const Color(0xFF7C3AED);
      case 'SP 2':
        return const Color(0xFFF59E0B);
      case 'SP 1':
        return const Color(0xFFE85D75);
      case 'Peringatan':
        return const Color(0xFFEA8A15);
      default:
        return const Color(0xFF16A34A);
    }
  }

  Future<void> _bukaFormSiswa({
    Map<String, dynamic>? siswa,
  }) async {
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController(
      text: siswa?['nama']?.toString() ?? '',
    );
    final nisController = TextEditingController(
      text: siswa?['nis']?.toString() ?? '',
    );

    int? kelasTerpilih = (siswa?['class_id'] as num?)?.toInt();

    // Pastikan kelas lama masih tersedia dalam daftar pilihan.
    if (kelasTerpilih != null &&
        !_listKelas.any((k) => k['id'] == kelasTerpilih)) {
      kelasTerpilih = null;
    }

    final isEdit = siswa != null;

    final hasil = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                isEdit ? 'Edit Data Siswa' : 'Tambah Siswa',
                style: const TextStyle(
                  color: _navy,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: namaController,
                        textCapitalization: TextCapitalization.words,
                        decoration: _dekorasiInput(
                          'Nama lengkap siswa',
                          Icons.person_outline,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama siswa wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: nisController,
                        decoration: _dekorasiInput(
                          'NIS',
                          Icons.badge_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'NIS wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<int>(
                        initialValue: kelasTerpilih,
                        isExpanded: true,
                        decoration: _dekorasiInput(
                          'Kelas',
                          Icons.class_outlined,
                        ),
                        hint: const Text('Pilih kelas'),
                        items: _listKelas.map((kelas) {
                          return DropdownMenuItem<int>(
                            value: (kelas['id'] as num).toInt(),
                            child: Text(
                              kelas['name'].toString(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            kelasTerpilih = value;
                          });
                        },
                      ),
                      if (_listKelas.isEmpty) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Belum ada data kelas. Kamu dapat menyimpan '
                          'siswa tanpa kelas terlebih dahulu, lalu '
                          'menghubungkannya setelah kelas dibuat.',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;

                    try {
                      final db = await _database.database;
                      final nis = nisController.text.trim();

                      final duplikat = await db.query(
                        'students',
                        columns: ['id'],
                        where: 'nis = ? AND id != ?',
                        whereArgs: [nis, siswa?['id'] ?? -1],
                        limit: 1,
                      );

                      if (duplikat.isNotEmpty) {
                        if (!dialogContext.mounted) return;

                        ScaffoldMessenger.of(dialogContext)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text(
                                'NIS sudah digunakan siswa lain.',
                              ),
                            ),
                          );
                        return;
                      }

                      final data = <String, Object?>{
                        'name': namaController.text.trim(),
                        'nis': nis,
                        'class_id': kelasTerpilih,
                      };

                      if (isEdit) {
                        await _database.updateById(
                          'students',
                          (siswa['id'] as num).toInt(),
                          data,
                        );
                      } else {
                        data['created_at'] = DateTime.now().toIso8601String();

                        await _database.insert('students', data);
                      }

                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext, true);
                      }
                    } catch (e) {
                      if (!dialogContext.mounted) return;

                      ScaffoldMessenger.of(dialogContext)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(
                              'Gagal menyimpan data siswa: $e',
                            ),
                          ),
                        );
                    }
                  },
                  child: Text(isEdit ? 'Simpan Perubahan' : 'Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    namaController.dispose();
    nisController.dispose();

    if (hasil == true && mounted) {
      await _muatData();
      _tampilkanPesan(
        isEdit
            ? 'Data siswa berhasil diperbarui.'
            : 'Siswa berhasil ditambahkan.',
      );
    }
  }

  Future<void> _hapusSiswa(Map<String, dynamic> siswa) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Data Siswa'),
        content: Text(
          'Yakin ingin menghapus data ${siswa['nama']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi != true || !mounted) return;

    try {
      final db = await _database.database;

      // Cegah penghapusan jika siswa sudah memiliki catatan pelanggaran.
      final pelanggaran = await db.query(
        'violations',
        columns: ['id'],
        where: 'student_id = ?',
        whereArgs: [siswa['id']],
        limit: 1,
      );

      if (pelanggaran.isNotEmpty) {
        _tampilkanPesan(
          'Siswa memiliki riwayat pelanggaran. '
          'Data tidak dihapus agar riwayat tetap terjaga.',
        );
        return;
      }

      await _database.deleteById(
        'students',
        (siswa['id'] as num).toInt(),
      );

      await _muatData();
      _tampilkanPesan('Data siswa berhasil dihapus.');
    } catch (e) {
      _tampilkanPesan('Gagal menghapus siswa: $e');
    }
  }

  InputDecoration _dekorasiInput(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: _primary),
      filled: true,
      fillColor: _background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primary),
      ),
    );
  }

  void _tampilkanPesan(String pesan) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(pesan)));
  }

  @override
  Widget build(BuildContext context) {
    final siswaTampil = _siswaTerfilter;

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text(
          'Kelola Data Siswa',
          style: TextStyle(
            color: _navy,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: _navy,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() => _kataKunci = value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari nama atau NIS siswa...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    suffixIcon: _kataKunci.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _kataKunci = '');
                            },
                            icon: const Icon(Icons.close),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${siswaTampil.length} siswa ditemukan',
                        style: const TextStyle(
                          color: _navy,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _bukaFormSiswa(),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text(
                        'Tambah Siswa',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: _primary),
                  )
                : siswaTampil.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _muatData,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            4,
                            16,
                            20,
                          ),
                          itemCount: siswaTampil.length,
                          itemBuilder: (context, index) {
                            final siswa = siswaTampil[index];
                            final nama = siswa['nama'].toString();
                            final status = _statusSiswa(siswa);
                            final warna = _warnaStatus(status);
                            final poin =
                                (siswa['total_poin'] as num?)?.toInt() ?? 0;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.shade100,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: 0.025,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),
                                leading: CircleAvatar(
                                  radius: 23,
                                  backgroundColor: const Color(0xFFE8F1FF),
                                  child: Text(
                                    nama.isNotEmpty
                                        ? nama[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: _primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  nama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _navy,
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    '${siswa['kelas'] ?? 'Belum ada kelas'}'
                                    '\nNIS: ${siswa['nis']} • $poin poin',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                isThreeLine: true,
                                trailing: PopupMenuButton<String>(
                                  tooltip: 'Aksi siswa',
                                  onSelected: (aksi) {
                                    if (aksi == 'edit') {
                                      _bukaFormSiswa(siswa: siswa);
                                    } else if (aksi == 'hapus') {
                                      _hapusSiswa(siswa);
                                    }
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit_outlined),
                                          SizedBox(width: 10),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'hapus',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete_outline,
                                            color: Colors.redAccent,
                                          ),
                                          SizedBox(width: 10),
                                          Text('Hapus'),
                                        ],
                                      ),
                                    ),
                                  ],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 9,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: warna.withValues(
                                            alpha: 0.12,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          status,
                                          style: TextStyle(
                                            color: warna,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Icon(
                                        Icons.more_horiz,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final pencarianAktif = _kataKunci.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              pencarianAktif
                  ? Icons.search_off_rounded
                  : Icons.people_outline_rounded,
              size: 58,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              pencarianAktif ? 'Siswa tidak ditemukan' : 'Belum ada data siswa',
              style: const TextStyle(
                color: _navy,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              pencarianAktif
                  ? 'Coba gunakan nama atau NIS yang berbeda.'
                  : 'Tekan tombol Tambah Siswa untuk memasukkan data.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
            if (!pencarianAktif) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _bukaFormSiswa(),
                icon: const Icon(Icons.add),
                label: const Text('Tambah Siswa'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
