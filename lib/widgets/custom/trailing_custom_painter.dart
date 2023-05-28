import 'package:flutter/material.dart';

class TrailingCustomPainter extends CustomPainter {
  final Color color;
  final double? translateX;
  final double? translateY;

  TrailingCustomPainter({required this.color, this.translateX, this.translateY});

  @override
  void paint(Canvas canvas, Size size) {
    Paint trailing = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path top = Path();
    top.moveTo(size.width * 0.600, size.height * 0.000);
    top.lineTo(size.width * 1.190, size.height * 0.210); // NOT OK
    top.lineTo(size.width * 1.750, size.height * 0.450);
    top.lineTo(size.width * 1.210, size.height * 0.190); // NOT OK
    top.lineTo(size.width * 0.600, size.height * 0.000);
    top.close();

    Path bottom = Path();
    bottom.moveTo(size.width * 1.750, size.height * 0.550);
    bottom.lineTo(size.width * 1.190, size.height * 0.697); // NOT OK
    bottom.lineTo(size.width * 0.600, size.height * 1.000);
    bottom.lineTo(size.width * 1.190, size.height * 0.662); // NOT OK
    bottom.lineTo(size.width * 1.750, size.height * 0.550);
    bottom.close();

    Path middle = Path();
    middle.moveTo(size.width * 1.800, size.height * 0.500);
    middle.lineTo(size.width * 0.900, size.height * 0.480);
    middle.lineTo(size.width * 0.000, size.height * 0.500);
    middle.lineTo(size.width * 0.900, size.height * 0.520);
    middle.lineTo(size.width * 1.800, size.height * 0.500);
    middle.close();

    // Path star = Path();
    // star.moveTo(size.width * (1.50 - 0.4) * 0.8, size.height * 0.00 * 0.8);
    // star.lineTo(size.width * (1.45 - 0.4) * 0.8, size.height * 0.40 * 0.8);
    // star.lineTo(size.width * (1.10 - 0.4) * 0.8, size.height * 0.25 * 0.8);
    // star.lineTo(size.width * (1.40 - 0.4) * 0.8, size.height * 0.50 * 0.8);
    // star.lineTo(size.width * (1.10 - 0.4) * 0.8, size.height * 0.75 * 0.8);
    // star.lineTo(size.width * (1.45 - 0.4) * 0.8, size.height * 0.60 * 0.8);
    // star.lineTo(size.width * (1.50 - 0.4) * 0.8, size.height * 1.00 * 0.8);
    // star.lineTo(size.width * (1.55 - 0.4) * 0.8, size.height * 0.60 * 0.8);
    // star.lineTo(size.width * (1.90 - 0.4) * 0.8, size.height * 0.75 * 0.8);
    // star.lineTo(size.width * (1.60 - 0.4) * 0.8, size.height * 0.50 * 0.8);
    // star.lineTo(size.width * (1.90 - 0.4) * 0.8, size.height * 0.25 * 0.8);
    // star.lineTo(size.width * (1.55 - 0.4) * 0.8, size.height * 0.40 * 0.8);
    // star.lineTo(size.width * (1.50 - 0.4) * 0.8, size.height * 0.00 * 0.8);
    // star.close();

    canvas.drawPath(top, trailing);
    canvas.drawPath(bottom, trailing);
    canvas.drawPath(middle, trailing);
    // canvas.drawPath(star, trailing);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
