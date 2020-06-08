import 'package:flutter/material.dart';

class Floatingpainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint amber = Paint()
      ..color = Colors.amber
      ..strokeWidth = 5;

    Paint green = Paint()
      ..color = Colors.green
      ..strokeWidth = 5;

    Paint blue = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5;

    Paint red = Paint()
      ..color = Colors.red
      ..strokeWidth = 5;

    canvas.drawLine(Offset(size.width * 0.27, size.height * 0.5),
        Offset(size.width * 0.5, size.height * 0.5), amber);
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.5),
        Offset(size.width * 0.5, size.height - (size.height * 0.27)), green);
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.5),
        Offset(size.width - (size.width * 0.27), size.height * 0.5), blue);
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.48),
        Offset(size.width * 0.5, size.height * 0.27), red);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
