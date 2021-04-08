import 'package:manabi/models/kaku_kanji.dart';

class KakuDataRequiredForBuild {
  int bestScore;
  List<KakuKanji> kanjiLevelList;
  List<String> kunAndOnYomi;
  bool romaji;

  KakuDataRequiredForBuild({
    this.bestScore,
    this.kanjiLevelList,
    this.kunAndOnYomi,
    this.romaji,
  });


}