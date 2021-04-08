import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manabi/widgets/menu_widget_button.dart';
import '../custom_colors.dart';

/// HomeScreen - Menu principale dell'applicazione da cui è possibile navigare
/// ai menu dei giochi di abbinamento e le impostazioni dell'applicazione.

class HomeScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    double unitHeightValue = mediaQueryData.size.height * 0.01;
    double boxSize;
    double spacer;
    double fontSize;
    AssetImage background;
    Alignment alignBackImage;
    double alignX;
    double alignY;

    if(mediaQueryData.orientation == Orientation.landscape){
      background = AssetImage("assets/images/Home_Background_R.png");
      boxSize = mediaQueryData.devicePixelRatio * 15 * 1.2;
      spacer = mediaQueryData.devicePixelRatio * 10 * 1.1;
      fontSize = unitHeightValue * 6;
      alignBackImage = Alignment.bottomRight;
      alignX= -0.50;
      alignY = -0.50;
    }else {
      background = AssetImage("assets/images/Home_Background.png");
      boxSize = mediaQueryData.devicePixelRatio * 15;
      spacer = mediaQueryData.devicePixelRatio * 10;
      fontSize = unitHeightValue * 3;
      alignBackImage = Alignment.bottomCenter;
      alignX= -0.20;
      alignY = -0.70;
    }

    precacheImage(background, context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                alignment: alignBackImage,
                image: background,
                fit: BoxFit.contain
            )
        ),
        child: Align(
          alignment: Alignment(alignX, alignY),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MenuWidgetButton(buttonText: "Yomu Kanji", boxSize: boxSize,
                    spacer: spacer, length: spacer * 9, route: '/yomuMenu',
                  fontSize: fontSize, color: CustomColors().murasaki),
                MenuWidgetButton(buttonText: "Kaku Kanji", boxSize: boxSize,
                    spacer: spacer, length: spacer * 9, route: '/kakuMenu',
                  fontSize: fontSize, color: CustomColors().orenji),
                MenuWidgetButton(buttonText: "Statistiche", boxSize: boxSize,
                    spacer: spacer, length: spacer * 7, route: '/settings',
                  fontSize: fontSize, color: CustomColors().chokoMinto),
              ],
            ),
        ),
      ),
    );
  }
}
