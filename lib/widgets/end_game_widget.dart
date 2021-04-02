import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manabi/custom_colors.dart';

class EndGameWidget extends StatelessWidget {

  final int score;
  final int best;
  final double textSize;
  final VoidCallback repeatLevel;

  const EndGameWidget({Key key, this.score, this.best, this.textSize, this.repeatLevel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      rowOneHeight = screenHeight/15;
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


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: rowOneHeight,
          width: screenWidth,
          color: CustomColors().blackGround,
        ),
        Material(
          elevation:16,
          child: Container(
            height: rowTwoHeight,
            width: screenWidth,
            color: CustomColors().reddo,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Spacer(),
                AutoSizeText("BEST: $best",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: textSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                AutoSizeText("SCORE: $score",
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
        ),
        Material(
          elevation: 8,
          child: Container(
            height: rowThreeHeight,
            width: screenWidth,
            color: CustomColors().blackGround,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Spacer(),
                MaterialButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: iconSize,
                    color: Colors.white,
                  ),
                  shape: CircleBorder(),
                  color: CustomColors().murasaki,
                  padding: EdgeInsets.all(padding),
                ),
                Spacer(),
                MaterialButton(
                  onPressed: repeatLevel,
                  child: Icon(
                    Icons.refresh,
                    size: iconSize,
                    color: Colors.white,
                  ),
                  shape: CircleBorder(),
                  color: CustomColors().orenji,
                  padding: EdgeInsets.all(padding),
                ),
                Spacer(),
                MaterialButton(
                  onPressed: (){
                    Navigator.pushNamed(context, "/");
                  },
                  child: Icon(
                    Icons.home,
                    size: iconSize,
                    color: Colors.white,
                  ),
                  shape: CircleBorder(),
                  color: CustomColors().chokoMinto,
                  padding: EdgeInsets.all(padding),
                ),
                Spacer(),
                Spacer(),
              ],
            ),
          ),
        )
      ],
    );
  }
}