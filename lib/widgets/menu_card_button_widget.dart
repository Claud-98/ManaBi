import 'package:flutter/material.dart';
import 'package:manabi/screens/kaku__matching_game_screen.dart';
import 'package:manabi/utils/strings.dart' as strings;

typedef void IntCallback(int id, int level);

class MenuCardButtonWidget extends StatelessWidget {
  final IntCallback onSonChanged;
  final Color color;
  final int unitNumber;
  final int levelNumber;
  final String type;
  final double textSize;

  const MenuCardButtonWidget(
      {Key key,
      this.color,
      this.unitNumber,
      this.levelNumber,
      this.type,
      this.textSize,
      this.onSonChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextButton(
            onPressed: () {
              if (type == strings.yomu) {
                onSonChanged(unitNumber, levelNumber);
              } else if (type == strings.kaku) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => KakuMatchingGameScreen(
                          unit: unitNumber,
                          level: levelNumber,
                        )));
              }
            },
            style: TextButton.styleFrom(
              elevation: 3,
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
            )));
  }
}
