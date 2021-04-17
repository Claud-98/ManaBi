import 'package:flutter/material.dart';
import 'package:manabi/custom_colors.dart';
import 'package:manabi/models/kaku_kanji.dart';
import 'package:manabi/widgets/kanji_details_box.dart';
import 'package:manabi/widgets/video_player.dart';

class KanjiDetailsScreen extends StatelessWidget {
  final KakuKanji kanji;
  final bool romaji;

  const KanjiDetailsScreen({Key key, @required this.kanji,
    @required this.romaji}) : super(key: key);


  Widget buildKanjiDetailsWidgets(double itemHeight, double itemWidth,
      MediaQueryData mediaQueryData, double textSize){
    List<Widget> widgets = [];
    String kunYomi;
    String onYomi;

    if(romaji){
      kunYomi = kanji.kanji.kunyomi.romaji;
      onYomi = kanji.kanji.onyomi.romaji;
    }else{
      kunYomi = kanji.kanji.kunyomi.hiragana;
      onYomi = kanji.kanji.onyomi.katakana;
    }

    widgets.add(KanjiDetailsWidget(itemHeight: itemHeight, itemWidth: itemWidth,
    color: CustomColors.murasaki, text1: "KUN YOMI", text2: kunYomi,
      textSize: textSize,));
    widgets.add(KanjiDetailsWidget(itemHeight: itemHeight, itemWidth: itemWidth,
      color: CustomColors.orenji, text1: "ON YOMI", text2: onYomi,
      textSize: textSize,));
    widgets.add(KanjiDetailsWidget(itemHeight: itemHeight, itemWidth: itemWidth/2.25,
      color: CustomColors.chokoMinto, text1: "RADICAL",
      text2: kanji.radical.character, textSize: textSize * 1.5,));
    widgets.add(KanjiDetailsWidget(itemHeight: itemHeight, itemWidth: itemWidth/2.25,
      color: CustomColors.chokoMinto, text1: "STROKES",
      text2: kanji.kanji.strokes.count.toString(), textSize: textSize *1.5,));

    if(mediaQueryData.orientation == Orientation.landscape){
      return Flexible(
        child: Column(
          children: [
            Spacer(),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widgets
            ),
            Spacer()
          ],
        ),
      );
    }else {
      return Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            widgets[0],

            widgets[1],

            Container(
              width: itemWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widgets[2],
                  widgets[3],
                ],
              ),
            )
          ],
        ),
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final double appBarSize = AppBar().preferredSize.height;
    final unitHeightValue = mediaQueryData.size.height * 0.01;
    final double screenHeight = mediaQueryData.size.height -
        appBarSize - mediaQueryData.padding.top;
    final double screenWidth = mediaQueryData.size.width;
    double videoSize;
    double itemHeight;
    double itemWidth;
    double multiplier;

    if(mediaQueryData.orientation == Orientation.landscape){
      videoSize = screenWidth/3.75;
      itemHeight = screenHeight/3;
      itemWidth = screenWidth/3.25;
      multiplier= 5;

    }else {
      videoSize = screenHeight/3.5;
      itemHeight = screenHeight/6;
      itemWidth = screenWidth/1.5;
      multiplier = 3.5;
    }


    return Scaffold(
        appBar: AppBar(
          title: Text('Kanji Details'),
        ),
        body: Column(
          children: [
            Material(
              elevation: 4,
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: VideoPlayerWidget(videoUrl: kanji.kanji.video.mp4,
                          size: videoSize,)
                    ),
                  ],
                ),
              ),
            ),
            buildKanjiDetailsWidgets(itemHeight, itemWidth, mediaQueryData,
            unitHeightValue * multiplier)
          ],
        )
    );
  }
}
