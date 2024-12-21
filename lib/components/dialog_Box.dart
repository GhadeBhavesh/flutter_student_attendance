import 'package:flutter/material.dart';

class DialogBox extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color.fromARGB(255, 237, 96, 53),
          const Color.fromARGB(255, 224, 99, 37),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    final path = Path();
    path.lineTo(0, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.2);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
