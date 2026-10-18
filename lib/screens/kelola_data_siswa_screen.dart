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
    final bool isEditing = student != null;

    final nisController = TextEditingController(
      text: student?['nis']?.toString() ?? '',
    );
    final nameController = TextEditingController(
      text: student?['name']?.toString() ?? '',
    );

    int? selectedClassId =
        student?['class_id'] is int ? student!['class_id'] as int : null;

    if (selectedClassId != null &&
        !_classes.any(
          (item) => item['id'].toString() == selectedClassId.toString(),
        )) {
      selectedClassId = null;
    }

    final formKey = GlobalKey<FormState>();

    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          bool isSaving = false;

          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                title: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7F0FF),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        isEditing
                            ? Icons.edit_rounded
                            : Icons.person_add_alt_1_rounded,
                        color: primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isEditing ? 'Edit Data Siswa' : 'Tambah Siswa',
                        style: const TextStyle(
                          color: navy,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                content: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.78,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: nisController,
                              decoration: _inputDecoration(
                                'Nomor Induk Siswa (NIS)',
                                Icons.badge_outlined,
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'NIS wajib diisi';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: nameController,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.done,
                              decoration: _inputDecoration(
                                'Nama lengkap siswa',
                                Icons.person_outline_rounded,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Nama siswa wajib diisi';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField<int?>(
                              initialValue: selectedClassId,
                              isExpanded: true,
                              decoration: _inputDecoration(
                                'Kelas',
                                Icons.school_outlined,
                              ),
                              items: [
                                const DropdownMenuItem<int?>(
                                  value: null,
                                  child: Text('Belum ditentukan'),
                                ),
                                ..._classes.map((item) {
                                  return DropdownMenuItem<int?>(
                                    value: item['id'] as int,
                                    child: Text(
                                      item['name'].toString(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }),
                              ],
                              onChanged: (value) {
                                setDialogState(() {
                                  selectedClassId = value;
                                });
                              },
                            ),
                            if (_classes.isEmpty) ...[
                              const SizedBox(height: 12),
                              const Text(
                                'Belum ada kelas. Kamu dapat menyimpan '
                                'siswa tanpa kelas dan menambah kelas '
                                'melalui menu Kelola Kelas.',
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed:
                        isSaving ? null : () => Navigator.pop(dialogContext),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: isSaving
                        ? null
                        : () async {
                            if (!formKey.currentState!.validate()) return;

                            setDialogState(() => isSaving = true);

                            try {
                              final nis = nisController.text.trim();
                              final name = nameController.text.trim();

                              final duplicate = _students.any((item) {
                                final sameNis =
                                    item['nis'].toString().toLowerCase() ==
                                        nis.toLowerCase();
                                final sameStudent = item['id']?.toString() ==
                                    student?['id']?.toString();
                                return sameNis && !sameStudent;
                              });

                              if (duplicate) {
                                setDialogState(() => isSaving = false);
                                _showMessage(
                                  'NIS tersebut sudah digunakan.',
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
                                await _database.updateById(
                                  'students',
                                  student['id'] as int,
                                  values,
                                );
                              } else {
                                values['created_at'] =
                                    DateTime.now().toIso8601String();
                                await _database.insert('students', values);
                              }

                              if (!dialogContext.mounted) return;
                              Navigator.pop(dialogContext);

                              await _loadData();
                              if (!mounted) return;

                              _showMessage(
                                isEditing
                                    ? 'Data siswa berhasil diperbarui.'
                                    : 'Siswa berhasil ditambahkan.',
                              );
                            } catch (e) {
                              if (!dialogContext.mounted) return;
                              setDialogState(() => isSaving = false);
                              _showMessage(
                                'Gagal menyimpan data siswa: $e',
                                isError: true,
                              );
                            }
                          },
                    child: isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(isEditing ? 'Simpan' : 'Tambah'),
                  ),
                ],
              );
            },
          );
        },
      );
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

      String content = utf8.decode(
        bytes,
        allowMalformed: true,
      );

      content = content.replaceFirst('\uFEFF', '');

      final rows = csv.decode(content);

      if (rows.length < 2) {
        _showMessage(
          'CSV kosong atau tidak memiliki data siswa.',
          isError: true,
        );
        return;
      }

      String normalizeHeader(dynamic value) =>
          value.toString().trim().toLowerCase().replaceAll('_', ' ');

      final headers = rows.first.map(normalizeHeader).toList();

      final nisIndex = headers.indexWhere((h) => h == 'nis');
      final nameIndex = headers.indexWhere(
        (h) =>
            h == 'nama' ||
            h == 'nama siswa' ||
            h == 'name' ||
            h == 'student name',
      );
      final classIndex = headers.indexWhere(
        (h) => h == 'kelas' || h == 'class',
      );

      if (nisIndex == -1 || nameIndex == -1) {
        _showMessage(
          'CSV harus memiliki kolom NIS dan Nama Siswa.',
          isError: true,
        );
        return;
      }

      final currentStudents = await _database.getAll(
        'students',
        orderBy: 'name ASC',
      );

      final existingNis = currentStudents
          .map(
            (s) => s['nis'].toString().trim().toLowerCase(),
          )
          .toSet();

      final classIds = <String, int>{};
      for (final item in _classes) {
        classIds[item['name'].toString().trim().toLowerCase()] =
            item['id'] as int;
      }

      int imported = 0;
      int skipped = 0;
      final errors = <String>[];

      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];

        if (row.every((cell) => cell.toString().trim().isEmpty)) {
          continue;
        }

        try {
          if (row.length <= nisIndex ||
              row.length <= nameIndex ||
              (classIndex != -1 && row.length <= classIndex)) {
            skipped++;
            errors.add('Baris ${i + 1}: kolom tidak lengkap.');
            continue;
          }

          final nis = row[nisIndex].toString().trim();
          final name = row[nameIndex].toString().trim();
          final className =
              classIndex == -1 ? '' : row[classIndex].toString().trim();

          if (nis.isEmpty || name.isEmpty) {
            skipped++;
            errors.add('Baris ${i + 1}: NIS dan nama wajib diisi.');
            continue;
          }

          if (existingNis.contains(nis.toLowerCase())) {
            skipped++;
            errors.add('Baris ${i + 1}: NIS $nis sudah terdaftar.');
            continue;
          }

          int? classId;
          if (className.isNotEmpty) {
            classId = classIds[className.toLowerCase()];
            if (classId == null) {
              skipped++;
              errors.add(
                'Baris ${i + 1}: kelas "$className" belum terdaftar.',
              );
              continue;
            }
          }

          await _database.insert(
            'students',
            <String, Object?>{
              'nis': nis,
              'name': name,
              'class_id': classId,
              'created_at': DateTime.now().toIso8601String(),
            },
          );

          existingNis.add(nis.toLowerCase());
          imported++;
        } catch (_) {
          skipped++;
          errors.add('Baris ${i + 1}: gagal disimpan.');
        }
      }

      await _loadData();
      if (!mounted) return;

      final message = StringBuffer(
        'Impor selesai: $imported siswa ditambahkan.',
      );

      if (skipped > 0) message.write(' $skipped baris dilewati.');
      if (errors.isNotEmpty) {
        message.write('\n${errors.take(3).join('\n')}');
        if (errors.length > 3) message.write('\nDan kesalahan lainnya.');
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
          height: 54,
          child: ElevatedButton.icon(
            onPressed: () => _showStudentForm(),
            icon: const Icon(Icons.add_rounded, size: 24),
            label: const Text(
              'Tambah Siswa',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: primary.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
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
