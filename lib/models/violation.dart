import '../core/constants/violation_rules.dart';

class Violation {
  final String id;
  final String namaSiswa;
  final String kelas;
  final String jenisPelanggaran;
  final int poin;
  final String tanggal;
  final String catatanGuru;
  final int poinSebelum;
  final String statusVerifikasi;

  Violation({
    required this.id,
    required this.namaSiswa,
    required this.kelas,
    required this.jenisPelanggaran,
    required this.poin,
    required this.tanggal,
    required this.catatanGuru,
    required this.poinSebelum,
    required this.statusVerifikasi,
  });

  int get totalPoinBaru => poinSebelum + poin;
  String get kategori => ViolationRules.getCategory(poin);
  String get rekomendasiSp => ViolationRules.getSpStatus(totalPoinBaru);
}