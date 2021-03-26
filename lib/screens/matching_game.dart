import 'package:flutter/material.dart';
import 'package:manabi/models/yomu_kanji.dart';
import 'package:manabi/repositories/kanji_repository.dart';
import 'package:manabi/screens/yomu_game.dart';

class MatchingGame extends StatefulWidget {
  final int unit;
  final int levelNumber;
  final String type;

  MatchingGame({Key key, @required this.unit,
    @required this.levelNumber, @required this.type}) : super(key: key);

  @override
  _MatchingGameState createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {

  @override
  Widget build(BuildContext context) {
    Future<List<YomuKanji>> kanjiFetched =
      //KanjiRepository.getYomuKanjiOfUnitLevel(widget.unit, widget.levelNumber);
      KanjiRepository.getAllYomuKanji();
    return Scaffold(
      body: FutureBuilder<List<YomuKanji>>(
        future: kanjiFetched,
        builder: (context, snapshot){
          if(snapshot.hasData)
              return YomuGame(data: snapshot.data);
          else if(snapshot.hasError)
            return Text('Error');
          else
            return CircularProgressIndicator();
        },
      ),
    );
  }
}
