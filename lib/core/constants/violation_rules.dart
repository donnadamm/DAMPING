class ViolationRules {
  static String getSpStatus(int totalPoints) {
    if (totalPoints <= 9) return 'Normal';
    if (totalPoints <= 24) return 'Peringatan Poin';
    if (totalPoints <= 50) return 'SP-1';
    if (totalPoints <= 75) return 'SP-2';
    return 'SP-3';
  }

  static String getCategory(int points) {
    if (points <= 10) return 'Ringan';
    if (points <= 25) return 'Sedang';
    return 'Berat';
  }
}
