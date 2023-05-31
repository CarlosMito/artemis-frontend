import 'package:artemis/widgets/app_bar/artemis_app_bar.dart';
import 'package:artemis/widgets/custom/star_custom_painter.dart';
import 'package:artemis/widgets/custom/trailing_custom_painter.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_animate/flutter_animate.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  final Random _random = Random(6);

  List<Widget> _buildStars(double centerX, double centerY, totalStars) {
    List<Widget> stars = [];

    var minStarSize = 5;
    var maxStarSize = 30;
    var radius = 300;
    var limitX = 700;
    var limitY = 700;

    for (var i = 0; i < totalStars; i++) {
      var starSize = _random.nextDouble() * maxStarSize + minStarSize;
      var dx = _random.nextDouble() * limitX - limitX / 2;
      var dy = _random.nextDouble() * limitY - limitY / 2;
      var hypotenuse = sqrt(pow(dx, 2) + pow(dy, 2));

      dx += (dx / hypotenuse) * radius - starSize / 2;
      dy += (dy / hypotenuse) * radius - starSize / 2;

      stars.add(Positioned(
        top: centerY,
        left: centerX,
        child: CustomPaint(
          size: Size(starSize, starSize),
          painter: StarCustomPainter(
            translateX: dx,
            translateY: dy,
            color: const Color.fromARGB(255, 222, 205, 155),
          ),
        ),
      ));
    }

    return stars;
  }

  @override
  Widget build(BuildContext context) {
    final Size windowSize = MediaQueryData.fromView(View.of(context)).size;

    return Scaffold(
      appBar: const ArtemisAppBar(),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // CustomPaint(
            //   size: const Size(400, 400),
            //   painter: TrailingCustomPainter(color: const Color.fromARGB(255, 222, 205, 155)),
            // ),
            // CustomPaint(
            //   size: const Size(400, 400),
            //   painter: StarCustomPainter(
            //     color: const Color.fromARGB(255, 222, 205, 155),
            //     translateX: 600,
            //   ),
            // ),
            Stack(children: _buildStars(windowSize.width / 2, windowSize.height / 2, 15))
                .animate(onPlay: (controller) => controller.repeat())
                .rotate(duration: const Duration(seconds: 70)),
            Stack(children: _buildStars(windowSize.width / 2, windowSize.height / 2, 15))
                .animate(onPlay: (controller) => controller.repeat())
                .rotate(duration: const Duration(seconds: 100)),
            Stack(children: _buildStars(windowSize.width / 2, windowSize.height / 2, 15))
                .animate(onPlay: (controller) => controller.repeat())
                .rotate(duration: const Duration(seconds: 85)),
            Image.asset("assets/images/background/golden-moon-phases.png")
                .animate(onPlay: (controller) => controller.repeat())
                .rotate(duration: const Duration(seconds: 500), begin: pi, end: 0),
          ],
        ),
      ),
    );
  }
}
