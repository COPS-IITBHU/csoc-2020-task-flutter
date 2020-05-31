import 'package:flutter/material.dart';

class Style extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: AlignmentDirectional.centerStart,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ));
  }
}

class SecondStyle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: AlignmentDirectional.centerEnd,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ));
  }
}
