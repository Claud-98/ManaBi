import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manabi/models/yomu_kanji.dart';
import 'package:manabi/widgets/draggable_text_widget.dart';
import 'package:manabi/widgets/end_game_widget.dart';

import '../custom_colors.dart';

class YomuGame extends StatefulWidget {
  final List<YomuKanji> data;
  final bool romaji;
  final bool translation;

  const YomuGame({Key key, @required this.data, this.romaji, this.translation}) : super(key: key);
  @override
  _YomuGameState createState() => _YomuGameState();
}

class _YomuGameState extends State<YomuGame> {
  MediaQueryData mediaQueryData;
  List<YomuKanji> items;
  List<YomuKanji> items2;
  int indexColor;
  double score;
  double best;
  bool gameOver;
  double addMatch;
  double subNotMatch;
  bool translation;
  bool romaji;





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

  void initGame(){
    setState(() {
      romaji = widget.romaji;
      translation = widget.translation;
      gameOver = false;
      score=0.0;
      best = 0;
      indexColor = 1;
      items = List<YomuKanji>.from(widget.data);
      items2 = List<YomuKanji>.from(items);
      items.shuffle();
      items2.shuffle();
    });

  }

  @override
  void initState() {
    super.initState();

    initGame();
    addMatch = ((1 / items.length) * 100);
    subNotMatch = addMatch/2;
  }

  Widget buildListDraggable(double height, double width, double textSize) {
    List<Widget> col1 = [];
    List<Widget> col2 = [];
    var map = items.map((item) {
      int index = items.indexOf(item);
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

      if (mediaQueryData.orientation == Orientation.landscape){
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: col1,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: col2,
            )
          ],
        );
    }else{
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map,
        );
      }
  }

  Widget buildListDragTarget(double height, double width, double textSize) {
    List<Widget> col1 = [];
    List<Widget> col2 = [];
    var map = items2.map((item){
      int index = items2.indexOf(item) + 1;
      Color color = pickColor(index);
      var typeBuilder;
      if(translation)
       typeBuilder = item.translation;
      else
        if(romaji)
          typeBuilder = item.romaji;
        else
          typeBuilder= item.reading;

      return DragTarget<YomuKanji>(
        onAccept: (receivedItem){
            if(item.kanji == receivedItem.kanji){
              setState(() {
                items.remove(receivedItem);
                items2.remove(item);
                score+=addMatch;
              });
            }else{
              setState(() {
                score-=subNotMatch;
              });
            }
          },
        builder: (context, acceptedItems,rejectedItem) => DraggableTextWidget(
          widgetText: typeBuilder, color: color, height: height, width: width,
          textSize: textSize),
        );
      }).toList();

    if (mediaQueryData.orientation == Orientation.landscape){
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: col1,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: col2,
          )
        ],
      );
    }else{
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: map,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    final unitHeightValue = mediaQueryData.size.height * 0.01;
    final PreferredSizeWidget appBar = AppBar();
    final double screenHeight = mediaQueryData.size.height -
        appBar.preferredSize.height - mediaQueryData.padding.top;
    translation = widget.translation;
    romaji = widget.romaji;
    double containerWidth;
    double itemHeight;
    double itemWidth;
    double multiplier;
    double appBarSize = appBar.preferredSize.height;
    AssetImage image = AssetImage("assets/images/yomu_background.png");




    if(mediaQueryData.orientation == Orientation.landscape){
      containerWidth = mediaQueryData.size.width/2.25;
      itemHeight = screenHeight/6;
      itemWidth = mediaQueryData.size.width/5;
      multiplier= 7.5;

    }else {
      containerWidth = mediaQueryData.size.width/2.5;
      itemHeight = screenHeight/12;
      itemWidth = mediaQueryData.size.width/3.5;
      multiplier = 3.75;
    }

    if(items.length == 0) {
      gameOver = true;
      //aggiorno il valore nel dn del best (ho bisogno del nLiv e nUnit)
      //aggiorno la foto di sfondo con un plain backgroud;
      image = AssetImage("");
      appBarSize = 0;
    }
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarSize),
        child: AppBar(
          centerTitle: true,
          title: Text('Score: ' + "$score" +  ' Best: ' + "$best",
            textAlign: TextAlign.right,),
        ),
      ),
      body: Container(
        height: mediaQueryData.size.height,
        width: mediaQueryData.size.width,
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
              if(!gameOver)
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

              if(gameOver)
                EndGameWidget(score: score, best: best, textSize: unitHeightValue *
                  multiplier, repeatLevel: initGame,)

            ],
          ),

        ),
    );
  }
}
