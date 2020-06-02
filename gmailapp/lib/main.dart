import 'package:flutter/material.dart';
import 'package:animated_splash/animated_splash.dart';
import 'package:gmailapp/screens/list_view.dart';


void main(){
   runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  

  final Function duringSplash = () {
    return 1 ;
  };
   final Map<int, Widget> op = {1: MailList()};
   
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title : 'Gmail App',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        
        primaryColor: Colors.purple,
        accentColor: Colors.yellow,
      ),
       home: AnimatedSplash(
      imagePath: 'assets/gmaildribbble.gif',
      home: MailList(),
      customFunction: duringSplash,
      duration: 5000,
      type: AnimatedSplashType.BackgroundProcess,
      outputAndHome: op,
    ),
    );
  }
}

