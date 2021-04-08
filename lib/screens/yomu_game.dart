import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manabi/models/yomu_kanji.dart';
import 'package:manabi/repositories/kanji_repository.dart';
import 'package:manabi/widgets/all_confetti_widget.dart';
import 'package:manabi/widgets/draggable_text_widget.dart';
import 'package:manabi/widgets/end_game_widget.dart';
import '../custom_colors.dart';

class YomuGame extends StatefulWidget {
  final List<YomuKanji> data;
  final int unit;
  final int level;
  final bool translation;
  final bool romaji;
  final int bestScore;
  final VoidCallback fun;

  const YomuGame({Key key, @required this.data, @required this.unit,
    @required this.level, @required this.translation, this.romaji,
    @required this.bestScore, this.fun,
    }) : super(key: key);

  @override
  _YomuGameState createState() => _YomuGameState();
}

class _YomuGameState extends State<YomuGame> {
  MediaQueryData _mediaQueryData;
  int _unit;
  int _level;
  bool _translation;
  bool _romaji;
  List<YomuKanji> _items;
  List<YomuKanji> _items2;
  int indexColor;
  int _score;
  int _best;
  bool _gameOver;
  int _addMatch;
  int _subNotMatch;
  bool _perfect;


  Color pickColor(int index){
    Color color;

      switch (index) {
      case 0: color = CustomColors().murasaki;
      break;
      case 1: color = CustomColors().orenji;
      break;
      case 2: color = CustomColors().chokoMinto;
      break;
      case 3: color = CustomColors().murasaki;
      break;
      case 4: color = CustomColors().orenji;
      break;
      case 5: color = CustomColors().chokoMinto;
      break;
      case 6: color = CustomColors().murasaki;
      break;
      case 7: color = CustomColors().orenji;
      break;
      case 8: color = CustomColors().chokoMinto;
      break;
      case 9: color = CustomColors().murasaki;
      break;
      case 10: color = CustomColors().orenji;
      break;
      case 11: color = CustomColors().chokoMinto;
      break;
      default: color = CustomColors().murasaki;
    }

    return color;
  }

  Future<void> initGame() async {
    setState(() {
      _romaji = widget.romaji;
      _gameOver = false;
      _score = 0;
      indexColor = 1;
      _items = List<YomuKanji>.from(widget.data);
      _items2 = List<YomuKanji>.from(_items);
      _items.shuffle();
      _items2.shuffle();
      _perfect = true;
    });
  }

  @override
  void initState() {
    super.initState();

    initGame();
    _unit = widget.unit;
    _level = widget.level;
    _translation = widget.translation;
    _best = widget.bestScore;
    if(_items.length != 0)
      _addMatch = (100 / _items.length).truncate();
    else
      _addMatch = 0;
    _subNotMatch = (_addMatch/2).truncate();
  }

  Widget buildListDraggable(double height, double width, double textSize) {
    List<Widget> col1 = [];
    List<Widget> col2 = [];
    var map = _items.map((item) {
      int index = _items.indexOf(item);
      Color color = pickColor(index);
        return Draggable<YomuKanji>(
          data: item,
          childWhenDragging: Container(height: height, width: width),
          feedback: DraggableTextWidget(widgetText: item.kanji,
            color: color, height: height, width: width, textSize:  textSize,),
          child: DraggableTextWidget(widgetText: item.kanji,
            color: color, height: height, width: width, textSize: textSize,),
        );
      }).toList();

      if (_mediaQueryData.orientation == Orientation.landscape){
        for (int i = 0; i < map.length; i++) {
          if (i.isEven)
            col1.add(map[i]);
          else
            col2.add(map[i]);
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: col1,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: col2,
            )
          ],
        );
    }else{
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: map,
        );
      }
  }

  Widget buildListDragTarget(double height, double width, double textSize) {
    List<Widget> col1 = [];
    List<Widget> col2 = [];
    var map = _items2.map((item){
      int index = _items2.indexOf(item) + 1;
      Color color = pickColor(index);
      var typeBuilder;
      if(_translation)
       typeBuilder = item.translation;
      else
        if(_romaji)
          typeBuilder = item.romaji;
        else
          typeBuilder= item.reading;

      return DragTarget<YomuKanji>(
        onAccept: (receivedItem){

            if(item.kanji == receivedItem.kanji){
              setState(() {
                _items.remove(receivedItem);
                _items2.remove(item);
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
        builder: (context, acceptedItems,rejectedItem) => DraggableTextWidget(
          widgetText: typeBuilder, color: color, height: height, width: width,
          textSize: textSize),
        );
      }).toList();

    if (_mediaQueryData.orientation == Orientation.landscape){
      for (int i = 0; i < map.length; i++) {
        if (i.isEven)
          col2.add(map[i]);
        else
          col1.add(map[i]);
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: col1,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: col2,
          )
        ],
      );
    }else{
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: map,
      );
    }
  }

  void updateBestScore(int score, int bestScore, int unit, int level,
      bool translation){

    if(score > bestScore){
      KanjiRepository.updateYomuLevelBestScore(score, unit, level, translation);
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
    _translation = widget.translation;
    _romaji = widget.romaji;
    double containerWidth;
    double itemHeight;
    double itemWidth;
    double multiplier;

    AssetImage image = AssetImage("assets/images/yomu_background.png");

    if(_mediaQueryData.orientation == Orientation.landscape){
      containerWidth = _mediaQueryData.size.width/2.25;
      itemHeight = screenHeight/6;
      itemWidth = _mediaQueryData.size.width/5;
      multiplier= 7.5;

    }else {
      containerWidth = _mediaQueryData.size.width/2.5;
      itemHeight = screenHeight/11;
      itemWidth = _mediaQueryData.size.width/3.25;
      multiplier = 3.75;
    }

    if(_items.length == 0) {
      updateBestScore(_score, _best, _unit, _level, _translation);
      _gameOver = true;

      //aggiorno la foto di sfondo con un plain backgroud;
      //image = AssetImage("");
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
        height: _mediaQueryData.size.height,
        width: _mediaQueryData.size.width,
        decoration:  BoxDecoration(
          image: DecorationImage(
          image: image,
          fit: BoxFit.fill
           ),
        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if(!_gameOver)
                Row(
                  children: <Widget>[
                    Spacer(),
                    Container(
                      height: screenHeight,
                      width: containerWidth,
                      child: buildListDraggable(itemHeight, itemWidth,
                      unitHeightValue * multiplier),
                    ),
                    Spacer(),
                    Spacer(),
                    Container(
                      height: screenHeight,
                      width: containerWidth,
                      child: buildListDragTarget(itemHeight, itemWidth,
                          unitHeightValue * multiplier),
                      ),
                    Spacer(),
                  ],
                ),

              if(_gameOver)
                AllConfettiWidget(
                  child: EndGameWidget(score: _score, best: _best, textSize: unitHeightValue *
                    multiplier, repeatLevel: initGame,),
                )

            ],
          ),

        ),
    );
  }
}
