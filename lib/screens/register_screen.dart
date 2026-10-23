import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import '../services/local_database.dart';

// ==========================================
// 1. HALAMAN PILIH JENIS AKUN
// ==========================================
class RegisterTypeScreen extends StatelessWidget {
  const RegisterTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pilih Jenis Akun',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF2C7DEB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8F1FF).withValues(alpha: 0.7),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE3EEFF).withValues(alpha: 0.5),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 150,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.app_registration_rounded,
                      size: 80,
                      color: Color(0xFF2C7DEB),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Daftar Sebagai',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0C356A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pilih jenis akun yang sesuai dengan peran Anda di sekolah.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    const SizedBox(height: 40),

                    // Pilihan Orang Tua
                    _buildRoleCard(
                      context,
                      title: 'Orang Tua / Wali',
                      subtitle: 'Pantau pelanggaran dan informasi anak',
                      icon: Icons.family_restroom,
                      isParent: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterParentScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Pilihan Guru
                    _buildRoleCard(
                      context,
                      title: 'Guru / Staf',
                      subtitle: 'Catat dan kelola pelanggaran siswa',
                      icon: Icons.school,
                      isParent: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterGuruScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isParent,
    required VoidCallback onTap,
  }) {
    const blue = Color(0xFF2C7DEB);
    final foreground = isParent ? const Color(0xFF0C356A) : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isParent ? Colors.white : blue,
          borderRadius: BorderRadius.circular(16),
          border: isParent ? Border.all(color: blue, width: 1.5) : null,
          boxShadow: [
            BoxShadow(
              color: blue.withValues(alpha: isParent ? 0.1 : 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isParent
                    ? const Color(0xFFE8F1FF)
                    : Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isParent ? blue : Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: foreground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isParent ? Colors.black54 : Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: isParent ? blue : Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. HALAMAN REGISTRASI GURU
// ==========================================
class RegisterGuruScreen extends StatefulWidget {
  const RegisterGuruScreen({super.key});

  @override
  State<RegisterGuruScreen> createState() => _RegisterGuruScreenState();
}

class _RegisterGuruScreenState extends State<RegisterGuruScreen> {
  final _namaController = TextEditingController();
  final _hpController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSaving = false;
  bool _obscurePassword = true;

  static const Color primaryBlue = Color(0xFF2C7DEB);
  static const Color headingBlue = Color(0xFF0C356A);

  @override
  void dispose() {
    _namaController.dispose();
    _hpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _daftarGuru() async {
    if (_isSaving) return;

    final nama = _namaController.text.trim();
    final hp = _hpController.text.trim();
    final password = _passwordController.text;

    final validation = _validateAccount(nama, hp, password);
    if (validation != null) {
      _showMessage(validation, isError: true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final db = await LocalDatabase.instance.database;

      final existing = await db.query(
        'users',
        columns: ['id'],
        where: 'phone = ?',
        whereArgs: [hp],
        limit: 1,
      );

      if (existing.isNotEmpty) {
        _showMessage('Nomor HP sudah terdaftar.', isError: true);
        return;
      }

      await LocalDatabase.instance.insert('users', {
        'name': nama,
        'phone': hp,
        'password_hash': _hashPassword(password),
        'role': 'guru',
        'is_active': 1,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;

      await _showSuccessDialog(
        'Akun berhasil dibuat. Silakan login menggunakan nomor HP dan password yang didaftarkan.',
      );
    } catch (e) {
      if (!mounted) return;
      _showMessage(
        'Pendaftaran gagal. Periksa data dan database: $e',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Daftar Akun Guru'),
        backgroundColor: Colors.white,
        foregroundColor: headingBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildTextField(
              controller: _namaController,
              icon: Icons.person_outline,
              hint: 'Nama Lengkap',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _hpController,
              icon: Icons.phone_outlined,
              hint: 'Nomor HP',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _passwordController,
              icon: Icons.lock_outline,
              hint: 'Password minimal 6 karakter',
              isPassword: true,
              obscurePassword: _obscurePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildSubmitButton(
              label: 'Daftar Sekarang',
              isSaving: _isSaving,
              onPressed: _daftarGuru,
            ),
            const SizedBox(height: 12),
            const Text(
              'Catatan: akun guru yang dibuat melalui pendaftaran mandiri '
              'langsung aktif. Untuk penggunaan sekolah sebenarnya, '
              'pendaftaran guru sebaiknya diverifikasi oleh admin.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSuccessDialog(String message) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 60,
            ),
            const SizedBox(height: 20),
            const Text(
              'Pendaftaran Berhasil!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: headingBlue,
              ),
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Kembali ke Login'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }
}

// ==========================================
// 3. HALAMAN REGISTRASI ORANG TUA
// ==========================================
class RegisterParentScreen extends StatefulWidget {
  const RegisterParentScreen({super.key});

  @override
  State<RegisterParentScreen> createState() => _RegisterParentScreenState();
}

class _RegisterParentScreenState extends State<RegisterParentScreen> {
  final _namaController = TextEditingController();
  final _hpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nisController = TextEditingController();
  final _hubunganController = TextEditingController();

  bool _isSaving = false;
  bool _obscurePassword = true;
  bool _isSearchingStudent = false;

  Map<String, Object?>? _selectedStudent;

  static const Color primaryBlue = Color(0xFF2C7DEB);
  static const Color headingBlue = Color(0xFF0C356A);

  @override
  void dispose() {
    _namaController.dispose();
    _hpController.dispose();
    _passwordController.dispose();
    _nisController.dispose();
    _hubunganController.dispose();
    super.dispose();
  }

  Future<void> _cariSiswa() async {
    final nis = _nisController.text.trim();

    if (nis.isEmpty) {
      _showMessage('Masukkan NIS siswa terlebih dahulu.', isError: true);
      return;
    }

    setState(() {
      _isSearchingStudent = true;
      _selectedStudent = null;
    });

    try {
      final db = await LocalDatabase.instance.database;
      final results = await db.rawQuery('''
        SELECT students.id, students.nis, students.name,
               classes.name AS class_name
        FROM students
        LEFT JOIN classes ON classes.id = students.class_id
        WHERE students.nis = ?
        LIMIT 1
      ''', [nis]);

      if (!mounted) return;

      if (results.isEmpty) {
        _showMessage(
          'NIS tidak ditemukan. Periksa kembali NIS atau hubungi admin sekolah.',
          isError: true,
        );
      } else {
        setState(() => _selectedStudent = results.first);
        _showMessage('Data siswa ditemukan.');
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage('Gagal mencari siswa: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSearchingStudent = false);
      }
    }
  }

  Future<void> _daftarOrangTua() async {
    if (_isSaving) return;

    final nama = _namaController.text.trim();
    final hp = _hpController.text.trim();
    final password = _passwordController.text;
    final hubungan = _hubunganController.text.trim();

    final validation = _validateAccount(nama, hp, password);
    if (validation != null) {
      _showMessage(validation, isError: true);
      return;
    }

    if (_selectedStudent == null) {
      _showMessage(
        'Cari dan pastikan data anak ditemukan terlebih dahulu.',
        isError: true,
      );
      return;
    }

    if (hubungan.isEmpty) {
      _showMessage(
        'Isi hubungan dengan siswa, misalnya Ayah, Ibu, atau Wali.',
        isError: true,
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final db = await LocalDatabase.instance.database;
      final existing = await db.query(
        'users',
        columns: ['id'],
        where: 'phone = ?',
        whereArgs: [hp],
        limit: 1,
      );

      if (existing.isNotEmpty) {
        _showMessage('Nomor HP sudah terdaftar.', isError: true);
        return;
      }

      // Simpan hubungan orang tua dengan siswa melalui student_id.
      // Informasi hubungan juga disimpan pada nama akun agar tidak
      // membutuhkan perubahan skema database.
      final accountName = '$nama ($hubungan)';

      await LocalDatabase.instance.insert('users', {
        'name': accountName,
        'phone': hp,
        'password_hash': _hashPassword(password),
        'role': 'orang_tua',
        'student_id': _selectedStudent!['id'],
        'is_active': 1,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;

      await _showSuccessDialog(
        'Akun berhasil dibuat dan terhubung dengan '
        '${_selectedStudent!['name']}. Silakan login menggunakan nomor HP dan password Anda.',
      );
    } catch (e) {
      if (!mounted) return;
      _showMessage(
        'Pendaftaran gagal. Periksa data dan database: $e',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = _selectedStudent;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Daftar Akun Orang Tua'),
        backgroundColor: Colors.white,
        foregroundColor: headingBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Nama Lengkap Anda *'),
            _buildTextField(
              controller: _namaController,
              icon: Icons.person_outline,
              hint: 'Masukkan nama lengkap',
            ),
            const SizedBox(height: 16),
            _buildLabel('Nomor HP *'),
            _buildTextField(
              controller: _hpController,
              icon: Icons.phone_outlined,
              hint: '081xxxxxxxxxx',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildLabel('Password *'),
            _buildTextField(
              controller: _passwordController,
              icon: Icons.lock_outline,
              hint: 'Minimal 6 karakter',
              isPassword: true,
              obscurePassword: _obscurePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Divider(),
            ),
            const Text(
              'Data Anak (Siswa)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: headingBlue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Masukkan NIS yang telah terdaftar di sekolah untuk '
              'menghubungkan akun Anda dengan data siswa.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            _buildLabel('NIS Siswa *'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _nisController,
                    icon: Icons.badge_outlined,
                    hint: 'Masukkan NIS anak',
                    enabled: !_isSaving,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        _isSearchingStudent || _isSaving ? null : _cariSiswa,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSearchingStudent
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Cari'),
                  ),
                ),
              ],
            ),
            if (student != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFB8D5FF)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      color: primaryBlue,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Data siswa ditemukan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: headingBlue,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('Nama: ${student['name']}'),
                          Text('NIS: ${student['nis']}'),
                          Text('Kelas: ${student['class_name'] ?? '-'}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            _buildLabel('Hubungan dengan Siswa *'),
            _buildTextField(
              controller: _hubunganController,
              icon: Icons.family_restroom,
              hint: 'Ayah / Ibu / Wali',
              enabled: !_isSaving,
            ),
            const SizedBox(height: 24),
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
                      'Pastikan NIS benar. Untuk menjaga keamanan data siswa, '
                      'sekolah sebaiknya memverifikasi hubungan orang tua '
                      'dengan siswa sebelum akun digunakan untuk mengakses data.',
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
            _buildSubmitButton(
              label: 'Daftar & Hubungkan Siswa',
              isSaving: _isSaving,
              onPressed: _daftarOrangTua,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSuccessDialog(String message) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.verified_user_rounded,
              color: Colors.green,
              size: 60,
            ),
            const SizedBox(height: 20),
            const Text(
              'Pendaftaran Berhasil!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: headingBlue,
              ),
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Kembali ke Login'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }
}

// ==========================================
// 4. FUNGSI BANTUAN BERSAMA
// ==========================================

String _hashPassword(String password) {
  return sha256.convert(utf8.encode(password)).toString();
}

String? _validateAccount(String nama, String hp, String password) {
  if (nama.isEmpty || hp.isEmpty || password.isEmpty) {
    return 'Nama, Nomor HP, dan Password wajib diisi.';
  }

  if (password.length < 6) {
    return 'Password minimal 6 karakter.';
  }

  if (hp.length < 8 || !RegExp(r'^[0-9+]+$').hasMatch(hp)) {
    return 'Masukkan nomor HP yang valid.';
  }

  return null;
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

Widget _buildTextField({
  required TextEditingController controller,
  required IconData icon,
  required String hint,
  TextInputType keyboardType = TextInputType.text,
  bool isPassword = false,
  bool obscurePassword = true,
  Widget? suffixIcon,
  bool enabled = true,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: isPassword && obscurePassword,
    enabled: enabled,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 13,
      ),
      prefixIcon: Icon(icon, color: const Color(0xFF2C7DEB)),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 12,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF2C7DEB),
          width: 1.5,
        ),
      ),
    ),
  );
}

Widget _buildSubmitButton({
  required String label,
  required bool isSaving,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: isSaving ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2C7DEB),
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.blue.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: isSaving
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    ),
  );
}
