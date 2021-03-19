import 'package:flutter/material.dart';
import 'package:manabi/widgets/menu_widget_button.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    double boxSize;
    double spacer;

    if(mediaQueryData.orientation == Orientation.landscape){
      boxSize = mediaQueryData.devicePixelRatio * 15;
      spacer = mediaQueryData.devicePixelRatio * 10;

    }else {
      boxSize = mediaQueryData.devicePixelRatio * 15;
      spacer = mediaQueryData.devicePixelRatio * 10;
    }

    return Scaffold(appBar: AppBar(),
      body: Align(
        alignment: Alignment(-0.20, -0.45),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MenuWidgetButton(buttonText: "Yomu Kanji", boxSize: boxSize,
                  spacer: spacer, length: spacer * 9),
              MenuWidgetButton(buttonText: "Kaku Kanji", boxSize: boxSize,
                  spacer: spacer, length: spacer * 9),
              MenuWidgetButton(buttonText: "Settings", boxSize: boxSize,
                  spacer: spacer, length: spacer * 7),
            ],
          ),
      ),
      );
  }
}
