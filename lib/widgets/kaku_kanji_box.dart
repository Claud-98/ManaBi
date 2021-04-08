import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:manabi/custom_colors.dart';

class KakuKanjiBox extends StatelessWidget {
  final String text;
  final double screenHeightOrWidth;
  final double textSize;
  final Color color;
  final bool reverse;

  const KakuKanjiBox({Key key, this.text, this.screenHeightOrWidth,
    this.textSize, this.color, this.reverse, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(reverse)
          Container(
            color: color,
            height: screenHeightOrWidth/75,
            width: screenHeightOrWidth/8,
          ),
        Container(
          color: CustomColors().blackGround,
          height: screenHeightOrWidth/8 - screenHeightOrWidth/75,
          width: screenHeightOrWidth/8,
          child: Center(
            child: AutoSizeText(text,
              style: TextStyle(
                fontSize: textSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              minFontSize: 1,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ),
        if(!reverse)
        Container(
          color: color,
          height: screenHeightOrWidth/75,
          width: screenHeightOrWidth/8,
        )
      ],

    );
  }
}
