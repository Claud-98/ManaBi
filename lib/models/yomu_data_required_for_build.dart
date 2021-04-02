import 'package:manabi/models/yomu_kanji.dart';

class YomuDataRequiredForBuild {
  int bestScore;
  List<YomuKanji> kanjiLevelList;
  bool romaji;

  YomuDataRequiredForBuild({
    this.bestScore,
    this.kanjiLevelList,
    this.romaji,
  });


}