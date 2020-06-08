import 'package:flutter/material.dart';

class AvatarBackgroundColor{

  List<MaterialColor> colors = [
    Colors.blue,
    Colors.deepPurple,
    Colors.deepOrange,
    Colors.purple,
    Colors.amber,
    Colors.indigo,
    Colors.orange,
    Colors.cyan,
    Colors.pink,
    Colors.orange,
    Colors.grey,
    Colors.lightBlue,
  ];

  int begin = "a".codeUnitAt(0);
  int end = "z".codeUnitAt(0);

  MaterialColor getColor(String char){
    int temp = char.codeUnitAt(0);
    int tempc = begin+3;

    for(int i=0;i<9;i++){
      if(temp<tempc){
        return colors[i];
      }
      tempc+=3;
    }
    return colors.last;
  }
}

  //  Colors.amber,
  //   Colors.blueGrey,
  //   Colors.indigo,
  //   Colors.teal[600],
  //   Colors.purple,
  //   Colors.red[700],
  //   Colors.blue[900],
  //   Colors.deepOrange,
  //   Colors.green,
  //   Colors.cyan,
  //   Colors.pink,
  //   Colors.lime,
  //   //Colors.white,