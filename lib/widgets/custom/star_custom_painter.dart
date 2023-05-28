import 'package:flutter/material.dart';

class StarCustomPainter extends CustomPainter {
  final Color color;
  final double? translateX;
  final double? translateY;

  StarCustomPainter({required this.color, this.translateX, this.translateY});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(translateX ?? 0, translateY ?? 0);

    Paint paint0 = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(size.width * 0.50, size.height * 0.00);
    path0.lineTo(size.width * 0.45, size.height * 0.40);
    path0.lineTo(size.width * 0.10, size.height * 0.25);
    path0.lineTo(size.width * 0.40, size.height * 0.50);
    path0.lineTo(size.width * 0.10, size.height * 0.75);
    path0.lineTo(size.width * 0.45, size.height * 0.60);
    path0.lineTo(size.width * 0.50, size.height * 1.00);
    path0.lineTo(size.width * 0.55, size.height * 0.60);
    path0.lineTo(size.width * 0.90, size.height * 0.75);
    path0.lineTo(size.width * 0.60, size.height * 0.50);
    path0.lineTo(size.width * 0.90, size.height * 0.25);
    path0.lineTo(size.width * 0.55, size.height * 0.40);
    path0.lineTo(size.width * 0.50, size.height * 0.00);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
