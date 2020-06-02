import 'package:flutter/material.dart';
import 'package:gmail_app/providers/database_helper.dart';
import 'package:gmail_app/screens/after_search_screen.dart';
import 'package:gmail_app/screens/email_compose.dart';
import 'package:gmail_app/screens/email_detail.dart';
import 'package:gmail_app/screens/home.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Emails(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gmail App',
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.redAccent,
        ),
        routes: {
          EmailDetail.navigator: (BuildContext context) => EmailDetail(),
          EmailCompose.navigator: (BuildContext context) => EmailCompose(),
          SearchList.navigator: (BuildContext context) => SearchList(),
        },
        home: Home(),        
      ),
    );
  }
}
