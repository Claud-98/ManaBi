import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:manabi/utils/custom_colors.dart';
import 'package:manabi/models/yomu_kanji.dart';
import 'package:manabi/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manabi/widgets/all_confetti_widget.dart';
import 'package:manabi/widgets/draggable_text_widget.dart';
import 'package:manabi/widgets/end_game_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class YomuGame extends StatelessWidget {
  final bool translation;
  final colors = CustomColors.initColorsYomu(15);

  YomuGame({Key key, this.translation}) : super(key: key);

  Widget buildListDraggable(double height, double width, double textSize,
      BuildContext context, MediaQueryData mediaQueryData) {
    List<Widget> col1 = [];
    List<Widget> col2 = [];
    var map = context.read(matchProvider).dragItems.map((item) {
      int index = context.read(matchProvider).dragItems.indexOf(item);
      Color color = colors[index];
      return Draggable<YomuKanji>(
        data: item,
        childWhenDragging: Container(height: height, width: width),
        feedback: DraggableTextWidget(
          widgetText: item.kanji,
          color: color,
          height: height,
          width: width,
          textSize: textSize,
        ),
        child: DraggableTextWidget(
          widgetText: item.kanji,
          color: color,
          height: height,
          width: width,
          textSize: textSize,
        ),
      );
    }).toList();

    if (mediaQueryData.orientation == Orientation.landscape) {
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
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: map,
      );
    }
  }

  Widget buildListDragTarget(double height, double width, double textSize,
      BuildContext context, MediaQueryData mediaQueryData) {
    List<Widget> col1 = [];
    List<Widget> col2 = [];
    var map = context.read(matchProvider).dragTargetItems.map((item) {
      int index = context.read(matchProvider).dragTargetItems.indexOf(item) + 1;
      Color color = colors[index];
      var typeBuilder;
      if (context.read(levelInfoProvider).translate)
        typeBuilder = item.translation;
      else if (context.read(levelInfoProvider).romaji)
        typeBuilder = item.romaji;
      else
        typeBuilder = item.reading;

      return DragTarget<YomuKanji>(
        onAccept: (receivedItem) {
          if (item.kanji == receivedItem.kanji) {
            context.read(scoreProvider).incrementScore();
            context.read(matchProvider).matchesForYomuGame(receivedItem);
          } else {
            context.read(scoreProvider).decrementScore();
          }
        },
        builder: (context, acceptedItems, rejectedItem) => DraggableTextWidget(
            widgetText: typeBuilder,
            color: color,
            height: height,
            width: width,
            textSize: textSize),
      );
    }).toList();

    if (mediaQueryData.orientation == Orientation.landscape) {
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
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: map,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final unitHeightValue = mediaQueryData.size.height * 0.01;
    double appBarSize = AppBar().preferredSize.height;
    final double screenHeight =
        mediaQueryData.size.height - appBarSize - mediaQueryData.padding.top;
    final translatedStrings = AppLocalizations.of(context);
    AssetImage image = AssetImage("assets/images/yomu_background.png");
    double containerWidth;
    double itemHeight;
    double itemWidth;
    double multiplier;

    if (mediaQueryData.orientation == Orientation.landscape) {
      containerWidth = mediaQueryData.size.width / 2.25;
      itemHeight = screenHeight / 6;
      itemWidth = mediaQueryData.size.width / 5;
      multiplier = 7.5;
    } else {
      containerWidth = mediaQueryData.size.width / 2.5;
      itemHeight = screenHeight / 11;
      itemWidth = mediaQueryData.size.width / 3.25;
      multiplier = 3.75;
    }

    return Scaffold(
      backgroundColor: CustomColors.nezumihiro,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarSize),
        child: Consumer(builder: (context, watch, child) {
          String score = watch(scoreProvider).score.toString();
          String bestScore = watch(levelInfoProvider).bestScore.toString();
          return Visibility(
            visible: watch(gameOverProvider).appBarVisibility,
            child: AppBar(
                centerTitle: true,
                title: AutoSizeText(
                    translatedStrings.inGameAppBarText(score, bestScore))),
          );
        }),
      ),
      body: Container(
        height: mediaQueryData.size.height,
        width: mediaQueryData.size.width,
        decoration: BoxDecoration(
          image: DecorationImage(image: image, fit: BoxFit.fill),
        ),
        child: Consumer(builder: (context, watch, child) {
          watch(matchProvider);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (!watch(gameOverProvider).gameOver)
                Row(
                  children: <Widget>[
                    Spacer(),
                    Container(
                      height: screenHeight,
                      width: containerWidth,
                      child: buildListDraggable(
                          itemHeight,
                          itemWidth,
                          unitHeightValue * multiplier,
                          context,
                          mediaQueryData),
                    ),
                    Spacer(),
                    Spacer(),
                    Container(
                      height: screenHeight,
                      width: containerWidth,
                      child: buildListDragTarget(
                          itemHeight,
                          itemWidth,
                          unitHeightValue * multiplier,
                          context,
                          mediaQueryData),
                    ),
                    Spacer(),
                  ],
                ),
              if (watch(gameOverProvider).gameOver)
                AllConfettiWidget(
                  child: Center(
                    child: EndGameWidget(
                        score: watch(scoreProvider).score,
                        best: watch(levelInfoProvider).bestScore,
                        textSize: unitHeightValue * multiplier,
                        repeatLevel: null),
                  ),
                )
            ],
          );
        }),
      ),
    );
  }
}
