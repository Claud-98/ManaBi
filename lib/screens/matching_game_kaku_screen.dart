import 'package:flutter/material.dart';
import 'package:manabi/models/kaku_data_required_for_build.dart';
import 'package:manabi/repositories/kanji_repository.dart';
import 'package:manabi/widgets/kaku_game.dart';


class MatchingGameKaku extends StatefulWidget {
  final int unit;
  final int levelNumber;
  final bool romaji;


  MatchingGameKaku({Key key, @required this.unit, @required this.levelNumber,
    this.romaji,}) : super(key: key);

  @override
  _MatchingGameKakuState createState() => _MatchingGameKakuState();
}

class _MatchingGameKakuState extends State<MatchingGameKaku> {
  Future <KakuDataRequiredForBuild>  _dataRequiredForBuild;
  int _unit;
  int _level;


  @override
  void initState() {
    super.initState();
    _unit = widget.unit;
    _level = widget.levelNumber;
    _dataRequiredForBuild = KanjiRepository().fetchAllKakuData(_unit, _level);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder<KakuDataRequiredForBuild>(
        future: _dataRequiredForBuild,
        builder: (context, snapshot){

          if(snapshot.hasData) {
            print(snapshot.data.kanjiLevelList);
            print(snapshot.data.kunAndOnYomi);
            return (KakuGame(unit: _unit, level: _level,
              kanji: snapshot.data.kanjiLevelList,
              kunAndOnYomi: snapshot.data.kunAndOnYomi,
              romaji: snapshot.data.romaji,
              bestScore: snapshot.data.bestScore,
            ));
          }
          else if(snapshot.hasError)
            return Text(snapshot.error.toString());
          else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
