import 'package:flutter/material.dart';
import 'package:gmail17/data/EmailData.dart';
import 'package:gmail17/ui/HomePage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EmailData(),
      child: MaterialApp(
        title: 'Gmail 13',
        theme: ThemeData.light(),
        home: Container(
          color: Colors.white,
          child: SafeArea(
            child: HomePage(),
          ),
        ),
      ),
    );
  }
}
