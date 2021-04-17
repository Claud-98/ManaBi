import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:manabi/screens/yomu_matching_game_screen.dart';

class PopUpMenuCard extends StatelessWidget {
  final VoidCallback backButtonReset;
  final Color color;
  final int unitNumber;
  final int levelSelected;
  final String type;
  final double height;
  final double width;
  final double textSize;



  const PopUpMenuCard({Key key, this.color, this.unitNumber, this.levelSelected,
    this.type, this.height, this.width, this.backButtonReset, this.textSize})
      : super(key: key);

  TextStyle textStyle(){
    return TextStyle(
      color: Colors.white,
      fontSize: textSize,
    );
  }

  @override
  Widget build(BuildContext context) {



    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Spacer(),
        Flexible(
          child: ButtonTheme(
            height: height/4,
            child: MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        YomuMatchingGameScreen(unit: unitNumber,
                          level: levelSelected,
                          translation: false)));
              },
              child: AutoSizeText("PRONUNCIA",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: textStyle()),
              color: color,
            ),
          ),
        ),
        Spacer(),
        Flexible(
          child: ButtonTheme(
            height: height/4,
            child: MaterialButton(
              onPressed: () {
                if (type == "yomu") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          YomuMatchingGameScreen(unit: unitNumber,
                            level: levelSelected,
                            translation: true,)));
                }
              },
              child: AutoSizeText("TRADUZIONE",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: textStyle()),
              color: color,
            ),
          ),
        ),
        Spacer(),
        Flexible(
          child: ButtonTheme(
            height: height/4,
            child: MaterialButton(
              onPressed: backButtonReset,
              child: AutoSizeText("BACK",
                textAlign: TextAlign.center,
                maxLines: 1,
                style: textStyle(),),
              color: color,
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
