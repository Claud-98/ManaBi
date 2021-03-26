import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';

/// GameLevelMenu - Menu con tutte le unità composte dai rispettivi livelli.
/// "type" specifica la categoria dei giochi del menu: kaku o yomu.

class GameLevelMenu extends StatelessWidget {
   //Numero dei livelli per ogni unità la lunghezza di numberOfLevels = numUnits.
   final List<int> numberOfLevels;
   //Numero Unità - coincide con il numero delle cards da creare.
   final int units ;
   final String type;

  GameLevelMenu({Key key, @required this.numberOfLevels,
   @required this.units, @required this.type})  : super(key: key);

  List<Widget> populateMenu(){
    List<Widget> menuCards = [];
    int color = 1;

    for(int i=0; i<units; i++){
      menuCards.add(
          MenuCard(numberOfLevels: numberOfLevels[i], indexColor: color,
            unitNumber: i+1, type: type)
      );

      if(color == 3)
        color = 1;
      else
        color++;
    }

    return menuCards;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type.toUpperCase() + " KANJI"),
        centerTitle: true,
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: populateMenu(),
        ),
      ),
    );
  }
}
