import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DraggableTextWidget extends StatelessWidget {
  final String widgetText;
  final Color color;
  final double height;
  final double width;
  final double textSize;


  DraggableTextWidget({Key key, @required this.widgetText, this.color,
    this.height, this.width, this.textSize,})  : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: color,
          child: Container(
            height: height,
              width: width,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(height * 0.15),
                  child: AutoSizeText(widgetText,
                  style: TextStyle(
                    fontSize: textSize,
                    color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              )
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            )
        ),
        Container(
          height: height/4,
        )
      ],
    );
  }
}
