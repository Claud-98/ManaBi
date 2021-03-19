
class YomuKanji {

  final String kanji;
  final String reading;
  final String romaji;
  final String translation;
  final int unit;

  YomuKanji(this.kanji, this.reading, this.romaji, this.translation, this.unit);

  Map<String, dynamic> toMap() {
    return {
      'kanji': kanji,
      'reading': reading,
      'romaji': romaji,
      'translation': translation,
      'unit': unit,
    };
  }
  YomuKanji.fromMapObject(Map<String, dynamic> yomuKanjiMap)
      : kanji = yomuKanjiMap['kanji'],
        reading = yomuKanjiMap['reading'],
        romaji = yomuKanjiMap['romaji'],
        translation = yomuKanjiMap['translation'],
        unit = yomuKanjiMap['unit'];

  @override
  String toString() {
    return 'YomuKanji{kanji: $kanji, reading: $reading, romaji: $romaji, '
        'translation: $translation, unit: $unit}';
  }
}
