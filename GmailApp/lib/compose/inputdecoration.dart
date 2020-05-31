import 'package:flutter/material.dart';

InputDecoration decoration(String str, BuildContext context) {
  TextStyle title = Theme.of(context).textTheme.subtitle1;
  return InputDecoration(
      hintText: str,
      labelStyle: title,
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
          borderRadius: BorderRadius.all(Radius.circular(20))));
}
