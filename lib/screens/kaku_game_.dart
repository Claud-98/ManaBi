import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:manabi/custom_colors.dart';
import 'package:manabi/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manabi/screens/kanji_details_screen.dart';
import 'package:manabi/widgets/all_confetti_widget.dart';
import 'package:manabi/widgets/draggable_text_widget.dart';
import 'package:manabi/widgets/end_game_widget.dart';
import 'package:manabi/widgets/kaku_kanji_box.dart';

class KakuGameStateless extends StatelessWidget {
  final colors = CustomColors.initColorsKaku(30);

  KakuGameStateless({Key key}) : super(key: key);

  Widget buildListDraggable(
      double height,
      double width,
      double textSize,
      double screenHeight,
      double screenWidth,
      BuildContext context,
      MediaQueryData mediaQueryData) {
    double gridWidth;
    int gridItem;
    var map = context.read(matchProvider).dragItems.map((item) {
      int index = context.read(matchProvider).dragItems.indexOf(item);
      Color color = colors[index];

      return Draggable<String>(
        data: item,
        childWhenDragging: Container(height: height, width: width),
        feedback: DraggableTextWidget(
          widgetText: item,
          color: color,
          height: height,
          width: width,
          textSize: textSize,
        ),
        child: DraggableTextWidget(
          widgetText: item,
          color: color,
          height: height,
          width: width,
          textSize: textSize,
        ),
      );
    }).toList();

    if (mediaQueryData.orientation == Orientation.landscape) {
      gridWidth = screenWidth / 1.2;
      gridItem = 5;
    } else {
      gridWidth = screenWidth / 1.1;
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

  Widget buildListDragTarget(
      double screenHeight,
      double screenWidth,
      double textSize,
      double itemHeight,
      double itemWidth,
      BuildContext context,
      MediaQueryData mediaQueryData) {
    List<Widget> col1 = [];
    List<Widget> col2 = [];
    double screenHeightOrWidth;

    if (mediaQueryData.orientation == Orientation.landscape) {
      screenHeightOrWidth = screenWidth / 1.2;
    } else {
      screenHeightOrWidth = screenHeight;
    }

    var map = context.read(matchProvider).dragTargetItems.map((item) {
      int index = context.read(matchProvider).dragTargetItems.indexOf(item);
      Color color = colors[index];
      List<String> kanjiItemsPathOn;
      List<String> kanjiItemsPathKun;

      if (!context.read(levelInfoProvider).romaji) {
        kanjiItemsPathOn = item.kanji.onyomi.katakana.split('、');
        kanjiItemsPathKun = item.kanji.kunyomi.hiragana.split('、');
      } else {
        kanjiItemsPathOn =
            item.kanji.onyomi.romaji.replaceAll(' ', '').split(',');
        kanjiItemsPathKun =
            item.kanji.kunyomi.romaji.replaceAll(' ', '').split(',');
      }

      return GestureDetector(
        onDoubleTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => KanjiDetailsScreen(
                  kanji: item,
                  romaji: context.read(levelInfoProvider).romaji)));
        },
        child: DragTarget<String>(
          onAccept: (receivedItem) {
            if (checkList(kanjiItemsPathOn, receivedItem) ||
                checkList(kanjiItemsPathKun, receivedItem)) {
              context.read(scoreProvider).incrementScore();
              context.read(matchProvider).matchesForKakuGame(receivedItem);
            } else {
              context.read(scoreProvider).decrementScore();
            }
          },
          builder: (context, acceptedItems, rejectedItem) => KakuKanjiBox(
              text: item.kanji.character,
              color: color,
              reverse: index % 2 != 0,
              screenHeightOrWidth: screenHeightOrWidth,
              textSize: textSize),
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
            child: buildListDraggable(itemHeight, itemWidth, textSize,
                screenHeight, screenWidth, context, mediaQueryData),
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

  bool checkList(List<String> list, String element) {
    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        if (element == list[i]) return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final unitHeightValue = mediaQueryData.size.height * 0.01;
    double appBarSize = AppBar().preferredSize.height;
    final double screenHeight =
        mediaQueryData.size.height - appBarSize - mediaQueryData.padding.top;
    final double screenWidth = mediaQueryData.size.width;
    double itemHeight;
    double itemWidth;
    double multiplier;

    if (mediaQueryData.orientation == Orientation.landscape) {
      itemHeight = screenHeight / 6.75;
      itemWidth = screenWidth / 6.5;
      multiplier = 7.5;
    } else {
      itemHeight = screenHeight / 11;
      itemWidth = screenWidth / 3.5;
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
                    'Score: ' + "$score" + ' Best: ' + "$bestScore")),
          );
        }),
      ),
      body: Consumer(builder: (context, watch, child) {
        watch(matchProvider);
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!watch(gameOverProvider).gameOver)
              Container(
                  height: screenHeight,
                  width: screenWidth,
                  child: buildListDragTarget(
                      screenHeight,
                      screenWidth,
                      unitHeightValue * multiplier,
                      itemHeight,
                      itemWidth,
                      context,
                      mediaQueryData)),
            if (watch(gameOverProvider).gameOver)
              AllConfettiWidget(
                child: EndGameWidget(
                  score: watch(scoreProvider).score,
                  best: watch(levelInfoProvider).bestScore,
                  textSize: unitHeightValue * multiplier,
                  repeatLevel: null,
                ),
              )
          ],
        );
      }),
    );
  }
}
