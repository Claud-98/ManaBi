import 'package:manabi/models/yomu_kanji.dart';
import 'package:sqflite/sqflite.dart';

import 'dbhelper.dart';

class KanjiRepository {
  static Future<List<YomuKanji>> getAllYomuKanji() async {
    final results = await db.query(DBHelper.yomuKanjiTable);
    List<YomuKanji> yomuKanjis = List();

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


/*
  static Future<void> addYomuKanjiRawQuery(YomuKanji yomuKanji) async {
    final sql = '''INSERT INTO ${DBHelper.yomuKanjiTable}(
                    ${DBHelper.kanji},
                    ${DBHelper.reading},
                    ${DBHelper.romaji},
                    ${DBHelper.translation},
                    ${DBHelper.unit})
                  VALUES (?,?,?,?,?)
                ''';
    List<dynamic> params = [yomuKanji.kanji, yomuKanji.reading,
      yomuKanji.romaji, yomuKanji.translation, yomuKanji.unit];
    final result = await db.rawInsert(sql, params);
    DBHelper.dbLogging('Add Yomu Kanji', sql, null, result, params);
  }
*/

  static Future<void> addYomuKanji(YomuKanji yomuKanji) async {
    final result = await db.insert(DBHelper.yomuKanjiTable, yomuKanji.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    DBHelper.dbLogging(
        'Add Yomu Kanji', 'insert', null, result, [yomuKanji.toMap()]);
  }

}