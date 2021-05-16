import 'package:flutter/material.dart';
import 'package:manabi/utils/custom_colors.dart';
import 'package:manabi/screens/error_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class CircularPercentageIndicator extends ConsumerWidget {
  final int dataIndex;
  final double itemHeight;
  final double itemWidth;
  final Color color;
  final double textSize;
  final String textString;

  CircularPercentageIndicator({
    Key key,
    this.textString,
    this.dataIndex,
    this.itemHeight,
    this.itemWidth,
    this.color,
    this.textSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, watch) {
    AsyncValue<double> average = watch(averageLevelScore(dataIndex));
    return Container(
      child: average.when(
        loading: () => Container(
          height: itemHeight,
          width: itemWidth,
          child: Center(
              child: Stack(
            alignment: Alignment.center,
            children: [
              CircularPercentIndicator(
                arcType: ArcType.HALF,
                progressColor: color,
                arcBackgroundColor: CustomColors.halfNezumi,
                radius: itemWidth / 1.3,
                lineWidth: 10.0,
                percent: 0,
                animation: false,
                center: Text(
                  '0',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: textSize),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: itemWidth / 2.6,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      textString,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: textSize),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          )),
        ),
        error: (error, stack) => ErrorScreen(errorMessage: error.toString()),
        data: (data) {
          return Container(
            height: itemHeight,
            width: itemWidth,
            child: Center(
                child: Stack(
              alignment: Alignment.center,
              children: [
                CircularPercentIndicator(
                  arcType: ArcType.HALF,
                  progressColor: color,
                  arcBackgroundColor: CustomColors.halfNezumi,
                  radius: itemWidth / 1.3,
                  lineWidth: 10.0,
                  percent: data,
                  animation: true,
                  center: Text(
                    ((data * 100).round()).toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: textSize),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: itemWidth / 2.6,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        textString,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: textSize),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            )),
          );
        },
      ),
    );
  }
}
