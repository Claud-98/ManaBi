import 'package:flutter/material.dart';
import 'package:manabi/utils/custom_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;

  const ErrorScreen({Key key, this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translatedStrings = AppLocalizations.of(context);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final unitHeightValue = mediaQueryData.size.height * 0.01;
    final double screenHeight = mediaQueryData.size.height;
    final double screenWidth = mediaQueryData.size.width;
    double coloredLineHeight;
    double buttonWidth;
    double buttonHeight;
    double itemHeight;
    double multiplier;
    bool spacerHide;

    if(mediaQueryData.orientation == Orientation.landscape){
      coloredLineHeight = screenHeight/50;
      buttonWidth = screenHeight/4;
      buttonHeight = screenWidth/15;
      itemHeight = screenHeight/3;
      multiplier= 4.5;
      spacerHide = true;

    }else {
      coloredLineHeight = screenHeight/60;
      buttonWidth = screenWidth/4;
      buttonHeight = screenHeight/15;
      itemHeight = screenHeight/5;
      multiplier = 2.5;
      spacerHide = false;
    }

    return Container(
      height: screenHeight,
      width: screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,

        children: [
          Container(
            height: mediaQueryData.padding.top + coloredLineHeight,
            color: CustomColors.murasaki,
          ),
          Flexible(
            child: Container(
              color: CustomColors.blackGround,
              width: screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(!spacerHide)
                  Spacer(),
                  Spacer(),
                  SizedBox(
                    height: itemHeight,
                    child: AspectRatio(
                      aspectRatio: 4/3.25,
                      child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/error_img.png"),
                                  fit: BoxFit.fill
                              )
                          )
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: screenWidth/1.25,
                    child: Text(errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: unitHeightValue * multiplier,
                      ),
                    ),
                  ),
                  Spacer(),
                  TextButton(onPressed: () => Navigator.pop(context),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(buttonWidth,
                            buttonHeight)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                          backgroundColor: MaterialStateProperty.all(CustomColors.orenji),
                      ),
                      child: Text(translatedStrings.backButton,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: unitHeightValue * multiplier,
                        ),
                      ),
                  ),
                  Spacer(),
                  if(!spacerHide)
                  Spacer(),
                  if(!spacerHide)
                  Spacer(),
                ],
              ),
            ),
          ),
          Container(
            height: coloredLineHeight,
            color: CustomColors.chokoMinto,
          )
        ],
      ),
    );
  }
}
