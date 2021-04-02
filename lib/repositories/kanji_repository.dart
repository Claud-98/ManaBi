import 'package:manabi/models/yomu_kanji.dart';

import 'dbhelper.dart';

class KanjiRepository {
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

  static Future<List<YomuKanji>> getYomuKanjiOfUnitLevel(int unit, int level,) async {
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

}