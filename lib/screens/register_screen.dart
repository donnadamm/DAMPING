import 'package:flutter/material.dart';
import 'package:damping_app/data/dummy_data.dart';

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
        title: const Text('Pilih Jenis Akun',
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF2C7DEB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Elemen Latar Belakang Lingkaran Atas
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
          // Elemen Latar Belakang Lingkaran Bawah
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

          // Konten Utama
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
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

                  // Kartu Pilihan Orang Tua
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterParentScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFF2C7DEB), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF2C7DEB).withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8F1FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.family_restroom,
                                color: Color(0xFF2C7DEB), size: 28),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Orang Tua / Wali',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0C356A))),
                                SizedBox(height: 4),
                                Text('Pantau perkembangan & pelanggaran anak',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black54)),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              color: Color(0xFF2C7DEB), size: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Kartu Pilihan Guru
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterGuruScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C7DEB),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF2C7DEB).withValues(alpha: 0.3),
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
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.school,
                                color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Guru / Staf',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                SizedBox(height: 4),
                                Text('Catat & kelola data pelanggaran siswa',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white70)),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
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

  void _daftarGuru() {
    if (_namaController.text.isEmpty ||
        _hpController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Data wajib diisi semua!'),
          backgroundColor: Colors.redAccent));
      return;
    }

    // SIMPAN DATA KE DUMMY DATABASE
    DummyData.guru.add({
      'nama': _namaController.text.trim(),
      'hp': _hpController.text.trim(),
      'password': _passwordController.text.trim(),
      'role': 'Guru',
    });

    _showSuccessDialog(context,
        'Akun Guru Anda berhasil dibuat. Silakan login untuk melanjutkan.');
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.green, size: 60),
              const SizedBox(height: 20),
              const Text('Pendaftaran Berhasil!',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0C356A))),
              const SizedBox(height: 12),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54, fontSize: 14)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false),
                child: const Text('Kembali ke Login'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Daftar Akun Guru')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildTextField(
                controller: _namaController,
                icon: Icons.person_outline,
                hint: 'Nama Lengkap'),
            const SizedBox(height: 16),
            _buildTextField(
                controller: _hpController,
                icon: Icons.phone_outlined,
                hint: 'Nomor HP',
                keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField(
                controller: _passwordController,
                icon: Icons.lock_outline,
                hint: 'Password',
                isPassword: true),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _daftarGuru,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C7DEB)),
                child: const Text('Daftar Sekarang',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
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

  void _daftarOrangTua() {
    if (_namaController.text.isEmpty ||
        _hpController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Data wajib diisi semua!'),
          backgroundColor: Colors.redAccent));
      return;
    }

    // SIMPAN DATA KE DUMMY DATABASE
    DummyData.orangTua.add({
      'nama': _namaController.text.trim(),
      'hp': _hpController.text.trim(),
      'password': _passwordController.text.trim(),
      'role': 'Orang Tua',
    });

    _showSuccessDialog(
        context, 'Akun berhasil dibuat dan dihubungkan dengan data siswa.');
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_user_rounded,
                  color: Colors.green, size: 60),
              const SizedBox(height: 20),
              const Text('Data Valid!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false),
                child: const Text('Selesai & Login'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Daftar Akun Orang Tua')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildTextField(
                controller: _namaController,
                icon: Icons.person_outline,
                hint: 'Nama Lengkap Anda'),
            const SizedBox(height: 16),
            _buildTextField(
                controller: _hpController,
                icon: Icons.phone_outlined,
                hint: 'Nomor HP',
                keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField(
                controller: _passwordController,
                icon: Icons.lock_outline,
                hint: 'Password',
                isPassword: true),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _daftarOrangTua,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C7DEB)),
                child: const Text('Daftar & Hubungkan Siswa',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// WIDGET BANTUAN UNTUK TEXTFIELD
// ==========================================
Widget _buildTextField(
    {required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: isPassword,
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF2C7DEB)),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
    ),
  );
}
