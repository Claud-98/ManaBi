import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:manabi/custom_colors.dart';
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

  Widget populateCard(int numLevels, int unitNumber, Color color, String type,
      double cardH, double cardW, double textSize, double padding){
    List<Widget> menu = [];

    for(int i=1; i < numLevels + 1; i++){
        menu.add(
            Padding(
              padding: EdgeInsets.all(padding),
              child: MenuCardButtonWidget( color: color,
                unitNumber: unitNumber, levelNumber: i , textSize: textSize,
                type: type,),
            )
        );
    }

    return  Row(
      children: [
        MenuCardLevelTextLabel(color: color, padding: padding, textSize:
        textSize, unitNumber: unitNumber),
        Spacer(),
        Container(
          height: cardH/1.5,
          width: cardW/1.35,
          child: GridView.count(
            childAspectRatio: 2,
            scrollDirection: Axis.horizontal,
            crossAxisCount: 1,
            children: menu,
          ),
        ),
        Spacer(),
      ],
    );
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
    final unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double cardSizeH;
    double cardSizeW;
    Color color;
    double padding;
    double multiplier;

    if(mediaQueryData.orientation == Orientation.landscape){
      cardSizeW =screenWidth/1.2;
      cardSizeH = screenHeight/1.5;
      padding= screenWidth/50;
      multiplier = 7.5;

    }else {
      cardSizeW =screenWidth/1.15;
      cardSizeH = screenHeight/4;
      padding= screenWidth/50;
      multiplier = 3.75;
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
          child: populateCard(numberOfLevels, unitNumber, color,
                  type, cardSizeH, cardSizeW, multiplier * unitHeightValue,
          padding),

      ),

    );
  }
}
