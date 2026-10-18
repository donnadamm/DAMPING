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

  List<Map<String, Object?>> _students = [];
  List<Map<String, Object?>> _classes = [];

  bool _isLoading = true;
  String _searchQuery = '';

  static const Color primary = Color(0xFF246BCE);
  static const Color navy = Color(0xFF163B75);
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
  // MEMUAT DATA DARI SQLITE
  // ==========================================================

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final results = await Future.wait([
        _database.getAll('students', orderBy: 'name ASC'),
        _database.getAll('classes', orderBy: 'name ASC'),
      ]);

      if (!mounted) return;

      setState(() {
        _students = results[0];
        _classes = results[1];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
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
  // FORM TAMBAH DAN EDIT SISWA
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
            (item) => item['id'].toString() == selectedClassId.toString())) {
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
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  isEditing ? 'Edit Data Siswa' : 'Tambah Siswa',
                  style: const TextStyle(
                    color: navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: SizedBox(
                  // Lebar dialog dibatasi berdasarkan layar HP.
                  width: MediaQuery.sizeOf(context).width * 0.82,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 420,
                    ),
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
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: nameController,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.done,
                              decoration: _inputDecoration(
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
                            const SizedBox(height: 16),
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
                                  child: Text(
                                    'Belum ditentukan',
                                  ),
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
                              const SizedBox(height: 10),
                              const Text(
                                'Belum ada kelas. Data siswa tetap '
                                'bisa disimpan tanpa kelas. Tambahkan '
                                'kelas melalui menu Kelola Kelas.',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 12,
                                  height: 1.4,
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
                    child: const Text(
                      'Batal',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: isSaving
                        ? null
                        : () async {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }

                            setDialogState(() {
                              isSaving = true;
                            });

                            try {
                              final nis = nisController.text.trim();
                              final name = nameController.text.trim();

                              // Pastikan NIS tidak digunakan
                              // oleh siswa lainnya.
                              final duplicate = _students.any((item) {
                                final sameNis =
                                    item['nis'].toString().toLowerCase() ==
                                        nis.toLowerCase();

                                final sameStudent = item['id']?.toString() ==
                                    student?['id']?.toString();

                                return sameNis && !sameStudent;
                              });

                              if (duplicate) {
                                setDialogState(() {
                                  isSaving = false;
                                });

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

                                await _database.insert(
                                  'students',
                                  values,
                                );
                              }

                              if (!dialogContext.mounted) {
                                return;
                              }

                              Navigator.pop(dialogContext);

                              await _loadData();

                              if (!mounted) return;

                              _showMessage(
                                isEditing
                                    ? 'Data siswa berhasil diperbarui.'
                                    : 'Siswa berhasil ditambahkan.',
                              );
                            } catch (e) {
                              if (!dialogContext.mounted) {
                                return;
                              }

                              setDialogState(() {
                                isSaving = false;
                              });

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
                        : Text(
                            isEditing ? 'Simpan' : 'Tambah',
                          ),
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
        title: const Text(
          'Hapus Data Siswa',
          style: TextStyle(
            color: navy,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Apakah kamu yakin ingin menghapus '
          '${student['name']}?',
        ),
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

      // Riwayat pelanggaran harus tetap terjaga.
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

      await _database.deleteById(
        'students',
        student['id'] as int,
      );

      await _loadData();

      if (!mounted) return;

      _showMessage('Data siswa berhasil dihapus.');
    } catch (e) {
      _showMessage(
        'Gagal menghapus data siswa: $e',
        isError: true,
      );
    }
  }

  // ==========================================================
  // KOMPONEN INPUT DAN PESAN
  // ==========================================================

  InputDecoration _inputDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primary),
      filled: true,
      fillColor: background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: primary,
          width: 1.5,
        ),
      ),
    );
  }

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.redAccent : Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // ==========================================================
  // WIDGET PENCARIAN RESPONSIF
  // ==========================================================

  Widget _buildSearchBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool compact = constraints.maxWidth < 380;

        final searchField = TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Cari nama atau NIS...',
            hintStyle: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: primary,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        );

        final addButton = SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () => _showStudentForm(),
            icon: const Icon(Icons.add, size: 19),
            label: Text(compact ? 'Tambah' : 'Tambah Siswa'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );

        // Di layar sempit, tombol ditempatkan di bawah
        // pencarian supaya tidak memaksa lebar Row.
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              searchField,
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: addButton,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: searchField),
            const SizedBox(width: 10),
            addButton,
          ],
        );
      },
    );
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: navy,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: primary,
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      20,
                      16,
                      12,
                    ),
                    child: _buildSearchBar(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      4,
                      20,
                      12,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.people_alt_outlined,
                          color: primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Data Siswa (${_students.length})',
                            style: const TextStyle(
                              color: navy,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
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
                            padding: const EdgeInsets.fromLTRB(
                              16,
                              0,
                              16,
                              24,
                            ),
                            itemCount: displayedStudents.length,
                            itemBuilder: (context, index) {
                              final student = displayedStudents[index];

                              final name = student['name']?.toString() ?? '-';
                              final nis = student['nis']?.toString() ?? '-';

                              return Container(
                                margin: const EdgeInsets.only(
                                  bottom: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade100,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.025),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  leading: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: const Color(0xFFE8F1FF),
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
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                    ),
                                    child: Text(
                                      'NIS: $nis\n'
                                      '${_className(student['class_id'])}',
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
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _showStudentForm(
                                          student: student,
                                        );
                                      } else if (value == 'delete') {
                                        _deleteStudent(student);
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit_outlined,
                                              size: 19,
                                            ),
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

  Widget _buildEmptyState() {
    final bool noStudents = _students.isEmpty;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 65),
        Icon(
          noStudents ? Icons.school_outlined : Icons.search_off_rounded,
          size: 70,
          color: Colors.grey.shade300,
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            noStudents ? 'Belum ada data siswa' : 'Siswa tidak ditemukan',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: navy,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            noStudents
                ? 'Tekan tombol Tambah untuk memasukkan '
                    'data siswa ke database.'
                : 'Coba gunakan nama atau NIS yang berbeda.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ),
        if (noStudents) ...[
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => _showStudentForm(),
              icon: const Icon(Icons.add),
              label: const Text('Tambah Siswa'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
