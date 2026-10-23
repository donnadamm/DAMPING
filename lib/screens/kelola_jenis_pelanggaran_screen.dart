import 'package:flutter/material.dart';
import '../services/local_database.dart';

class KelolaJenisPelanggaranScreen extends StatefulWidget {
  const KelolaJenisPelanggaranScreen({super.key});

  @override
  State<KelolaJenisPelanggaranScreen> createState() =>
      _KelolaJenisPelanggaranScreenState();
}

class _KelolaJenisPelanggaranScreenState
    extends State<KelolaJenisPelanggaranScreen> {
  static const Color primaryBlue = Color(0xFF246BCE);
  static const Color deepBlue = Color(0xFF163B75);
  static const Color backgroundColor = Color(0xFFF5F8FC);

  List<Map<String, Object?>> _jenisPelanggaran = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _filter = 'Semua';

  @override
  void initState() {
    super.initState();
    _loadJenisPelanggaran();
  }

  Future<void> _loadJenisPelanggaran() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final db = await LocalDatabase.instance.database;
      final data = await db.query(
        'violation_types',
        orderBy: 'category ASC, name ASC',
      );

      if (!mounted) return;

      setState(() {
        _jenisPelanggaran = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Data jenis pelanggaran gagal dimuat.';
      });

      debugPrint('Gagal memuat jenis pelanggaran: $e');
    }
  }

  List<Map<String, Object?>> get _dataTerfilter {
    if (_filter == 'Semua') return _jenisPelanggaran;

    final statusAktif = _filter == 'Aktif' ? 1 : 0;

    return _jenisPelanggaran.where((item) {
      return (item['is_active'] as num?)?.toInt() == statusAktif;
    }).toList();
  }

  Future<void> _tampilkanForm({
    Map<String, Object?>? data,
  }) async {
    final namaController = TextEditingController(
      text: data?['name']?.toString() ?? '',
    );
    final poinController = TextEditingController(
      text: data?['points']?.toString() ?? '',
    );
    final deskripsiController = TextEditingController(
      text: data?['description']?.toString() ?? '',
    );

    String kategori = data?['category']?.toString() ?? 'Ringan';
    String? directSp = data?['direct_sp']?.toString();

    const kategoriPilihan = ['Ringan', 'Sedang', 'Berat'];
    const spPilihan = [
      'Tidak ada',
      'SP 1',
      'SP 2',
      'SP 3',
    ];

    if (!kategoriPilihan.contains(kategori)) {
      kategori = 'Ringan';
    }

    if (directSp != null &&
        directSp.isNotEmpty &&
        !spPilihan.contains(directSp)) {
      directSp = null;
    }

    final formKey = GlobalKey<FormState>();

    final hasil = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                data == null
                    ? 'Tambah Jenis Pelanggaran'
                    : 'Edit Jenis Pelanggaran',
                style: const TextStyle(
                  color: deepBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Nama pelanggaran'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: namaController,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'Contoh: Terlambat masuk sekolah',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nama pelanggaran wajib diisi.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text('Kategori'),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: kategori,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: kategoriPilihan.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() => kategori = value);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text('Bobot poin'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: poinController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Contoh: 5',
                            border: OutlineInputBorder(),
                            suffixText: 'poin',
                          ),
                          validator: (value) {
                            final poin = int.tryParse(value?.trim() ?? '');

                            if (poin == null || poin < 1) {
                              return 'Masukkan poin berupa angka minimal 1.';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text('SP langsung (opsional)'),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: directSp,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          hint: const Text('Tidak ada SP langsung'),
                          items: spPilihan
                              .map((item) {
                                return DropdownMenuItem<String>(
                                  value: item == 'Tidak ada' ? null : item,
                                  child: Text(item),
                                );
                              })
                              .where((item) => item.value != null)
                              .toList(),
                          onChanged: (value) {
                            setDialogState(() => directSp = value);
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text('Keterangan (opsional)'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: deskripsiController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Tambahkan keterangan pelanggaran',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(dialogContext, true);
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    if (hasil == true && mounted) {
      try {
        final values = <String, Object?>{
          'name': namaController.text.trim(),
          'category': kategori,
          'points': int.parse(poinController.text.trim()),
          'direct_sp': directSp,
          'description': deskripsiController.text.trim().isEmpty
              ? null
              : deskripsiController.text.trim(),
        };

        if (data == null) {
          values['is_active'] = 1;
          await LocalDatabase.instance.insert(
            'violation_types',
            values,
          );
        } else {
          await LocalDatabase.instance.updateById(
            'violation_types',
            (data['id'] as num).toInt(),
            values,
          );
        }

        await _loadJenisPelanggaran();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data == null
                  ? 'Jenis pelanggaran berhasil ditambahkan.'
                  : 'Jenis pelanggaran berhasil diperbarui.',
            ),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    namaController.dispose();
    poinController.dispose();
    deskripsiController.dispose();
  }

  Future<void> _ubahStatus(Map<String, Object?> data) async {
    final id = (data['id'] as num).toInt();
    final aktif = (data['is_active'] as num?)?.toInt() == 1;

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(aktif ? 'Nonaktifkan jenis ini?' : 'Aktifkan jenis ini?'),
        content: Text(
          aktif
              ? 'Jenis pelanggaran ini tidak akan tersedia untuk pencatatan baru.'
              : 'Jenis pelanggaran ini akan tersedia kembali untuk pencatatan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, lanjutkan'),
          ),
        ],
      ),
    );

    if (konfirmasi != true) return;

    try {
      await LocalDatabase.instance.updateById(
        'violation_types',
        id,
        {'is_active': aktif ? 0 : 1},
      );

      await _loadJenisPelanggaran();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            aktif
                ? 'Jenis pelanggaran dinonaktifkan.'
                : 'Jenis pelanggaran diaktifkan.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengubah status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _dataTerfilter;
    final aktif = _jenisPelanggaran
        .where((item) => (item['is_active'] as num?)?.toInt() == 1)
        .length;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Jenis Pelanggaran',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadJenisPelanggaran,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 120),
                      Center(child: Text(_errorMessage!)),
                      Center(
                        child: TextButton(
                          onPressed: _loadJenisPelanggaran,
                          child: const Text('Coba lagi'),
                        ),
                      ),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.all(20),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: primaryBlue,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.rule_folder_outlined,
                              size: 42,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Aturan Pelanggaran',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${_jenisPelanggaran.length} jenis • $aktif aktif',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _tampilkanForm(),
                          icon: const Icon(Icons.add),
                          label: const Text('Tambah Jenis Pelanggaran'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Daftar Jenis Pelanggaran',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: deepBlue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _filter,
                        decoration: const InputDecoration(
                          labelText: 'Filter status',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Semua',
                            child: Text('Semua jenis'),
                          ),
                          DropdownMenuItem(
                            value: 'Aktif',
                            child: Text('Aktif'),
                          ),
                          DropdownMenuItem(
                            value: 'Nonaktif',
                            child: Text('Nonaktif'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _filter = value);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      if (data.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 42,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text('Belum ada jenis pelanggaran.'),
                              SizedBox(height: 4),
                              Text(
                                'Tekan tombol tambah untuk membuat data pertama.',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else
                        ...data.map((item) {
                          final isActive =
                              (item['is_active'] as num?)?.toInt() == 1;
                          final poin = item['points'] ?? 0;
                          final nama = item['name']?.toString() ?? '-';
                          final kategori = item['category']?.toString() ?? '-';
                          final directSp = item['direct_sp']?.toString();

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isActive
                                    ? const Color(0xFFE4ECF6)
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color:
                                            primaryBlue.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.warning_amber_rounded,
                                        color: primaryBlue,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            nama,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: deepBlue,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Kategori $kategori • $poin poin',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                          if (directSp != null &&
                                              directSp.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 5,
                                              ),
                                              child: Text(
                                                'SP langsung: $directSp',
                                                style: const TextStyle(
                                                  color: Color(0xFFE83E8C),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      isActive
                                          ? Icons.check_circle
                                          : Icons.pause_circle_filled,
                                      color:
                                          isActive ? Colors.green : Colors.grey,
                                    ),
                                  ],
                                ),
                                if ((item['description']?.toString() ?? '')
                                    .isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    item['description'].toString(),
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                                const Divider(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () =>
                                            _tampilkanForm(data: item),
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          size: 18,
                                        ),
                                        label: const Text('Edit'),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () => _ubahStatus(item),
                                        icon: Icon(
                                          isActive
                                              ? Icons.pause_circle_outline
                                              : Icons.check_circle_outline,
                                          size: 18,
                                        ),
                                        label: Text(
                                          isActive ? 'Nonaktifkan' : 'Aktifkan',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
      ),
    );
  }
}
