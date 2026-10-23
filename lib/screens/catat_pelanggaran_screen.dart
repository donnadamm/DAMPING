import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/local_database.dart';

class CatatPelanggaranScreen extends StatefulWidget {
  const CatatPelanggaranScreen({super.key});

  @override
  State<CatatPelanggaranScreen> createState() => _CatatPelanggaranScreenState();
}

class _CatatPelanggaranScreenState extends State<CatatPelanggaranScreen> {
  final LocalDatabase _database = LocalDatabase.instance;

  final TextEditingController _poinController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  List<Map<String, Object?>> _students = [];
  List<Map<String, Object?>> _jenisPelanggaran = [];

  int? _selectedStudentId;
  int? _selectedViolationTypeId;
  DateTime _selectedDate = DateTime.now();

  bool _isLoading = true;
  bool _isSaving = false;

  Map<String, Object?>? get _selectedStudent {
    for (final student in _students) {
      if (student['id'] == _selectedStudentId) return student;
    }
    return null;
  }

  Map<String, Object?>? get _selectedViolation {
    for (final item in _jenisPelanggaran) {
      if (item['id'] == _selectedViolationTypeId) return item;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  @override
  void dispose() {
    _poinController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _loadFormData() async {
    try {
      final students = await _database.getAll(
        'students',
        orderBy: 'name ASC',
      );

      final db = await _database.database;
      final types = await db.query(
        'violation_types',
        where: 'is_active = ?',
        whereArgs: [1],
        orderBy: 'category ASC, name ASC',
      );

      if (!mounted) return;

      setState(() {
        _students = students;
        _jenisPelanggaran = types;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      _showMessage('Gagal memuat data formulir: $e', isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  Future<void> _pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2C7DEB),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0C356A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _lihatDetailSiswa() async {
    final student = _selectedStudent;
    if (student == null) return;

    final db = await _database.database;
    final history = await db.rawQuery('''
      SELECT violation_name, points, occurred_at, sp_status, status
      FROM violations
      WHERE student_id = ?
      ORDER BY occurred_at DESC, id DESC
      LIMIT 5
    ''', [student['id']]);

    if (!mounted) return;

    final total = history.fold<int>(
      0,
      (sum, row) => sum + ((row['points'] as num?)?.toInt() ?? 0),
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(student['name'].toString()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NIS: ${student['nis'] ?? '-'}'),
            Text('ID siswa: ${student['id']}'),
            const SizedBox(height: 12),
            Text('Total poin dari 5 catatan terbaru: $total'),
            const SizedBox(height: 12),
            const Text(
              'Riwayat pelanggaran terbaru',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            if (history.isEmpty)
              const Text('Belum ada riwayat pelanggaran.')
            else
              ...history.map(
                (row) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '• ${row['violation_name']} '
                    '(+${row['points']} poin)',
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

  Future<void> _simpanPelanggaran() async {
    if (_selectedStudentId == null) {
      _showMessage('Pilih siswa terlebih dahulu.', isError: true);
      return;
    }

    final jenis = _selectedViolation;
    if (jenis == null) {
      _showMessage(
        'Pilih jenis pelanggaran terlebih dahulu.',
        isError: true,
      );
      return;
    }

    if (_poinController.text.isEmpty) {
      _showMessage('Poin pelanggaran belum tersedia.', isError: true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final db = await _database.database;
      final now = DateTime.now().toIso8601String();
      final points = (jenis['points'] as num).toInt();

      await db.insert('violations', {
        'student_id': _selectedStudentId,
        'teacher_id': null,
        'violation_type_id': _selectedViolationTypeId,
        'violation_name': jenis['name'],
        'points': points,
        'direct_sp': jenis['direct_sp'],
        'description': _catatanController.text.trim().isEmpty
            ? null
            : _catatanController.text.trim(),
        'status': 'Menunggu Verifikasi Admin',
        'sp_status': 'Normal',
        'parent_alert_sent': 0,
        'sp_document_issued': 0,
        'occurred_at': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'created_at': now,
      });

      if (!mounted) return;

      _showMessage('Pelanggaran berhasil disimpan.');
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        _showMessage('Gagal menyimpan pelanggaran: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = _selectedStudent;
    final formattedDate =
        DateFormat('dd MMM yyyy', 'id_ID').format(_selectedDate);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Catat Pelanggaran',
          style: TextStyle(
            color: Color(0xFF0C356A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0C356A),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Pilih Siswa *'),
                  _buildDropdown<int>(
                    value: _selectedStudentId,
                    hint: 'Pilih siswa yang melakukan pelanggaran',
                    items: _students.map((s) {
                      final id = s['id'] as int;
                      return DropdownMenuItem<int>(
                        value: id,
                        child: Text(
                          '${s['name']} (${s['nis']})',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (id) {
                      setState(() => _selectedStudentId = id);
                    },
                  ),
                  if (_students.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Belum ada siswa. Tambahkan data siswa terlebih dahulu.',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  if (student != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: const Color(0xFFE8F1FF),
                            child: Text(
                              student['name'].toString().isNotEmpty
                                  ? student['name'].toString()[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Color(0xFF2C7DEB),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student['name'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0C356A),
                                  ),
                                ),
                                Text(
                                  'NIS: ${student['nis'] ?? '-'}',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: _lihatDetailSiswa,
                            child: const Text('Lihat Detail'),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  _buildLabel('Jenis Pelanggaran *'),
                  _buildDropdown<int>(
                    value: _selectedViolationTypeId,
                    hint: 'Pilih jenis pelanggaran',
                    items: _jenisPelanggaran.map((item) {
                      final id = item['id'] as int;
                      return DropdownMenuItem<int>(
                        value: id,
                        child: Text(
                          '${item['name']} (${item['category']})',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (id) {
                      setState(() {
                        _selectedViolationTypeId = id;
                        final selected = _selectedViolation;
                        _poinController.text =
                            selected == null ? '' : '${selected['points']}';
                      });
                    },
                  ),
                  if (_jenisPelanggaran.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Jenis pelanggaran belum tersedia. Tambahkan jenis '
                        'pelanggaran beserta poinnya terlebih dahulu.',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  const SizedBox(height: 20),
                  _buildLabel('Tanggal *'),
                  InkWell(
                    onTap: _pilihTanggal,
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: _inputDecoration(
                        suffixIcon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Color(0xFF2C7DEB),
                          size: 20,
                        ),
                      ),
                      child: Text(formattedDate),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Poin Pelanggaran *'),
                  TextField(
                    controller: _poinController,
                    readOnly: true,
                    decoration: _inputDecoration(
                      hintText: '',
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Catatan (opsional)'),
                  TextField(
                    controller: _catatanController,
                    maxLines: 3,
                    decoration: _inputDecoration(
                      hintText: 'Masukkan catatan tambahan...',
                    ),
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSaving ||
                              _students.isEmpty ||
                              _jenisPelanggaran.isEmpty
                          ? null
                          : _simpanPelanggaran,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C7DEB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSaving
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Simpan Pelanggaran',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Color(0xFF0C356A),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: items.any((item) => item.value == value) ? value : null,
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
          isExpanded: true,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    String? hintText,
    Widget? suffixIcon,
    bool filled = false,
    Color? fillColor,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      suffixIcon: suffixIcon,
      filled: filled,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF2C7DEB),
          width: 1.5,
        ),
      ),
    );
  }
}
