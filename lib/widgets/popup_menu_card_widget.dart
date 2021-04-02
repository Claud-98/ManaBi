import 'package:flutter/material.dart';
import 'package:manabi/screens/matching_game.dart';

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
        Spacer(),
        ButtonTheme(
          height: height/5,
          child: MaterialButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      MatchingGame(unit: unitNumber,
                        levelNumber: levelSelected, type: type,
                        translation: false,)));
            },
            child: Text("PRONUNCIA",
            style: textStyle()),
            color: color,
          ),
        ),
        Spacer(),
        ButtonTheme(
          height: height/5,
          child: MaterialButton(
            onPressed: () {
              if (type == "yomu") {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        MatchingGame(unit: unitNumber,
                          levelNumber: levelSelected, type: type,
                          translation: true,)));
              }
            },
            child: Text("TRADUZIONE",
            style: textStyle()),
            color: color,
          ),
        ),
        Spacer(),
        ButtonTheme(
          height: height/5,
          child: MaterialButton(
            onPressed: backButtonReset,
            child: Text("BACK",
            style: textStyle(),),
            color: color,
          ),
        ),
        Spacer(),
        Spacer(),
      ],
    );
  }
}
