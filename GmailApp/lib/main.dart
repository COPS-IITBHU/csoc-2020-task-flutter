import 'package:flutter/material.dart';
import './GmailList/List.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gmail App",
      theme: ThemeData(
          primarySwatch: Colors.red,
          brightness: Brightness.light,
          textTheme:
              Theme.of(context).textTheme.apply(fontFamily: 'BalsamiqSans')),
      home: Gmaillist(),
    );
  }
}
