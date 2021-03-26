
class YomuKanji {

  final String kanji;
  final String reading;
  final String romaji;
  final String translation;
  final int unit;
  final int level;

  YomuKanji(this.kanji, this.reading, this.romaji, this.translation,
      this.unit, this.level);

  Map<String, dynamic> toMap() {
    return {
      'kanji': kanji,
      'reading': reading,
      'romaji': romaji,
      'translation': translation,
      'unit': unit,
      'level': level,
    };
  }
  YomuKanji.fromMapObject(Map<String, dynamic> yomuKanjiMap)
      : kanji = yomuKanjiMap['kanji'],
        reading = yomuKanjiMap['reading'],
        romaji = yomuKanjiMap['romaji'],
        translation = yomuKanjiMap['translation'],
        unit = yomuKanjiMap['unit'],
        level = yomuKanjiMap['level'];


  @override
  String toString() {
    return 'YomuKanji{kanji: $kanji, reading: $reading, romaji: $romaji, '
        'translation: $translation, unit: $unit, level: $level}';
  }
}
