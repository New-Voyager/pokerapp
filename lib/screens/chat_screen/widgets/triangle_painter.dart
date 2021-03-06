import 'package:flutter/material.dart';

class Triangle extends CustomPainter {
  final Color bgColor;

  Triangle(this.bgColor);
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    var paint = Paint()..color = bgColor;

    path.lineTo(20, 0);
    path.cubicTo(20, 0, 0, 0, 0, -20);
    path.lineTo(0, -20);
    path.cubicTo(0, -20, 0, 0, -20, 0);
    path.lineTo(-20, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
