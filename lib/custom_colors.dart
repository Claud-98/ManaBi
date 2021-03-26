import 'package:flutter/material.dart';
/// CustomColors - una classe di colori personalizzati con bad naming-sense.
class CustomColors{
  final murasaki = const Color(0xFFF3518C);
  final orenji =  const Color(0xFFF6B96C);
  final chokoMinto = const Color(0xFF66D5A2);
  final reddo = const Color(0xFFDE3A5D);
  final blackGround = const Color(0xFF525252);
  final nezumihiro = const Color(0xFFDADADA);


  const CustomColors();

  MaterialColor createMaterialColor(Color color) {
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
}