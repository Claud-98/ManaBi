import 'package:flutter/material.dart';

class MenuCardLevelTextLabel extends StatelessWidget {
  final Color color;
  final double padding;
  final double textSize;
  final unitNumber;

  const MenuCardLevelTextLabel({Key key, this.color, this.padding, this.textSize,
    this.unitNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
          color: color,
          child: Row(
            children: [
              Container(
                width: padding/2,
              ),

              Center(
                child:
                RotatedBox(
                    quarterTurns: 3,
                    child:
                    Text("UNITA' " + unitNumber.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: textSize,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                ),
              ),
              Container(
                width: padding/2,
              )
            ],
          )
      ),
    );
  }
}
