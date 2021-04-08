import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:manabi/custom_colors.dart';
import 'package:manabi/models/kaku_kanji.dart';
import 'package:manabi/repositories/kanji_repository.dart';
import 'package:manabi/widgets/all_confetti_widget.dart';
import 'package:manabi/widgets/end_game_widget.dart';
import 'package:manabi/widgets/kaku_kanji_box.dart';

import 'draggable_text_widget.dart';

class KakuGame extends StatefulWidget {
  final int unit;
  final int level;
  final int bestScore;
  final List<KakuKanji> kanji;
  final List<String> kunAndOnYomi;
  final bool romaji;

  const KakuGame({Key key, this.kanji, this.kunAndOnYomi, this.unit, this.level,
    this.bestScore, this.romaji, }) : super(key: key);
  @override
  _KakuGameState createState() => _KakuGameState();
}


class _KakuGameState extends State<KakuGame> {
  MediaQueryData _mediaQueryData;
  int _unit;
  int _level;
  bool _romaji;
  List<KakuKanji> _kanji;
  List<String> _kunAndOnYomi;
  List<KakuKanji> _items2;
  List<String> _items;
  int _score;
  int _best;
  int _addMatch;
  int _subNotMatch;
  bool _perfect;
  bool _gameOver;

  
  
  
  List<Color> _colors;

  @override
  void initState() {
    super.initState();
    _unit = widget.unit;
    _level = widget.level;
    _kanji = widget.kanji; // da spostare in intGame anche riga sotto
    _kunAndOnYomi = widget.kunAndOnYomi;
    _romaji = widget.romaji;
    _colors = initColors();
    _best = widget.bestScore;
    initGame();
    _addMatch = (100 / _items.length).truncate();
    _subNotMatch = (_addMatch/2).truncate();
  }
  
  void initGame(){
    setState(() {
      _items = List<String>.from(_kunAndOnYomi);
      _items2 = List<KakuKanji>.from(_kanji);
      _items.shuffle();
      _score = 0;
      _perfect = true;
      _gameOver = false;
    });
  }

  Widget buildListDraggable(double height, double width, double textSize, double screenHeight, double screenWidth) {
    double gridWidth;
    int gridItem;
    var map = _items.map((item) {
      int index = _items.indexOf(item);
      Color color = _colors[index];

        return Draggable<String>(
          data: item,
          childWhenDragging: Container(height: height, width: width),
          feedback: DraggableTextWidget(widgetText: item,
            color: color, height: height, width: width, textSize:  textSize,),
          child: DraggableTextWidget(widgetText: item,
            color: color, height: height, width: width, textSize: textSize,),
        );
    }).toList();

    if(_mediaQueryData.orientation == Orientation.landscape){
      gridWidth = screenWidth/1.2;
      gridItem = 5;
    }else {
      gridWidth = screenWidth/1.1;
      gridItem = 3;
    }

    return Container(
      width: gridWidth,
      child: Center(
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: gridItem,
          childAspectRatio: 2,
          children: map,
        ),
      ),
    );
  }

  List<Color> initColors(){
    List<Color> colors = [];
    int index = 0;

    for(int i=0; i<30; i++){
      switch (index) {
        case 0:
          colors.add(CustomColors().murasaki);
          break;
        case 1:
          colors.add(CustomColors().orenji);
          break;
        case 2:
          colors.add(CustomColors().chokoMinto);
          break;
        case 3:
          colors.add(CustomColors().halfNezumi);
          break;
      }

      if(index == 3)
        index = 0;
      else
        index++;
    }

    return colors;
  }

  Widget buildListDragTarget(double screenHeight, double screenWidth,
      double textSize, double itemHeight, double itemWidth) {
    List<Widget> col1 = [];
    List<Widget> col2 = [];
    double screenHeightOrWidth;


    if(_mediaQueryData.orientation == Orientation.landscape){
     screenHeightOrWidth = screenWidth/1.2;
    }else {
      screenHeightOrWidth = screenHeight;
    }

    var map = _items2.map((item){
      int index = _items2.indexOf(item);
      Color color = _colors[index];
      List<String> kanjiItemsPathOn;
      List<String> kanjiItemsPathKun;

      if(!_romaji) {
        kanjiItemsPathOn = item.kanji.onyomi.katakana.split('、');
        kanjiItemsPathKun = item.kanji.kunyomi.hiragana.split('、');
      }else{
        kanjiItemsPathOn = item.kanji.onyomi.romaji.replaceAll(' ', '').split(',');
        kanjiItemsPathKun = item.kanji.kunyomi.romaji.replaceAll(' ', '').split(',');
      }

      return GestureDetector(
        onDoubleTap: (){
          print("tapped");
        },
        child: DragTarget<String>(
            onAccept: (receivedItem){
            if(checkList(kanjiItemsPathOn, receivedItem) ||
                checkList(kanjiItemsPathKun, receivedItem)){
              setState(() {
                _items.remove(receivedItem);
                if(_perfect && _items.length == 0)
                  _score = 100;
                else
                  _score += _addMatch;

              });
            }else{
              setState(() {
                _score-=_subNotMatch;
                _perfect = false;
              });
            }
          },
          builder: (context, acceptedItems,rejectedItem) => KakuKanjiBox(
              text: item.kanji.character, color: color, reverse: index%2!=0, //&& _items2.length > 3,
              screenHeightOrWidth: screenHeightOrWidth, textSize: textSize),
        ),
      );
    }).toList();

      for (int i = 0; i < map.length; i++) {
        if (i.isEven)
          col1.add(map[i]);
        else
          col2.add(map[i]);
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: col1,
            ),
          ),

          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: buildListDraggable(
                  itemHeight, itemWidth, textSize, screenHeight, screenWidth),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: col2,
            ),
          ),
        ],
      );

  }

  bool checkList(List<String> list, String element){
    if(list != null){
      for(int i=0; i < list.length; i++){
        if(element == list[i])
          return true;
      }
    }
    return false;
  }

  void updateBestScore(int score, int bestScore, int unit, int level){
    if(score > bestScore){
      KanjiRepository.updateKakuLevelBestScore(score, unit, level);
      setState(() {
        _best = score;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    double appBarSize = AppBar().preferredSize.height;
    final unitHeightValue = _mediaQueryData.size.height * 0.01;
    final double screenHeight = _mediaQueryData.size.height -
        appBarSize - _mediaQueryData.padding.top;
    final double screenWidth = _mediaQueryData.size.width;
    double itemHeight;
    double itemWidth;
    double multiplier;

    if(_mediaQueryData.orientation == Orientation.landscape){
      itemHeight = screenHeight/7;
      itemWidth = screenWidth/6.5;
      multiplier= 7.5;

    }else {
      itemHeight = screenHeight/14;
      itemWidth = screenWidth/4.25;
      multiplier = 3.75;
    }

    if(_items.length == 0) {
      updateBestScore(_score, _best, _unit, _level);
      _gameOver = true;
      appBarSize = 0;
    }

    return Scaffold(
      backgroundColor: CustomColors().nezumihiro,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarSize),
        child: AppBar(
          centerTitle: true,
          title: AutoSizeText('Score: ' + "$_score" +  ' Best: ' + "$_best",),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            if(!_gameOver)
            Container(
              height: screenHeight,
                width: screenWidth,
                child: buildListDragTarget(screenHeight, screenWidth,
                    unitHeightValue * multiplier, itemHeight, itemWidth)),
            if(_gameOver)
              Container(
                height: screenHeight,
                width: screenWidth,
                child: Center(
                  child: AllConfettiWidget(
                    child: EndGameWidget(score: _score, best: _best, textSize: unitHeightValue *
                        multiplier, repeatLevel: initGame,),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
