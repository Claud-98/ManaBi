import 'package:flutter/material.dart';
import 'package:manabi/models/yomu_data_required_for_build.dart';
import 'package:manabi/repositories/kanji_repository.dart';
import 'package:manabi/screens/yomu_game.dart';


class MatchingGame extends StatefulWidget {
  final int unit;
  final int levelNumber;
  final String type;
  final bool translation;
  final bool romaji;


  MatchingGame({Key key, @required this.unit,
    @required this.levelNumber, @required this.type, this.translation, this.romaji,
  }) : super(key: key);

  @override
  _MatchingGameState createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  Future<YomuDataRequiredForBuild> _dataRequiredForBuild;
  //bool _romaji;

/*
  _loadRomajiState() async {
    SharedPreferences prefs = await SharedPreferencesManager.getSharedPreferencesInstance();
    setState(() {
      _romaji = (prefs.getBool(SharedPreferencesManager.romajiKey) ?? false);
    });
  }
*/
/*
  Future<YomuDataRequiredForBuild> _fetchAllData(int unit, int level, bool translation) async {
    SharedPreferences prefs = await
      SharedPreferencesManager.getSharedPreferencesInstance();


    return YomuDataRequiredForBuild(
      bestScore: await KanjiRepository.getYomuLevelBestScore(unit, level, translation),
      kanjiLevelList: await KanjiRepository.getYomuKanjiOfUnitLevel(unit, level),
      romaji: (prefs.getBool(SharedPreferencesManager.romajiKey) ?? false),
    );
  }
*/
  @override
  void initState() {
    super.initState();
    _dataRequiredForBuild = KanjiRepository().fetchAllYomuData(widget.unit,
        widget.levelNumber, widget.translation);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder<YomuDataRequiredForBuild>(
        future: _dataRequiredForBuild,
        builder: (context, snapshot){
          final int unit = widget.unit;
          final int level = widget.levelNumber;
          final bool translation = widget.translation;

          if(snapshot.hasData) {

            return YomuGame(data: snapshot.data.kanjiLevelList,unit: unit,
              level: level, translation: translation, romaji: snapshot.data.romaji,
              bestScore: snapshot.data.bestScore);
          }
          else if(snapshot.hasError)
            return Text('Error');
          else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
