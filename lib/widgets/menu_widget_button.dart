import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuWidgetButton extends StatelessWidget {
  final String buttonText;
  final double boxSize;
  final double spacer;
  final double length;

  MenuWidgetButton({Key key, @required this.buttonText, @required this.boxSize,
    @required this.spacer, @required this.length,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
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
              print("tapped")
            },
            child :Row(
              children: [
                Container(
                  color: Colors.amber,
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
                      fontSize: 20,
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
