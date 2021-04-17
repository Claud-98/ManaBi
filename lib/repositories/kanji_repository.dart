import 'package:manabi/models/kaku_data_required_for_build.dart';
import 'package:manabi/models/kaku_kanji.dart';
import 'package:manabi/models/yomu_data_required_for_build.dart';
import 'package:manabi/models/yomu_kanji.dart';
import 'package:manabi/services/KakuKanjiApiProvider.dart';
import 'package:manabi/services/SharedPreferencesManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/dbhelper.dart';

class KanjiRepository {
  KakuKanjiApiProvider _apiProvider = KakuKanjiApiProvider();

  static Future<List<YomuKanji>> getAllYomuKanji() async {
    final results = await db.query(DBHelper.yomuKanjiTable);
    List<YomuKanji> yomuKanjis = [];

    for (final el in results) {
      final yomuKanji = YomuKanji.fromMapObject(el);
      yomuKanjis.add(yomuKanji);
    }
    return yomuKanjis;
  }

  static Future<YomuKanji> getYomuKanji(String kanji) async {
    final sql = '''SELECT * FROM ${DBHelper.yomuKanjiTable}
    WHERE ${DBHelper.kanji} = ?''';

    List<dynamic> params = [kanji];
    final data = await db.rawQuery(sql, params);

    final yomuKanji = YomuKanji.fromMapObject(data.first);
    return yomuKanji;
  }

  Future<List<YomuKanji>> getYomuKanjiOfUnitLevel(int unit, int level,) async {
    final sql = '''SELECT * FROM ${DBHelper.yomuKanjiTable}
    WHERE ${DBHelper.unit} = ? AND ${DBHelper.level} = ?''';

    List<dynamic> params = [unit, level];
    final data = await db.rawQuery(sql, params);

    final List<YomuKanji> yomuKanjis = [];

    for (final el in data) {
      final yomuKanji = YomuKanji.fromMapObject(el);
      yomuKanjis.add(yomuKanji);
    }

    return yomuKanjis;
  }

  static Future<int> getYomuLevelBestScore(int unit, int level, bool translation) async {
    String sql;
    String rowName;
    if(!translation){
      sql = '''SELECT ${DBHelper.yomuScoreRead} FROM ${DBHelper.yomuScoreTable}
    WHERE ${DBHelper.unit} = ? AND ${DBHelper.level} = ?''';
      rowName = DBHelper.yomuScoreRead;
    }else{
      sql = '''SELECT ${DBHelper.yomuScoreTran} FROM ${DBHelper.yomuScoreTable}
    WHERE ${DBHelper.unit} = ? AND ${DBHelper.level} = ?''';
      rowName = DBHelper.yomuScoreTran;
    }

    List<dynamic> params = [unit, level];
    final data = await db.rawQuery(sql, params);
    final int levelScore = data[0][rowName];
    return levelScore;
  }

  static Future<void> updateYomuLevelBestScore(int score, int unit, int level,
      bool translation) async {
    if(!translation){
      db.rawUpdate('''UPDATE ${DBHelper.yomuScoreTable} 
      SET ${DBHelper.yomuScoreRead} = ? 
      WHERE ${DBHelper.unit} = ? AND ${DBHelper.level} = ?''',
          [score, unit, level]);
    }else{
      db.rawUpdate('''UPDATE ${DBHelper.yomuScoreTable} 
      SET ${DBHelper.yomuScoreTran} = ? 
      WHERE ${DBHelper.unit} = ? AND ${DBHelper.level} = ?''',
          [score, unit, level]);
    }
  }

  getRomajiState() async {
    SharedPreferences prefs = await SharedPreferencesManager.getSharedPreferencesInstance();
    return (prefs.getBool(SharedPreferencesManager.romajiKey) ?? false);
  }

  Future<YomuDataRequiredForBuild> fetchAllYomuData(int unit, int level, bool translation) async {
       return YomuDataRequiredForBuild(
      bestScore: await getYomuLevelBestScore(unit, level, translation),
      kanjiLevelList: await getYomuKanjiOfUnitLevel(unit, level),
      romaji: await getRomajiState(),
    );
  }

  Future<KakuKanji> getKakuKanji(String kanji){
    try {
      return _apiProvider.getKakuKanji(kanji);
    }catch(error){
      return null;
    }
  }

  static Future<List<String>> getListKakuKanjiOfUnitLevel(int unit, int level,) async {
    final sql = '''SELECT * FROM ${DBHelper.kakuKanjiTable}
    WHERE ${DBHelper.unit} = ? AND ${DBHelper.level} = ?''';

    List<dynamic> params = [unit, level];
    final data = await db.rawQuery(sql, params);
    final List<String> kakuKanjis = [];

    for (final el in data) {
      final kakuKanji = el['kanji'];
      kakuKanjis.add(kakuKanji);
    }

    return kakuKanjis;
  }

  Future<List<KakuKanji>> getKakuKanjiOfUnitLevel(int unit, int level,) async {
    List<String> toFetchKanji = await getListKakuKanjiOfUnitLevel(unit, level);
    final List<KakuKanji> kakuKanjis = [];
    print(toFetchKanji);

      for (final el in toFetchKanji) {
        final kakuKanji = await getKakuKanji(el).catchError((error){
          throw(error);
        });
        kakuKanjis.add(kakuKanji);
      }

    return kakuKanjis;
  }

  Future<KakuDataRequiredForBuild> fetchAllKakuData(int unit, int level) async {
    List<KakuKanji> kanjiList = await getKakuKanjiOfUnitLevel(unit, level);
    bool romaji = await getRomajiState();
    List<String> allReadings = [];

    for (final el in kanjiList) {
      List<String> listKun;
      List<String> listOn;
      if(!romaji) {
        listKun = el.kanji.kunyomi.hiragana.split('、');
        listOn = el.kanji.onyomi.katakana.split('、');
      } else {
        listKun = el.kanji.kunyomi.romaji.replaceAll(' ', '').split(',');
        listOn = el.kanji.onyomi.romaji.replaceAll(' ', '').split(',');
      }

      allReadings.addAll(listKun);
      allReadings.addAll(listOn);

    }
    print(allReadings);

    return KakuDataRequiredForBuild(
      bestScore: await getKakuLevelBestScore(unit, level),
      kanjiLevelList: kanjiList,
      kunAndOnYomi: allReadings,
      romaji: romaji,
    );
  }

  static Future<int> getKakuLevelBestScore(int unit, int level) async {
    String sql = '''SELECT ${DBHelper.kakuScore} FROM ${DBHelper.kakuScoreTable}
    WHERE ${DBHelper.unit} = ? AND ${DBHelper.level} = ?''';

    List<dynamic> params = [unit, level];
    final data = await db.rawQuery(sql, params);
    final int levelScore = data[0][DBHelper.kakuScore];
    return levelScore;
  }

  static Future<void> updateKakuLevelBestScore(int score, int unit, int level) async {
    db.rawUpdate('''UPDATE ${DBHelper.kakuScoreTable} 
    SET ${DBHelper.kakuScore} = ? 
    WHERE ${DBHelper.unit} = ? AND ${DBHelper.level} = ?''', [score, unit, level]);

  }

}