import 'package:flutter/material.dart';
/// CustomColors - una classe di colori personalizzati con bad naming-sense.
class CustomColors{
  static final murasaki = const Color(0xFFF3518C);
  static final orenji =  const Color(0xFFF6B96C);
  static final chokoMinto = const Color(0xFF66D5A2);
  static final reddo = const Color(0xFFDE3A5D);
  static final blackGround = const Color(0xFF525252);
  static final nezumihiro = const Color(0xFFDADADA);
  static final halfNezumi = const Color(0xFFAFAFAF);



  const CustomColors();

  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  static List<Color> initColorsKaku(int length){
    List<Color> colors = [];
    int index = 0;

    for(int i=0; i<length; i++){
      switch (index) {
        case 0:
          colors.add(CustomColors.murasaki);
          break;
        case 1:
          colors.add(CustomColors.orenji);
          break;
        case 2:
          colors.add(CustomColors.chokoMinto);
          break;
        case 3:
          colors.add(CustomColors.halfNezumi);
          break;
      }

      if(index == 3)
        index = 0;
      else
        index++;
    }

    return colors;
  }

  static List<Color> initColorsYomu(int length){
    List<Color> colors = [];
    int index = 0;

    for(int i=0; i<length; i++){
      switch (index) {
        case 0:
          colors.add(CustomColors.murasaki);
          break;
        case 1:
          colors.add(CustomColors.orenji);
          break;
        case 2:
          colors.add(CustomColors.chokoMinto);
          break;
      }

      if(index == 2)
        index = 0;
      else
        index++;
    }

    return colors;
  }

}