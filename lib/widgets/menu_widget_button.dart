import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manabi/custom_colors.dart';

/// MenuWidgetButton - Custom button widget della Home Screen

class MenuWidgetButton extends StatelessWidget {
  final String buttonText;
  final double boxSize;
  final double spacer;
  final double length;
  final double fontSize;
  final String route;
  final Color color;

  MenuWidgetButton({Key key, @required this.buttonText, @required this.boxSize,
    @required this.spacer, @required this.length, @required this.fontSize,
    @required this.route, this.color, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: CustomColors.blackGround,
      margin: const EdgeInsets.only(bottom: 15, top: 5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: const  Radius.circular(20.0),
            bottomRight: const  Radius.circular(20.0),
          )
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () =>{
              Navigator.pushNamed(context, route),
            },
            child :Row(
              children: [
                Container(
                  color: color,
                  height:boxSize,
                  width: boxSize,
                ),
                Container(
                  width: spacer,
                ),
                Container(
                  width: length,
                  child: Text(buttonText,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
