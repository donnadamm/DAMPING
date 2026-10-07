class DummyData {
  // Data Admin
  static List<Map<String, dynamic>> admin = [
    {
      'nama': 'Dona Damayanti',
      'hp': '081273487877',
      'password': 'admin',
      'role': 'Admin'
    },
  ];

  // Data Guru
  static List<Map<String, dynamic>> guru = [
    {
      'nama': 'Bu Dona',
      'hp': '081234567890',
      'password': '123',
      'role': 'Guru - Wali Kelas X RPL 1'
    },
    {
      'nama': 'Pak Budi',
      'hp': '081298765432',
      'password': '123',
      'role': 'Guru - Wali Kelas X RPL 2'
    },
  ];

  // Data Orang Tua
  static List<Map<String, dynamic>> orangTua = [
    {
      'nama': 'Siti Aminah',
      'hp': '081311112222',
      'password': '123',
      'role': 'Orang Tua'
    },
    {
      'nama': 'Ahmad Fauzi',
      'hp': '081533334444',
      'password': '123',
      'role': 'Orang Tua'
    },
    {
      'nama': 'Rokayah',
      'hp': '081199998888',
      'password': '123',
      'role': 'Orang Tua'
    },
  ];

  // Data Siswa
  static List<Map<String, dynamic>> siswa = [
    {'nama': 'Andi Pratama', 'kelas': 'X RPL 1'},
    {'nama': 'Citra Lestari', 'kelas': 'X RPL 1'},
    {'nama': 'Budi Santoso', 'kelas': 'X RPL 2'},
    {'nama': 'Deni Kurniawan', 'kelas': 'X RPL 2'},
  ];

  // Data Pelanggaran
  static List<Map<String, dynamic>> pelanggaran = [
    {
      'nama': 'Andi Pratama',
      'kasus': 'Terlambat masuk sekolah\n12 Sep 2026 • 5 poin',
      'status': 'SP 1'
    },
    {
      'nama': 'Citra Lestari',
      'kasus': 'Membolos\n10 Sep 2026 • 20 poin',
      'status': 'SP 2'
    },
    {
      'nama': 'Budi Santoso',
      'kasus': 'Tidak memakai atribut\n09 Sep 2026 • 5 poin',
      'status': 'Normal'
    },
  ];
}
