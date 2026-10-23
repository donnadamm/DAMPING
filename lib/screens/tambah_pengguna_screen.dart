import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../services/local_database.dart';

class TambahPenggunaScreen extends StatefulWidget {
  const TambahPenggunaScreen({super.key});

  @override
  State<TambahPenggunaScreen> createState() => _TambahPenggunaScreenState();
}

class _TambahPenggunaScreenState extends State<TambahPenggunaScreen> {
  final _namaController = TextEditingController();
  final _hpController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedRole = 'Guru';
  bool _isSaving = false;
  bool _obscurePassword = true;

  List<Map<String, dynamic>> _students = [];
  int? _selectedStudentId;
  bool _isLoadingStudents = false;

  static const Color primaryBlue = Color(0xFF2C7DEB);
  static const Color headingBlue = Color(0xFF0C356A);

  @override
  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    if (mounted) {
      setState(() => _isLoadingStudents = true);
    }

    try {
      final data = await LocalDatabase.instance.getAll(
        'students',
        orderBy: 'name ASC',
      );

      if (!mounted) return;

      setState(() {
        _students = data;
        _isLoadingStudents = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoadingStudents = false);
      debugPrint('Gagal memuat daftar siswa: $e');

      _showMessage(
        'Daftar siswa gagal dimuat.',
        isError: true,
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _hashPassword(String password) {
    // Hash SHA-256 untuk kebutuhan prototipe.
    // Untuk aplikasi produksi, gunakan password hashing
    // dengan salt dan algoritma khusus seperti Argon2id.
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<void> _simpanPengguna() async {
    if (_isSaving) return;

    final nama = _namaController.text.trim();
    final hp = _hpController.text.trim();
    final password = _passwordController.text;

    if (nama.isEmpty || hp.isEmpty || password.isEmpty) {
      _showMessage(
        'Nama, Nomor HP, dan Password wajib diisi!',
        isError: true,
      );
      return;
    }

    if (password.length < 6) {
      _showMessage(
        'Password minimal 6 karakter.',
        isError: true,
      );
      return;
    }

    if (hp.length < 8 || !RegExp(r'^[0-9+]+$').hasMatch(hp)) {
      _showMessage(
        'Masukkan nomor HP yang valid.',
        isError: true,
      );
      return;
    }

    // Nilai role harus sesuai dengan CHECK constraint SQLite.
    final String roleDatabase;
    switch (_selectedRole) {
      case 'Guru':
        roleDatabase = 'guru';
        break;
      case 'Orang Tua':
        roleDatabase = 'orang_tua';
        break;
      case 'Admin':
        roleDatabase = 'admin';
        break;
      default:
        _showMessage('Role tidak valid.', isError: true);
        return;
    }

    if (_selectedRole == 'Orang Tua') {
      if (_isLoadingStudents) {
        _showMessage(
          'Tunggu sampai daftar siswa selesai dimuat.',
          isError: true,
        );
        return;
      }

      if (_students.isEmpty) {
        _showMessage(
          'Belum ada data siswa. Tambahkan siswa terlebih dahulu.',
          isError: true,
        );
        return;
      }

      if (_selectedStudentId == null) {
        _showMessage(
          'Pilih siswa yang menjadi anak dari orang tua ini.',
          isError: true,
        );
        return;
      }
    }

    setState(() => _isSaving = true);

    try {
      await LocalDatabase.instance.insert('users', {
        'name': nama,
        'phone': hp,
        'password_hash': _hashPassword(password),
        'role': roleDatabase,
        'student_id': roleDatabase == 'orang_tua' ? _selectedStudentId : null,
        'is_active': 1,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pengguna berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );

      // Memberi tahu halaman sebelumnya agar memuat ulang data.
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      final errorText = e.toString().toLowerCase();

      if (errorText.contains('unique constraint') ||
          errorText.contains('constraint failed: users.phone')) {
        _showMessage(
          'Nomor HP sudah terdaftar. Gunakan nomor lain.',
          isError: true,
        );
      } else {
        debugPrint('Gagal menyimpan pengguna: $e');
        _showMessage(
          'Pengguna gagal disimpan. Periksa koneksi database.',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tambah Pengguna',
          style: TextStyle(
            color: headingBlue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: headingBlue,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade200,
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Nama Lengkap *'),
            _buildTextField(
              controller: _namaController,
              hint: 'Masukkan nama lengkap',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),
            _buildLabel('Nomor HP *'),
            _buildTextField(
              controller: _hpController,
              hint: '081xxxxxxxxxx',
              icon: Icons.phone_outlined,
              isNumber: true,
            ),
            const SizedBox(height: 20),
            _buildLabel('Password *'),
            _buildTextField(
              controller: _passwordController,
              hint: 'Minimal 6 karakter',
              icon: Icons.lock_outline,
              isObscure: _obscurePassword,
              suffixIcon: IconButton(
                tooltip: _obscurePassword
                    ? 'Tampilkan password'
                    : 'Sembunyikan password',
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey.shade500,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel('Role *'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedRole,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: primaryBlue,
                  ),
                  items: ['Guru', 'Orang Tua', 'Admin'].map((role) {
                    final icon = role == 'Guru'
                        ? Icons.school_outlined
                        : role == 'Orang Tua'
                            ? Icons.family_restroom
                            : Icons.admin_panel_settings_outlined;

                    return DropdownMenuItem<String>(
                      value: role,
                      child: Row(
                        children: [
                          Icon(
                            icon,
                            color: primaryBlue,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            role,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: _isSaving
                      ? null
                      : (newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedRole = newValue;
                              _selectedStudentId = null;
                            });
                          }
                        },
                ),
              ),
            ),
            if (_selectedRole == 'Orang Tua') ...[
              const SizedBox(height: 20),
              _buildLabel('Pilih Siswa *'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _isLoadingStudents
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: primaryBlue,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Memuat daftar siswa...'),
                          ],
                        ),
                      )
                    : _students.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Belum ada siswa terdaftar.',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 13,
                              ),
                            ),
                          )
                        : DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _students.any(
                                (student) =>
                                    student['id'] == _selectedStudentId,
                              )
                                  ? _selectedStudentId
                                  : null,
                              isExpanded: true,
                              hint: const Text(
                                'Pilih siswa yang menjadi anak',
                                style: TextStyle(fontSize: 13),
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: primaryBlue,
                              ),
                              items: _students.map((student) {
                                final id = student['id'] as int;
                                final namaSiswa =
                                    student['name']?.toString() ?? 'Tanpa nama';
                                final nis = student['nis']?.toString() ?? '';

                                return DropdownMenuItem<int>(
                                  value: id,
                                  child: Text(
                                    nis.isEmpty
                                        ? namaSiswa
                                        : '$namaSiswa ($nis)',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                );
                              }).toList(),
                              onChanged: _isSaving
                                  ? null
                                  : (id) {
                                      setState(() {
                                        _selectedStudentId = id;
                                      });
                                    },
                            ),
                          ),
              ),
            ],
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: primaryBlue,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Untuk orang tua, pastikan sudah terdaftar '
                      'sebagai wali dari siswa.',
                      style: TextStyle(
                        color: Color(0xFF1E56A0),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _simpanPengguna,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  disabledBackgroundColor: Colors.blue.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Simpan Pengguna',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
          color: headingBlue,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isNumber = false,
    bool isObscure = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
      obscureText: isObscure,
      enabled: !_isSaving,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 13,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.grey.shade400,
          size: 20,
        ),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: primaryBlue,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
