import 'package:flutter/material.dart';

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
class RegisterGuruScreen extends StatelessWidget {
  const RegisterGuruScreen({super.key});

  // Fungsi untuk menampilkan pop-up sukses dan kembali ke Login
  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // Tidak bisa ditutup dengan mengetuk luar area
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: Colors.green, size: 60),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pendaftaran Berhasil!',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0C356A)),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    // Kembali ke Halaman Login dan hapus semua riwayat halaman sebelumnya
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C7DEB),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Kembali ke Login',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
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
      appBar: AppBar(
        title: const Text('Daftar Akun Guru'),
        backgroundColor: const Color(0xFF2C7DEB),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lengkapi Data Guru',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0C356A))),
            const SizedBox(height: 6),
            const Text(
                'Pastikan data yang dimasukkan sesuai dengan identitas Anda.',
                style: TextStyle(color: Colors.black54, fontSize: 13)),
            const SizedBox(height: 24),
            _buildTextField(icon: Icons.person_outline, hint: 'Nama Lengkap'),
            const SizedBox(height: 16),
            _buildTextField(
                icon: Icons.phone_outlined,
                hint: 'Nomor HP',
                keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField(icon: Icons.badge_outlined, hint: 'NIP / NIK'),
            const SizedBox(height: 16),
            _buildTextField(
                icon: Icons.account_balance_outlined, hint: 'Kode Sekolah'),
            const SizedBox(height: 16),
            _buildTextField(
                icon: Icons.lock_outline, hint: 'Password', isPassword: true),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Simulasi proses validasi dan akun dibuat
                  _showSuccessDialog(context,
                      'Akun Guru Anda berhasil dibuat. Silakan login untuk melanjutkan.');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C7DEB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text('Daftar Sekarang',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
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
class RegisterParentScreen extends StatelessWidget {
  const RegisterParentScreen({super.key});

  // Fungsi untuk menampilkan pop-up sukses
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_user_rounded,
                    color: Colors.green, size: 60),
              ),
              const SizedBox(height: 20),
              const Text(
                'Data Valid!',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0C356A)),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    // Kembali ke Login
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C7DEB),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Selesai & Login',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
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
      appBar: AppBar(
        title: const Text('Daftar Akun Orang Tua'),
        backgroundColor: const Color(0xFF2C7DEB),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lengkapi Data Orang Tua',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0C356A))),
            const SizedBox(height: 6),
            const Text('Hubungkan akun Anda dengan data anak (siswa) Anda.',
                style: TextStyle(color: Colors.black54, fontSize: 13)),
            const SizedBox(height: 24),
            _buildTextField(
                icon: Icons.person_outline, hint: 'Nama Lengkap Anda'),
            const SizedBox(height: 16),
            _buildTextField(
                icon: Icons.phone_outlined,
                hint: 'Nomor HP',
                keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField(
                icon: Icons.lock_outline, hint: 'Password', isPassword: true),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Divider(),
            ),
            const Text('Data Anak (Siswa)',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0C356A))),
            const SizedBox(height: 16),
            _buildTextField(
                icon: Icons.qr_code_outlined, hint: 'NIS / Kode Siswa'),
            const SizedBox(height: 16),
            _buildTextField(
                icon: Icons.family_restroom,
                hint: 'Hubungan (Contoh: Ayah / Ibu / Wali)'),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Simulasi Validasi Anak dan akun berhasil dihubungkan
                  _showSuccessDialog(context,
                      'Akun berhasil dibuat dan dihubungkan dengan data siswa.');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C7DEB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text('Daftar & Hubungkan Siswa',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
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
    {required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false}) {
  return TextField(
    keyboardType: keyboardType,
    obscureText: isPassword,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.5),
      prefixIcon: Icon(icon, color: const Color(0xFF2C7DEB)),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF2C7DEB), width: 1.5),
      ),
    ),
  );
}
