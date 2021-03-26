import 'package:flutter/material.dart';
import 'package:manabi/custom_colors.dart';
import 'package:manabi/screens/matching_game.dart';
import 'package:manabi/widgets/menu_card_button_widget.dart';
import 'package:manabi/widgets/menu_card_level_text_label.dart';

/// MenuCard - Widget costituito da una card che rappresenta un'unità con i
/// rispettivi livelli del gioco di abbinamento. Type può essere o "yomu" o
/// "kaku" e determinerà il tipo di matching game da generare al click del
/// livello.

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
      MediaQueryData mediaQueryData, double screenH, double screenW, String type){
    final unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    List<Widget> menu = [];
    double padding;
    double buttonW;
    double buttonH;
    double multiplier;


    if(mediaQueryData.orientation == Orientation.landscape){
      buttonW = screenW/10;
      buttonH = screenH/2.5;
      padding= screenW/50;
      multiplier = 7.5;

    }else {
      buttonW = screenW/10;
      buttonH = screenH/7.5;
      padding= screenW/50;
      multiplier = 3.75;
    }

    for(int i=0; i < numLevels + 1; i++){
      if(i == 0){
        menu.add(
          MenuCardLevelTextLabel(color: color, padding: padding, textSize:
            unitHeightValue * multiplier, unitNumber: unitNumber)
        );
      }else{
        menu.add(
            MenuCardButtonWidget(buttonW: buttonW, buttonH: buttonH, color: color,
            unitNumber: unitNumber, levelNumber: i , textSize: unitHeightValue *
              multiplier, type: "yomu",)
        );
      }
      menu.add(Spacer());
    }

    return  menu;
  }


  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar();
    final double screenHeight = mediaQueryData.size.height -
        appBar.preferredSize.height - mediaQueryData.padding.top;
    final double screenWidth = mediaQueryData.size.width;
    final int numberOfLevels = widget.numberOfLevels;
    final int unitNumber = widget.unitNumber;
    final int indexColor = widget.indexColor;
    final String type = widget.type;
    double cardSizeH;
    double cardSizeW;
    Color color;

    if(mediaQueryData.orientation == Orientation.landscape){
      cardSizeW =screenWidth/1.2;
      cardSizeH = screenHeight/1.5;
    }else {
      cardSizeW =screenWidth/1.15;
      cardSizeH = screenHeight/4;
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
                mediaQueryData, screenHeight, screenWidth, type),
          )
      ),

    );
  }
}
