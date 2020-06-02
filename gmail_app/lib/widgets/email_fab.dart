import 'package:flutter/material.dart';

class EmailFAB extends StatelessWidget {
  const EmailFAB({
    Key key,
    this.onPressed,
  }) : super(key: key);
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark ? null : Colors.white,
      child: CustomPaint(
        child: Container(),
        foregroundPainter: Painter(),
      ),
      onPressed: () {onPressed();},
    );
  }
}

class Painter extends CustomPainter {

  @override
  bool shouldRepaint(Painter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(Painter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    Paint amberPaint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 5;

    Paint greenPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5;

    Paint bluePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5;

    Paint redPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5;

    canvas.drawLine(Offset(size.width * 0.27, size.height * 0.5),
        Offset(size.width * 0.5, size.height * 0.5), amberPaint);
    canvas.drawLine(
        Offset(size.width * 0.5, size.height * 0.5),
        Offset(size.width * 0.5, size.height - (size.height * 0.27)),
        greenPaint);
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.5),
        Offset(size.width - (size.width * 0.27), size.height * 0.5), bluePaint);
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.5),
        Offset(size.width * 0.5, size.height * 0.27), redPaint);
  }
}
