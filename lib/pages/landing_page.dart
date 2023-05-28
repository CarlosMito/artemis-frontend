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

class _LandingPageState extends State<LandingPage> {
  Matrix4 _matrix = Matrix4.identity();
  ValueNotifier<Matrix4>? _notifier;
  final Random _random = Random(6);

  @override
  void initState() {
    super.initState();
    _notifier = ValueNotifier(_matrix);
  }

  List<Widget> _buildStars(double centerX, double centerY, totalStars) {
    List<Widget> stars = [];

    var minStarSize = 5;
    var maxStarSize = 25;
    var radius = 300;
    var limitX = 700;
    var limitY = 700;

    for (var i = 0; i < totalStars; i++) {
      var starSize = _random.nextDouble() * maxStarSize + minStarSize;
      var left = _random.nextDouble() * limitX - limitX / 2;
      var top = _random.nextDouble() * limitY - limitY / 2;
      var hypotenuse = sqrt(pow(left, 2) + pow(top, 2));

      left += (left / hypotenuse) * radius;
      top += (top / hypotenuse) * radius;

      stars.add(Positioned(
        top: centerX,
        left: centerY,
        child: CustomPaint(
          size: Size(starSize, starSize),
          painter: StarCustomPainter(
            translateX: left - starSize / 2,
            translateY: top - starSize / 2,
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
            CustomPaint(
              size: const Size(400, 400),
              painter: TrailingCustomPainter(color: const Color.fromARGB(255, 222, 205, 155)),
            ),
            CustomPaint(
              size: const Size(400, 400),
              painter: StarCustomPainter(
                color: const Color.fromARGB(255, 222, 205, 155),
                translateX: 600,
              ),
            ),
            // CustomPaint(
            //   size: const Size(400, 400),
            //   painter: StarCustomPainter(color: const Color.fromARGB(255, 222, 205, 155)),
            // )
            // Stack(children: _buildStars(windowSize.height / 2, windowSize.width / 2, 15))
            //     .animate(onPlay: (controller) => controller.repeat())
            //     .rotate(duration: const Duration(seconds: 70)),
            // Stack(children: _buildStars(windowSize.height / 2, windowSize.width / 2, 15))
            //     .animate(onPlay: (controller) => controller.repeat())
            //     .rotate(duration: const Duration(seconds: 100)),
            // Stack(children: _buildStars(windowSize.height / 2, windowSize.width / 2, 15))
            //     .animate(onPlay: (controller) => controller.repeat())
            //     .rotate(duration: const Duration(seconds: 85)),
            // Image.asset("assets/images/background/golden-moon-phases.png")
            //     .animate(onPlay: (controller) => controller.repeat())
            //     .rotate(duration: const Duration(seconds: 500), begin: pi, end: 0),
          ],
        ),
      ),
    );
  }
}
