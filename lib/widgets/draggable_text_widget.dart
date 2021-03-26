import 'package:flutter/material.dart';

class DraggableTextWidget extends StatelessWidget {
  final String widgetText;
  final Color color;

  DraggableTextWidget({Key key, @required this.widgetText, this.color,})  : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Container(
        height: 50,
          width: 125,
          child: Center(
              child: Text(widgetText,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                ),
              )
          )
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        )
    );
  }
}
