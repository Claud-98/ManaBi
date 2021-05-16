import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manabi/utils/custom_colors.dart';

class KanjiDetailsWidget extends StatelessWidget {
  final double itemHeight;
  final double itemWidth;
  final double textSize;
  final String text1;
  final String text2;
  final Color color;

  const KanjiDetailsWidget({Key key, this.itemHeight, this.itemWidth,
    this.textSize, this.text1, this.text2, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: Container(
        height: itemHeight,
        width: itemWidth,
        child: Column(
          children: [
            Container(
              color: CustomColors.blackGround,
              height: itemHeight/5,
              width: itemWidth,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: AutoSizeText(
                  text1,
                maxLines: 1,
                  minFontSize: 1,
                  style: TextStyle(
                    fontSize: textSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),),
              ),
            ),
            Container(
              color: color,
              height: itemHeight - itemHeight/5,
              width: itemWidth,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: AutoSizeText(
                    text2,
                    maxLines: 3,
                    minFontSize: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: textSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
