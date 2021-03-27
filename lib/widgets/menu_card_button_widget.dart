import 'package:flutter/material.dart';
import 'package:manabi/screens/matching_game.dart';

class MenuCardButtonWidget extends StatelessWidget {
  final Color color;
  final int unitNumber;
  final int levelNumber;
  final String type;
  final double textSize;

  const MenuCardButtonWidget({Key key, this.color, this.unitNumber,
    this.levelNumber, this.type, this.textSize}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextButton(
            onPressed: (){
              if (type == "yomu"){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        MatchingGame(unit: unitNumber,
                          levelNumber: levelNumber, type: type,)));
              }

            },
            style: TextButton.styleFrom(
              backgroundColor: color,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: textSize,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            child: Text(
              levelNumber.toString(),
              textAlign: TextAlign.center,
              textScaleFactor: 1.0,
              style: TextStyle(
                color: Colors.white,
                fontSize: textSize,
              ),
            )
        ));
  }
}
