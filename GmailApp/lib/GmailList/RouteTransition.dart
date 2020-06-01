import 'package:flutter/material.dart';

class Transition extends PageRouteBuilder {
  final page;
  Transition({this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
          transitionDuration: Duration(milliseconds: 400),
        );
}
