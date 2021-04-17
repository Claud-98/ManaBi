import 'dart:math';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:manabi/custom_colors.dart';

class AllConfettiWidget extends StatefulWidget {
  final Widget  child;

  const AllConfettiWidget({Key key, @required this.child}) : super(key: key);

  @override
  _AllConfettiWidgetState createState() => _AllConfettiWidgetState();
}

class _AllConfettiWidgetState extends State<AllConfettiWidget> {
  ConfettiController controller;
  @override
  void initState() {
    super.initState();
    controller = ConfettiController(duration: Duration(seconds: 1));
    controller.play();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.center,
            child: ConfettiWidget(confettiController: controller,
              colors: [
                CustomColors.murasaki,
                CustomColors.orenji,
                CustomColors.chokoMinto,
              ],
              emissionFrequency: 0,
              numberOfParticles: 50,
              blastDirectionality: BlastDirectionality.explosive,
              blastDirection: -pi/3.5,
              maxBlastForce: 10,
              gravity: 0.1,
            )
        ),

      ],
    );
  }
}
