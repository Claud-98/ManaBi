import 'package:flutter/material.dart';
import 'package:manabi/custom_colors.dart';

class MenuCard extends StatefulWidget {
  final int numberOfLevels;
  final int indexColor;
  final int unitNumber;
  final  String type;


  MenuCard({Key key, @required this.numberOfLevels, @required this.indexColor,
    @required this.unitNumber, @required this.type}) : super(key: key);

  @override
  _MenuCardState createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {

  List<Widget> populateMenu(int numLevels, int unitNumber, Color color,
      MediaQueryData mediaQueryData, String type){
    List<Widget> menu = [];
    double padding;
    double buttonW;
    double buttonH;

    if(mediaQueryData.orientation == Orientation.landscape){
      buttonW = mediaQueryData.devicePixelRatio * 25;
      buttonH = mediaQueryData.devicePixelRatio * 55;
      padding= mediaQueryData.devicePixelRatio * 6;
    }else {
      buttonW = mediaQueryData.devicePixelRatio* 17.5;
      buttonH = mediaQueryData.devicePixelRatio* 35;
      padding= mediaQueryData.devicePixelRatio * 3;
    }

    for(int i=0; i < numLevels + 1; i++){
      if(i == 0){
        menu.add(
          Container(
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
                           fontSize: 26,
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
          )
        );
        menu.add(
            Container(
              width: padding,
            )
        );
      }else{
        menu.add(
            Container(
                width:buttonW,
                height: buttonH,
                margin: EdgeInsets.all(padding),
                child: TextButton(
                    onPressed: (){

                    },
                    style: TextButton.styleFrom(
                      backgroundColor: color,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    child: Text(
                      i.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )
                ))
        );
      }
    }
    return  menu;
  }


  @override
  Widget build(BuildContext context) {

    final mediaQueryData = MediaQuery.of(context);
    final int numberOfLevels = widget.numberOfLevels;
    final int unitNumber = widget.unitNumber;
    final int indexColor = widget.indexColor;
    final String type = widget.type;
    double cardSizeH;
    double cardSizeW;
    Color color;

    if(mediaQueryData.orientation == Orientation.landscape){
      cardSizeW = mediaQueryData.devicePixelRatio * 220;
      cardSizeH = mediaQueryData.devicePixelRatio * 90;
    }else {
      cardSizeW = mediaQueryData.devicePixelRatio*140;
      cardSizeH = 60* mediaQueryData.devicePixelRatio;
    }
    if(indexColor == 1)
      color = CustomColors().murasaki;
    if(indexColor == 2)
      color = CustomColors().orenji;
    if(indexColor == 3)
      color = CustomColors().chokoMinto;


    return Card(
      color: CustomColors().blackGround,
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: const  Radius.circular(20.0),
          bottomRight: const  Radius.circular(20.0),
        ),
      ),
      child: Container(
          width: cardSizeW,
          height: cardSizeH,
          child: Row(
            children: populateMenu(numberOfLevels, unitNumber, color,
                mediaQueryData, type),
          )
      ),

    );
  }
}
