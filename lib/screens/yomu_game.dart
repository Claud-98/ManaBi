import 'package:flutter/material.dart';
import 'package:manabi/models/yomu_kanji.dart';
import 'package:manabi/widgets/draggable_text_widget.dart';

import '../custom_colors.dart';

class YomuGame extends StatefulWidget {
  final List<YomuKanji> data;

  const YomuGame({Key key, @required this.data}) : super(key: key);
  @override
  _YomuGameState createState() => _YomuGameState();
}

class _YomuGameState extends State<YomuGame> {
  List<YomuKanji> items;
  List<YomuKanji> items2;
  int indexColor;
  double score;
  int best;
  bool gameOver;
  double addMatch;
  double subNotMatch;



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

  @override
  void initState() {
    super.initState();
    gameOver = false;
    score=0.0;
    best = 0;
    indexColor = 1;
    items = List<YomuKanji>.from(widget.data);
    items2 = List<YomuKanji>.from(items);
    items.shuffle();
    items2.shuffle();
    addMatch = (100/items.length).roundToDouble();
    subNotMatch = addMatch/2;

  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar();
    final double gridItemHeight = mediaQueryData.size.height -
        appBar.preferredSize.height - mediaQueryData.padding.top;
    double gridItemWidth = mediaQueryData.size.width/2.25;
    int crossAxisCount;
    double gridAspectRatio;


    if(mediaQueryData.orientation == Orientation.landscape){
      crossAxisCount = 2;
      gridAspectRatio =1.9;
      gridItemWidth = mediaQueryData.size.width/2.25;
    }else {
      crossAxisCount = 1;
      gridAspectRatio = 2;
      gridItemWidth = mediaQueryData.size.width/2.5;
    }

    if(items.length == 0)
      gameOver = true;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Score: ' + "$score" +  ' Best: ' + "$best",
          textAlign: TextAlign.right,),
      ),
      body: Container(
        height: mediaQueryData.size.height,
        width: mediaQueryData.size.width,
        decoration:  BoxDecoration(
          image: DecorationImage(
          image: AssetImage("assets/images/yomu_background.png"),
          fit: BoxFit.fill
           ),
        ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if(!gameOver)

                Row(

                  children: <Widget>[
                    Spacer(),

                    Container(
                      height: gridItemHeight,
                      width: gridItemWidth,

                      child: GridView.count(
                        crossAxisCount: crossAxisCount,
                          childAspectRatio: gridAspectRatio,
                          children: items.map((item) {
                            int index = items.indexOf(item);
                            //posso sostituirlo con un array di colori
                            Color color = pickColor(index);
                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              child: Draggable<YomuKanji>(
                                data: item,
                                childWhenDragging: Container(height: 50, width: 125,),
                                feedback: DraggableTextWidget(widgetText: item.kanji,
                                    color: color,),
                                child: DraggableTextWidget(widgetText: item.kanji,
                                    color: color,),
                              ),
                            );
                          }).toList()
                      ),
                    ),

                    Spacer(),

                    Spacer(),

                    Container(
                      height: gridItemHeight,
                      width: gridItemWidth,
                      child: GridView.count(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: gridAspectRatio,

                          children: items2.map((item){
                            int index = items2.indexOf(item) + 1;
                            Color color = pickColor(index);

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

                              builder: (context, acceptedItems,rejectedItem) => Container(
                                margin: const EdgeInsets.all(8),
                                child: DraggableTextWidget(widgetText: item.romaji,
                                    color: color,
                                ),
                              ),
                            );
                          }).toList()
                      ),
                    ),

                    Spacer(),

                  ],
                ),

              if(gameOver)
                Text("GameOver",
                  style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  ),
                ),
            ],
          ),

        ),
    );
  }
}
