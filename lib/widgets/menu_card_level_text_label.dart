import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuCardLevelTextLabel extends StatelessWidget {
  final Color color;
  final double padding;
  final double textSize;
  final unitNumber;

  const MenuCardLevelTextLabel(
      {Key key, this.color, this.padding, this.textSize, this.unitNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translatedStrings = AppLocalizations.of(context);

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
          color: color,
          child: Row(
            children: [
              Container(
                width: padding / 2,
              ),
              Center(
                child: RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      translatedStrings.unitUpperCase +
                          " " +
                          unitNumber.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: textSize,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
              Container(
                width: padding / 2,
              )
            ],
          )),
    );
  }
}
