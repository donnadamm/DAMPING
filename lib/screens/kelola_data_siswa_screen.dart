import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:typed_data';

import '../services/local_database.dart';

class KelolaDataSiswaScreen extends StatefulWidget {
  const KelolaDataSiswaScreen({super.key});

  @override
  State<KelolaDataSiswaScreen> createState() => _KelolaDataSiswaScreenState();
}

class _KelolaDataSiswaScreenState extends State<KelolaDataSiswaScreen> {
  final LocalDatabase _database = LocalDatabase.instance;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, Object?>> _students = [];
  List<Map<String, Object?>> _classes = [];

  bool _isLoading = true;
  String _searchQuery = '';

  static const Color primary = Color(0xFF246BCE);
  static const Color navy = Color(0xFF163B75);
  static const Color cyan = Color(0xFF27A9D6);
  static const Color background = Color(0xFFF5F8FC);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadData();
  }

  void _onSearchChanged() {
    if (!mounted) return;
    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // ==========================================================
  // MEMUAT DATA
  // ==========================================================

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final students = await _database.getAll(
        'students',
        orderBy: 'name ASC',
      );

      if (!mounted) return;

      final classes = await _database.getAll(
        'classes',
        orderBy: 'name ASC',
      );

      if (!mounted) return;

      setState(() {
        _students = students;
        _classes = classes;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showMessage(
        'Gagal memuat data siswa: $e',
        isError: true,
      );
    }
  }

  List<Map<String, Object?>> get _filteredStudents {
    return _students.where((student) {
      final name = (student['name'] ?? '').toString().toLowerCase();
      final nis = (student['nis'] ?? '').toString().toLowerCase();
      return name.contains(_searchQuery) || nis.contains(_searchQuery);
    }).toList();
  }

  String _className(Object? classId) {
    if (classId == null) return 'Belum ada kelas';

    for (final item in _classes) {
      if (item['id'].toString() == classId.toString()) {
        return item['name'].toString();
      }
    }
    return 'Kelas tidak ditemukan';
  }

  // ==========================================================
  // FORM TAMBAH DAN EDIT
  // ==========================================================

  Future<void> _showStudentForm({
    Map<String, Object?>? student,
  }) async {
    if (!mounted) return;

    final bool isEditing = student != null;
    final nisController = TextEditingController(
      text: student?['nis']?.toString() ?? '',
    );
    final nameController = TextEditingController(
      text: student?['name']?.toString() ?? '',
    );
    final formKey = GlobalKey<FormState>();
    bool isSaving = false;

    int? parseId(Object? value) {
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '');
    }

    int? selectedClassId;

    try {
      final classData = await _database.getAll(
        'classes',
        orderBy: 'name ASC',
      );
      if (!mounted) return;

      setState(() {
        _classes = List<Map<String, Object?>>.from(classData);
      });

      selectedClassId = parseId(student?['class_id']);
      final validIds =
          _classes.map((item) => parseId(item['id'])).whereType<int>().toSet();
      if (!validIds.contains(selectedClassId)) selectedClassId = null;

      final saved = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return Dialog(
                backgroundColor: Colors.white,
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F1FF),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  isEditing
                                      ? Icons.edit_rounded
                                      : Icons.person_add_alt_1_rounded,
                                  color: primary,
                                  size: 27,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isEditing
                                          ? 'Edit Data Siswa'
                                          : 'Tambah Siswa',
                                      style: const TextStyle(
                                        color: navy,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Isi informasi siswa pada kolom berikut.',
                                      style: TextStyle(
                                        color: Colors.blueGrey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'INFORMASI SISWA',
                            style: TextStyle(
                              color: navy,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: nisController,
                            enabled: !isSaving,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                              'Nomor Induk Siswa (NIS)',
                              Icons.badge_outlined,
                            ).copyWith(
                              hintText: 'Contoh: 2026001',
                              filled: true,
                              fillColor: const Color(0xFFF7F9FC),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'NIS wajib diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: nameController,
                            enabled: !isSaving,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.done,
                            decoration: _inputDecoration(
                              'Nama lengkap siswa',
                              Icons.person_outline_rounded,
                            ).copyWith(
                              hintText: 'Contoh: Andi Pratama',
                              filled: true,
                              fillColor: const Color(0xFFF7F9FC),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Nama siswa wajib diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          DropdownButtonFormField<int?>(
                            key: ValueKey(
                              'student_class_${_classes.length}',
                            ),
                            initialValue: selectedClassId,
                            isExpanded: true,
                            decoration: _inputDecoration(
                              'Pilih kelas',
                              Icons.school_outlined,
                            ).copyWith(
                              filled: true,
                              fillColor: const Color(0xFFF7F9FC),
                            ),
                            items: [
                              const DropdownMenuItem<int?>(
                                value: null,
                                child: Text('Belum ditentukan'),
                              ),
                              ..._classes.map((item) {
                                final id = parseId(item['id']);
                                if (id == null) return null;
                                return DropdownMenuItem<int?>(
                                  value: id,
                                  child: Text(
                                    item['name']?.toString() ?? 'Tanpa nama',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).whereType<DropdownMenuItem<int?>>(),
                            ],
                            onChanged: isSaving
                                ? null
                                : (value) {
                                    setDialogState(() {
                                      selectedClassId = value;
                                    });
                                  },
                          ),
                          if (_classes.isEmpty) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF7ED),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Belum ada data kelas. Kamu tetap dapat menyimpan '
                                'siswa tanpa kelas, atau tambahkan data kelas melalui '
                                'menu Kelola Kelas.',
                                style: TextStyle(
                                  color: Color(0xFFB45309),
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 22),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: isSaving
                                      ? null
                                      : () =>
                                          Navigator.pop(dialogContext, false),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: navy,
                                    minimumSize: const Size.fromHeight(48),
                                    side: const BorderSide(
                                      color: Color(0xFFD7E1EF),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text('Batal'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton.icon(
                                  onPressed: isSaving
                                      ? null
                                      : () async {
                                          if (!formKey.currentState!
                                              .validate()) {
                                            return;
                                          }

                                          setDialogState(() => isSaving = true);
                                          try {
                                            final nis =
                                                nisController.text.trim();
                                            final name =
                                                nameController.text.trim();

                                            final duplicate =
                                                _students.any((item) {
                                              final sameNis = item['nis']
                                                      ?.toString()
                                                      .trim()
                                                      .toLowerCase() ==
                                                  nis.toLowerCase();
                                              final sameStudent = item['id']
                                                      ?.toString() ==
                                                  student?['id']?.toString();
                                              return sameNis && !sameStudent;
                                            });

                                            if (duplicate) {
                                              setDialogState(
                                                  () => isSaving = false);
                                              _showMessage(
                                                'NIS tersebut sudah digunakan.',
                                                isError: true,
                                              );
                                              return;
                                            }

                                            if (selectedClassId != null &&
                                                !_classes.any((item) =>
                                                    parseId(item['id']) ==
                                                    selectedClassId)) {
                                              setDialogState(
                                                  () => isSaving = false);
                                              _showMessage(
                                                'Kelas tidak ditemukan. Pilih kelas kembali.',
                                                isError: true,
                                              );
                                              return;
                                            }

                                            final values = <String, Object?>{
                                              'nis': nis,
                                              'name': name,
                                              'class_id': selectedClassId,
                                            };

                                            if (isEditing) {
                                              final id = parseId(student['id']);
                                              if (id == null) {
                                                throw Exception(
                                                    'ID siswa tidak valid.');
                                              }
                                              await _database.updateById(
                                                'students',
                                                id,
                                                values,
                                              );
                                            } else {
                                              values['created_at'] =
                                                  DateTime.now()
                                                      .toIso8601String();
                                              await _database.insert(
                                                  'students', values);
                                            }

                                            if (!dialogContext.mounted) return;
                                            Navigator.pop(dialogContext, true);
                                          } catch (e) {
                                            if (!dialogContext.mounted) return;
                                            setDialogState(
                                                () => isSaving = false);
                                            _showMessage(
                                              'Data gagal disimpan: $e',
                                              isError: true,
                                            );
                                          }
                                        },
                                  icon: isSaving
                                      ? const SizedBox(
                                          width: 17,
                                          height: 17,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.check_rounded,
                                          size: 20),
                                  label: Text(
                                    isSaving
                                        ? 'Menyimpan...'
                                        : isEditing
                                            ? 'Simpan perubahan'
                                            : 'Simpan siswa',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primary,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size.fromHeight(48),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );

      if (saved == true && mounted) {
        await _loadData();
        if (!mounted) return;
        _showMessage(
          isEditing
              ? 'Data siswa berhasil diperbarui.'
              : 'Siswa berhasil ditambahkan.',
        );
      }
    } catch (e) {
      if (mounted) {
        _showMessage('Gagal membuka formulir siswa: $e', isError: true);
      }
    } finally {
      nisController.dispose();
      nameController.dispose();
    }
  }

  // ==========================================================
  // HAPUS SISWA
  // ==========================================================

  Future<void> _deleteStudent(
    Map<String, Object?> student,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Hapus Data Siswa',
          style: TextStyle(color: navy, fontWeight: FontWeight.bold),
        ),
        content: Text('Apakah kamu yakin ingin menghapus ${student['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final db = await _database.database;
      final violations = await db.query(
        'violations',
        columns: ['id'],
        where: 'student_id = ?',
        whereArgs: [student['id']],
        limit: 1,
      );

      if (violations.isNotEmpty) {
        _showMessage(
          'Siswa memiliki riwayat pelanggaran. '
          'Data tidak dihapus agar riwayat tetap terjaga.',
          isError: true,
        );
        return;
      }

      await _database.deleteById('students', student['id'] as int);
      await _loadData();

      if (!mounted) return;
      _showMessage('Data siswa berhasil dihapus.');
    } catch (e) {
      _showMessage('Gagal menghapus data siswa: $e', isError: true);
    }
  }

  // ==========================================================
  // IMPOR CSV
  // ==========================================================

  Future<void> _importStudentsCsv() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (result.isEmpty) return;

      final selectedFile = result.first;
      final bytes = await selectedFile.readAsBytes();
      String content = utf8.decode(bytes, allowMalformed: true);
      content = content.replaceFirst('\uFEFF', '').trim();

      if (content.isEmpty) {
        _showMessage('File CSV kosong.', isError: true);
        return;
      }

      // Mendukung file CSV yang memakai koma maupun titik koma sebagai pemisah.
      final firstLine = content.split(RegExp(r'\r?\n')).first;
      final delimiter =
          firstLine.split(';').length > firstLine.split(',').length ? ';' : ',';
      final rows = csv.decode(content);

      if (rows.length < 2) {
        _showMessage(
          'CSV belum berisi data siswa. Pastikan ada baris judul dan data.',
          isError: true,
        );
        return;
      }

      String normalizeHeader(dynamic value) => value
          .toString()
          .replaceFirst('\uFEFF', '')
          .trim()
          .toLowerCase()
          .replaceAll('_', ' ');

      final headers = rows.first.map(normalizeHeader).toList();
      final nisIndex = headers.indexWhere(
        (h) => h == 'nis' || h == 'nomor induk siswa',
      );
      final nameIndex = headers.indexWhere(
        (h) =>
            h == 'nama' ||
            h == 'nama siswa' ||
            h == 'name' ||
            h == 'student name',
      );
      final classIndex = headers.indexWhere(
        (h) => h == 'kelas' || h == 'class' || h == 'nama kelas',
      );

      if (nisIndex == -1 || nameIndex == -1) {
        _showMessage(
          'Judul kolom belum sesuai. CSV harus memiliki kolom NIS dan Nama Siswa.',
          isError: true,
        );
        return;
      }

      final currentStudents = await _database.getAll('students');
      final existingNis = currentStudents
          .map((item) => (item['nis'] ?? '').toString().trim().toLowerCase())
          .where((value) => value.isNotEmpty)
          .toSet();
      final seenNis = <String>{...existingNis};

      final prepared = <Map<String, String?>>[];
      final errors = <String>[];
      final newClassesByKey = <String, String>{};

      for (var i = 1; i < rows.length; i++) {
        final row = rows[i];
        if (row.every((cell) => cell.toString().trim().isEmpty)) continue;

        if (row.length <= nisIndex ||
            row.length <= nameIndex ||
            (classIndex != -1 && row.length <= classIndex)) {
          errors.add('Baris ${i + 1}: kolom tidak lengkap.');
          continue;
        }

        final nis = row[nisIndex].toString().trim();
        final name = row[nameIndex].toString().trim();
        final className =
            classIndex == -1 ? '' : row[classIndex].toString().trim();

        if (nis.isEmpty || name.isEmpty) {
          errors.add('Baris ${i + 1}: NIS dan nama wajib diisi.');
          continue;
        }
        if (!seenNis.add(nis.toLowerCase())) {
          errors.add('Baris ${i + 1}: NIS $nis sudah ada atau duplikat.');
          continue;
        }

        prepared.add(<String, String?>{
          'nis': nis,
          'name': name,
          'className': className.isEmpty ? null : className,
          'line': '${i + 1}',
        });

        if (className.isNotEmpty) {
          newClassesByKey.putIfAbsent(className.toLowerCase(), () => className);
        }
      }

      if (prepared.isEmpty) {
        final detail = errors.take(4).join('\n');
        _showMessage(
          'Tidak ada data yang siap diimpor.${detail.isEmpty ? '' : '\n$detail'}',
          isError: true,
        );
        return;
      }

      // Baca data kelas paling baru, bukan hanya cache tampilan.
      final classRows = await _database.getAll('classes', orderBy: 'name ASC');
      final classIds = <String, int>{};
      for (final item in classRows) {
        final id = int.tryParse(item['id'].toString());
        final name = (item['name'] ?? '').toString().trim();
        if (id != null && name.isNotEmpty) {
          classIds[name.toLowerCase()] = id;
        }
      }

      final classesToCreate = <String>[];
      for (final entry in newClassesByKey.entries) {
        if (!classIds.containsKey(entry.key)) {
          classesToCreate.add(entry.value);
        }
      }

      if (!mounted) return;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Row(
            children: [
              Icon(Icons.file_present_rounded, color: primary, size: 27),
              SizedBox(width: 10),
              Expanded(child: Text('Pratinjau Impor CSV')),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.sizeOf(dialogContext).width * 0.78,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedFile.name,
                    style: const TextStyle(
                      color: navy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _importSummaryTile(
                    Icons.check_circle_outline_rounded,
                    '${prepared.length} siswa siap diimpor',
                    const Color(0xFF15803D),
                    const Color(0xFFECFDF3),
                  ),
                  const SizedBox(height: 8),
                  _importSummaryTile(
                    Icons.school_outlined,
                    classesToCreate.isEmpty
                        ? 'Semua kelas sudah terdaftar'
                        : '${classesToCreate.length} kelas baru akan dibuat',
                    const Color(0xFF1D4ED8),
                    const Color(0xFFEFF6FF),
                  ),
                  if (classesToCreate.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Kelas baru: ${classesToCreate.join(', ')}',
                      style: TextStyle(
                        color: Colors.blueGrey.shade700,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                  if (errors.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _importSummaryTile(
                      Icons.info_outline_rounded,
                      '${errors.length} baris akan dilewati karena data kosong atau NIS duplikat',
                      const Color(0xFFB45309),
                      const Color(0xFFFFF7ED),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Text(
                    'Contoh data',
                    style: TextStyle(
                      color: navy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...prepared.take(4).map((record) => Container(
                        margin: const EdgeInsets.only(bottom: 7),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F8FC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE1EDFF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.person_outline_rounded,
                                size: 18,
                                color: primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    record['name'] ?? '-',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: navy,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'NIS ${record['nis']}  •  ${record['className'] ?? 'Kelas belum diisi'}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.blueGrey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  if (prepared.length > 4)
                    Text(
                      'dan ${prepared.length - 4} data lainnya...',
                      style: TextStyle(
                        color: Colors.blueGrey.shade600,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(dialogContext, true),
              icon: const Icon(Icons.file_download_done_rounded, size: 18),
              label: const Text('Impor sekarang'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;

      int imported = 0;
      int skippedDuringSave = 0;
      final saveErrors = <String>[];
      final db = await _database.database;

      await db.transaction((txn) async {
        // Ambil kelas lagi di dalam transaksi agar ID kelas selalu valid.
        final latestClasses = await txn.query('classes');
        final idsByName = <String, int>{};
        for (final item in latestClasses) {
          final id = int.tryParse(item['id'].toString());
          final name = (item['name'] ?? '').toString().trim();
          if (id != null && name.isNotEmpty) {
            idsByName[name.toLowerCase()] = id;
          }
        }

        // Kelas yang tertulis di CSV namun belum terdaftar akan dibuat otomatis.
        for (final record in prepared) {
          final className = record['className'];
          if (className == null || className.isEmpty) continue;
          final key = className.toLowerCase();
          if (!idsByName.containsKey(key)) {
            final id = await txn.insert('classes', <String, Object?>{
              'name': className,
              'created_at': DateTime.now().toIso8601String(),
            });
            idsByName[key] = id;
          }
        }

        final latestStudents = await txn.query('students', columns: ['nis']);
        final latestNis = latestStudents
            .map((item) => (item['nis'] ?? '').toString().trim().toLowerCase())
            .toSet();

        for (final record in prepared) {
          final nis = record['nis']!;
          final name = record['name']!;
          final className = record['className'];
          if (!latestNis.add(nis.toLowerCase())) {
            skippedDuringSave++;
            saveErrors.add('NIS $nis ternyata sudah terdaftar.');
            continue;
          }

          final classId =
              className == null ? null : idsByName[className.toLowerCase()];
          await txn.insert('students', <String, Object?>{
            'nis': nis,
            'name': name,
            'class_id': classId,
            'created_at': DateTime.now().toIso8601String(),
          });
          imported++;
        }
      });

      await _loadData();
      if (!mounted) return;

      final skipped = errors.length + skippedDuringSave;
      final message = StringBuffer(
        'Impor selesai: $imported siswa berhasil ditambahkan.',
      );
      if (classesToCreate.isNotEmpty) {
        message.write(' ${classesToCreate.length} kelas baru dibuat.');
      }
      if (skipped > 0) message.write(' $skipped baris dilewati.');
      final details = <String>[...errors, ...saveErrors];
      if (details.isNotEmpty) {
        message.write('\n${details.take(2).join('\n')}');
        if (details.length > 2) message.write('\nDan kesalahan lainnya.');
      }

      _showMessage(
        message.toString(),
        isError: imported == 0 && skipped > 0,
      );
    } catch (e) {
      if (!mounted) return;
      _showMessage('Gagal mengimpor CSV: $e', isError: true);
    }
  }

  Widget _importSummaryTile(
    IconData icon,
    String text,
    Color foreground,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: foreground, size: 20),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: foreground,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // EKSPOR CSV
  // ==========================================================

  Future<void> _exportStudentsCsv() async {
    try {
      final students = await _database.getAll(
        'students',
        orderBy: 'name ASC',
      );

      if (students.isEmpty) {
        _showMessage(
          'Belum ada data siswa untuk diekspor.',
          isError: true,
        );
        return;
      }

      final csvRows = <List<dynamic>>[
        ['NIS', 'Nama Siswa', 'Kelas'],
      ];

      for (final student in students) {
        csvRows.add([
          student['nis'] ?? '',
          student['name'] ?? '',
          _className(student['class_id']),
        ]);
      }

      final csvText = '\uFEFF${csv.encode(csvRows)}';

      final bytes = Uint8List.fromList(
        utf8.encode(csvText),
      );

      final savedPath = await FilePicker.saveFile(
        dialogTitle: 'Simpan Data Siswa',
        fileName: 'data_siswa_damping.csv',
        bytes: bytes,
      );

      if (savedPath == null) {
        return;
      }

      _showMessage('Data siswa berhasil diekspor.');
    } catch (e) {
      if (!mounted) return;
      _showMessage('Gagal mengekspor CSV: $e', isError: true);
    }
  }

  // ==========================================================
  // INPUT DAN PESAN
  // ==========================================================

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primary),
      filled: true,
      fillColor: background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.redAccent : Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
  }

  // ==========================================================
  // SEARCH + SATU TOMBOL TAMBAH
  // ==========================================================

  Widget _buildSearchBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Cari nama atau NIS...',
            hintStyle: TextStyle(
              color: Colors.blueGrey.shade300,
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: primary,
            ),
            suffixIcon: _searchQuery.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Hapus pencarian',
                    onPressed: _searchController.clear,
                    icon: const Icon(Icons.close_rounded),
                  ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(color: Colors.blueGrey.shade100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(color: Colors.blueGrey.shade100),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(color: primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 13),

        // Tombol tambah manual hanya ada di sini.
        SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => _showStudentForm(),
            icon: const Icon(Icons.person_add_alt_1_rounded, size: 22),
            label: const Text(
              'Tambah siswa',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              elevation: 1,
              shadowColor: primary.withValues(alpha: 0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        const SizedBox(height: 9),
        SizedBox(
          height: 46,
          child: OutlinedButton.icon(
            onPressed: _importStudentsCsv,
            icon: const Icon(Icons.upload_file_rounded, size: 21),
            label: const Text(
              'Impor CSV',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: primary,
              backgroundColor: const Color(0xFFEFF6FF),
              side: const BorderSide(color: Color(0xFFC8DCFA)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // MENU IMPOR DAN EKSPOR
  // ==========================================================

  List<PopupMenuEntry<String>> _fileMenuItems() {
    return const [
      PopupMenuItem<String>(
        value: 'import',
        child: Row(
          children: [
            Icon(Icons.file_upload_outlined, color: primary),
            SizedBox(width: 12),
            Text('Impor CSV'),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'export',
        child: Row(
          children: [
            Icon(Icons.file_download_outlined, color: primary),
            SizedBox(width: 12),
            Text('Ekspor CSV'),
          ],
        ),
      ),
    ];
  }

  // ==========================================================
  // TAMPILAN UTAMA
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final displayedStudents = _filteredStudents;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Kelola Data Siswa',
          style: TextStyle(
            color: navy,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: navy,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Impor atau ekspor data',
            icon: const Icon(Icons.more_vert_rounded, color: navy),
            itemBuilder: (context) => _fileMenuItems(),
            onSelected: (value) async {
              if (value == 'import') {
                await _importStudentsCsv();
              } else if (value == 'export') {
                await _exportStudentsCsv();
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade200),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: primary),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                    child: _buildSearchBar(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 14),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7F0FF),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Icon(
                            Icons.groups_rounded,
                            color: primary,
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Data Siswa',
                                style: TextStyle(
                                  color: navy,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${_students.length} siswa terdaftar',
                                style: TextStyle(
                                  color: Colors.blueGrey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7F0FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_students.length}',
                            style: const TextStyle(
                              color: primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: displayedStudents.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                            itemCount: displayedStudents.length,
                            itemBuilder: (context, index) {
                              final student = displayedStudents[index];
                              final name = student['name']?.toString() ?? '-';
                              final nis = student['nis']?.toString() ?? '-';

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: const Color(0xFFE8EEF6),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.025,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 9,
                                  ),
                                  leading: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: const Color(0xFFE7F0FF),
                                    child: Text(
                                      name.isNotEmpty
                                          ? name[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        color: primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    name,
                                    style: const TextStyle(
                                      color: navy,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      'NIS: $nis\n${_className(student['class_id'])}',
                                      style: TextStyle(
                                        color: Colors.blueGrey.shade500,
                                        fontSize: 12,
                                        height: 1.6,
                                      ),
                                    ),
                                  ),
                                  isThreeLine: true,
                                  trailing: PopupMenuButton<String>(
                                    tooltip: 'Aksi siswa',
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _showStudentForm(student: student);
                                      } else if (value == 'delete') {
                                        _deleteStudent(student);
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit_outlined, size: 19),
                                            SizedBox(width: 10),
                                            Text('Edit'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete_outline,
                                              color: Colors.red,
                                              size: 19,
                                            ),
                                            SizedBox(width: 10),
                                            Text('Hapus'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  // ==========================================================
  // EMPTY STATE — TANPA TOMBOL TAMBAH KEDUA
  // ==========================================================

  Widget _buildEmptyState() {
    final bool noStudents = _students.isEmpty;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
      children: [
        const SizedBox(height: 15),
        Center(
          child: Container(
            width: 118,
            height: 118,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE7F0FF),
              border: Border.all(
                color: const Color(0xFFD4E5FF),
                width: 1.5,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 16,
                  right: 18,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: cyan,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const Icon(
                  Icons.school_rounded,
                  color: primary,
                  size: 58,
                ),
                Positioned(
                  bottom: 13,
                  right: 17,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD4E5FF),
                      ),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 23),
        Center(
          child: Text(
            noStudents ? 'Belum Ada Data Siswa' : 'Siswa Tidak Ditemukan',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: navy,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          noStudents
              ? 'Mulai kelola data siswa di DAMPING. '
                  'Tambahkan siswa melalui tombol di atas, '
                  'atau impor data menggunakan file CSV.'
              : 'Coba gunakan nama atau NIS yang berbeda.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blueGrey.shade500,
            fontSize: 14,
            height: 1.65,
          ),
        ),
        const SizedBox(height: 23),
        if (noStudents)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE3ECF8)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Color(0xFFF59E0B),
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tips memulai',
                        style: TextStyle(
                          color: navy,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Pastikan kelas sudah terdaftar agar siswa '
                        'dapat langsung dikaitkan dengan kelas yang sesuai.',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
