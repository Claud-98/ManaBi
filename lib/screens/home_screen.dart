import 'package:flutter/material.dart';
import 'package:manabi/widgets/menu_widget_button.dart';

import '../custom_colors.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    double boxSize;
    double spacer;
    double fontSize;

    if(mediaQueryData.orientation == Orientation.landscape){
      boxSize = mediaQueryData.devicePixelRatio * 15 * 1.4;
      spacer = mediaQueryData.devicePixelRatio * 10 * 1.2;
      fontSize = 25;
    }else {
      boxSize = mediaQueryData.devicePixelRatio * 15;
      spacer = mediaQueryData.devicePixelRatio * 10;
      fontSize = 20;
    }

    return Scaffold(appBar: AppBar(),
      body: Align(
        alignment: Alignment(-0.20, -0.45),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MenuWidgetButton(buttonText: "Yomu Kanji", boxSize: boxSize,
                  spacer: spacer, length: spacer * 9, route: '/yomuMenu',
                fontSize: fontSize, color: CustomColors().murasaki),
              MenuWidgetButton(buttonText: "Kaku Kanji", boxSize: boxSize,
                  spacer: spacer, length: spacer * 9, route: '/',
                fontSize: fontSize, color: CustomColors().orenji),
              MenuWidgetButton(buttonText: "Settings", boxSize: boxSize,
                  spacer: spacer, length: spacer * 7, route: '/',
                fontSize: fontSize, color: CustomColors().chokoMinto),
            ],
          ),
      ),
    );
  }
}
