class DummyData {
  // Data Guru (Awalnya kita buat 2 guru)
  static List<Map<String, dynamic>> guru = [
    {
      'nama': 'Bu Dona',
      'hp': '081234567890',
      'role': 'Guru - Wali Kelas X RPL 1'
    },
    {
      'nama': 'Pak Budi',
      'hp': '081298765432',
      'role': 'Guru - Wali Kelas X RPL 2'
    },
  ];

  // Data Orang Tua (Awalnya 3 orang tua)
  static List<Map<String, dynamic>> orangTua = [
    {'nama': 'Siti Aminah', 'hp': '081311112222', 'role': 'Orang Tua'},
    {'nama': 'Ahmad Fauzi', 'hp': '081533334444', 'role': 'Orang Tua'},
    {'nama': 'Rokayah', 'hp': '081199998888', 'role': 'Orang Tua'},
  ];

  // Data Siswa (Awalnya 4 siswa)
  static List<Map<String, dynamic>> siswa = [
    {'nama': 'Andi Pratama', 'kelas': 'X RPL 1'},
    {'nama': 'Citra Lestari', 'kelas': 'X RPL 1'},
    {'nama': 'Budi Santoso', 'kelas': 'X RPL 2'},
    {'nama': 'Deni Kurniawan', 'kelas': 'X RPL 2'},
  ];

  // Data Pelanggaran (Awalnya 3 pelanggaran)
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
