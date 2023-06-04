import 'package:flutter/material.dart';

class RightTriangleCustomPainter extends CustomPainter {
  final Color color;

  RightTriangleCustomPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    // The +/- 1 is to correct small bugs of 1 pixel when display in some monitors

    Path path0 = Path();
    path0.moveTo(size.width * 0.00 - 1, size.height * 0.00);
    path0.lineTo(size.width * 0.00 - 1, size.height * 1.00 + 1);
    path0.lineTo(size.width * 1.00, size.height * 1.00 + 1);
    path0.lineTo(size.width * 0.00 - 1, size.height * 0.00);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
