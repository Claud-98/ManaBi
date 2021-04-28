import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manabi/custom_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manabi/providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EndGameWidget extends StatelessWidget {

  final int score;
  final int best;
  final double textSize;
  final VoidCallback repeatLevel;

  const EndGameWidget({Key key, this.score, this.best, this.textSize, this.repeatLevel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translatedStrings = AppLocalizations.of(context);
    final mediaQueryData = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar();
    final double screenHeight = mediaQueryData.size.height -
        appBar.preferredSize.height - mediaQueryData.padding.top;
    final double screenWidth = mediaQueryData.size.width;
    double rowOneHeight;
    double rowTwoHeight;
    double rowThreeHeight;
    double iconSize;
    double padding;

    if(mediaQueryData.orientation == Orientation.landscape){
      rowOneHeight = screenHeight/12;
      rowTwoHeight = screenHeight/3.5;
      rowThreeHeight = screenHeight/2.5;
      iconSize = screenWidth/20;
      iconSize = screenWidth/17.5;
      padding = screenWidth/40;
    }else{
      rowOneHeight = screenHeight/15;
      rowTwoHeight = screenHeight/9;
      rowThreeHeight = screenHeight/6.5;
      iconSize = screenHeight/20;
      iconSize = screenHeight/20;
      padding = screenHeight/40;
    }



    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0))),
      color: CustomColors.blackGround.withAlpha(450),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: rowOneHeight,
            width: screenWidth,
          ),
          Container(
            height: rowTwoHeight,
            width: screenWidth,
            color: CustomColors.reddo.withAlpha(500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Spacer(),
                AutoSizeText(translatedStrings.bestScore(best.toString()),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: textSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                AutoSizeText(translatedStrings.score(score.toString()),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: textSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
              ],
            )
          ),
          Container(
            height: rowThreeHeight,
            width: screenWidth,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Spacer(),
                MaterialButton(
                  onPressed: (){
                    context.read(updateAverageProvider).forceRefreshGraphics(context);
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: iconSize,
                    color: Colors.white,
                  ),
                  shape: CircleBorder(),
                  color: CustomColors.murasaki,
                  padding: EdgeInsets.all(padding),
                ),
                Spacer(),
                MaterialButton(
                  onPressed: () {
                    context.read(scoreProvider).resetScore();
                    context.read(levelInfoProvider).setBestScore(best);
                    context.read(updateAverageProvider).forceRefreshGraphics(context);
                    context.refresh(gameOverProvider);
                    },
                  child: Icon(
                    Icons.refresh,
                    size: iconSize,
                    color: Colors.white,
                  ),
                  shape: CircleBorder(),
                  color: CustomColors.orenji,
                  padding: EdgeInsets.all(padding),
                ),
                Spacer(),
                MaterialButton(
                  onPressed: (){
                    context.read(updateAverageProvider).forceRefreshGraphics(context);
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  },
                  child: Icon(
                    Icons.home,
                    size: iconSize,
                    color: Colors.white,
                  ),
                  shape: CircleBorder(),
                  color: CustomColors.chokoMinto,
                  padding: EdgeInsets.all(padding),
                ),
                Spacer(),
                Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }
}