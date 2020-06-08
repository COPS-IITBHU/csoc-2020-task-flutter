import 'package:flutter/material.dart';
import 'compose.dart';
import 'display.dart';
import 'homepage.dart';

void main() {
  runApp(MailApp());
}

class MailApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Colors.grey,
        canvasColor: Colors.white,
        primaryColor: Colors.white,
        primaryIconTheme: IconThemeData(color: Colors.black54),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MailHomeList(),
        '/compose': (context) => ComposeMail(),
        '/detail': (context) => DetailView(),
      },
    );
  }
}
