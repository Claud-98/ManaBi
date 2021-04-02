import 'dart:async';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DBHelper {
  static const dbName = 'Kanji';

  static const yomuKanjiTable = 'yomuKanji';
  static const kanji = 'kanji';
  static const reading = 'reading';
  static const romaji = 'romaji';
  static const translation = 'translation';
  static const unit = 'unit';
  static const level = 'level';
  static const yomuScoreTable = 'YomuScore';
  static const yomuScoreRead = 'YomuScoreRead';
  static const yomuScoreTran = 'YomuScoreTran';
  static const kakuScore = 'KakuScore';


  static void dbLogging(String functionName, String sql,
      [List<Map<String, dynamic>> selectQueryResult,
        int insertAndUpdateQueryResult,
        List<dynamic> params]) {
    print(functionName);

    print(sql);
    if (params != null) {
      print(params);
    }
    if (selectQueryResult != null) {
      print(selectQueryResult);
    } else if (insertAndUpdateQueryResult != null) {
      print(insertAndUpdateQueryResult);
    }
  }

  Future<void> createYomuKanjiTable(Database db) async {
    final todoSql = '''CREATE TABLE $yomuKanjiTable (
      $kanji TEXT PRIMARY KEY,
      $reading TEXT,
      $romaji TEXT,
      $translation TEXT,
      $unit INTEGER,
      $level INTEGER),''';

    await db.execute(todoSql);
  }

  Future<void> createYomuScoreTable(Database db) async {
    final todoSql = '''CREATE TABLE LevelScore (
      $unit INTEGER,
      $level INTEGER,
      $yomuScoreRead INTEGER,
      $yomuScoreTran INTEGER),''';
    await db.execute(todoSql);
  }

  Future<void> initDatabase() async {

    WidgetsFlutterBinding.ensureInitialized();
    io.Directory applicationDirectory =
    await getApplicationDocumentsDirectory();

    String dbPath =
    path.join(applicationDirectory.path, "database.db");

    bool dbExists= await io.File(dbPath).exists();

    if (!dbExists) {
      // Copy from asset
      ByteData data = await rootBundle.load(path.join("assets/db", "database.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await io.File(dbPath).writeAsBytes(bytes, flush: true);
    }

    db = await openDatabase(dbPath);


  }

  Future<void> onCreate(Database db, int version) async {
    await createYomuKanjiTable(db);
    await createYomuScoreTable(db);
  }
}