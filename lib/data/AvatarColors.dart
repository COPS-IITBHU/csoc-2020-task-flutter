import 'package:flutter/material.dart';
import 'dart:math';

List avatarColors = <Color>[
  Colors.teal,
  Colors.deepOrange,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.deepPurple,
  Colors.red,
  Colors.pink,
];

Random rng = new Random();

Color getColor() {
  return avatarColors[rng.nextInt(avatarColors.length)];
}

int getColorIndex() {
  return rng.nextInt(avatarColors.length);
}
