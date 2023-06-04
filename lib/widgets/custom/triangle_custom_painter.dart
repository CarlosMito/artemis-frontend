import 'package:flutter/material.dart';

class TriangleCustomPainter extends CustomPainter {
  final Color color;

  TriangleCustomPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    // The +/- 1 is to correct small bugs of 1 pixel when display in some monitors

    Path path0 = Path();
    path0.moveTo(size.width * 0.0, size.height * 0.0);
    path0.lineTo(size.width * 1.0, size.height * 0.0);
    path0.lineTo(size.width * 0.5, size.height * 1.0);
    path0.lineTo(size.width * 0.0, size.height * 0.0);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
