import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manabi/widgets/gauge%20_pie_chart_widget.dart';
import '../custom_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// HomeScreen - Menu principale dell'applicazione da cui è possibile navigare
/// ai menu dei giochi di abbinamento e le impostazioni dell'applicazione.

Widget addGameButton(MediaQueryData mediaQueryData, BuildContext context,
    double textSize, double buttonHeight, double buttonWidth,
    AppLocalizations strings) {
  List<Widget> gameButtons = [];
  gameButtons.add(Container(
    height: buttonHeight,
    width: buttonWidth,
    child: ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, strings.yomuMenuRoute),
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(CustomColors.murasaki),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ))),
      child: Text(
        strings.yomuKanjiUpCase,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: textSize * 1.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ));
  //gameButtons.add();
  gameButtons.add(
    Container(
      height: buttonHeight,
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, strings.kakuMenuRoute),
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(CustomColors.orenji),
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ))),
        child: Text(
          strings.kakuKanjiUpCase,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: textSize * 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );

  if (mediaQueryData.orientation == Orientation.landscape) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          gameButtons[0],
          SizedBox(
            width: buttonWidth / 2,
          ),
          gameButtons[1]
        ],
      ),
    );
  } else {
    return Column(
      children: [
        gameButtons[0],
        SizedBox(
          height: buttonHeight / 1.5,
        ),
        gameButtons[1]
      ],
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final unitHeightValue = mediaQueryData.size.height * 0.01;
    double appBarSize = AppBar().preferredSize.height;
    final double screenHeight =
        mediaQueryData.size.height - appBarSize - mediaQueryData.padding.top;
    final double screenWidth = mediaQueryData.size.width;
    final translatedStrings = AppLocalizations.of(context);
    double itemHeight;
    double itemWidth;
    double buttonHeight;
    double buttonWidth;
    double multiplier;
    AssetImage image;

    if (mediaQueryData.orientation == Orientation.landscape) {
      image = AssetImage('assets/images/HomeBackgroundRotated.png');
      buttonHeight = screenHeight / 4.5;
      buttonWidth = screenWidth / 3;
      itemHeight = screenWidth / 5.5;
      itemWidth = screenHeight / 2.5;
      multiplier = 4;
    } else {
      image = AssetImage('assets/images/HomeBackground.png');
      buttonHeight = screenHeight / 8.5;
      buttonWidth = screenWidth / 1.5;
      itemHeight = screenHeight / 4.5;
      itemWidth = screenWidth / 3.25;
      multiplier = 2.25;
    }

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, translatedStrings.settingsRoute);
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topRight,
            image: image,
            fit: BoxFit.contain,
          ),
        ),
        height: screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(flex: 3),
            addGameButton(mediaQueryData, context, multiplier * unitHeightValue,
                buttonHeight, buttonWidth, translatedStrings),
            Spacer(flex: 3),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Container(
                height: itemHeight * 1.30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: Center(
                          child: Text(
                            translatedStrings.averageBestScore,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: multiplier * unitHeightValue,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      height: itemHeight / 4,
                      color: CustomColors.chokoMinto,
                    ),
                    Container(
                      height: itemHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Consumer(builder: (context, watch, child) {
                            return CircularPercentageIndicator(
                              itemHeight: itemHeight,
                              itemWidth: itemWidth,
                              textSize: unitHeightValue * multiplier,
                              textString: translatedStrings.yomuKanjiTranslation,
                              color: CustomColors.murasaki,
                              dataIndex: 1,
                            );
                          }),
                          VerticalDivider(
                            width: 2,
                            thickness: 2,
                          ),
                          Consumer(builder: (context, watch, child) {
                            return CircularPercentageIndicator(
                              itemHeight: itemHeight,
                              itemWidth: itemWidth,
                              textSize: unitHeightValue * multiplier,
                              textString: translatedStrings.yomuKanjiPronunciation,
                              color: CustomColors.orenji,
                              dataIndex: 0,
                            );
                          }),
                          VerticalDivider(
                            width: 2,
                            thickness: 2,
                          ),
                          Consumer(builder: (context, watch, child) {
                            return CircularPercentageIndicator(
                              itemHeight: itemHeight,
                              itemWidth: itemWidth,
                              textSize: unitHeightValue * multiplier,
                              textString: translatedStrings.kakuKanjiReadings,
                              color: CustomColors.chokoMinto,
                              dataIndex: 2,
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
