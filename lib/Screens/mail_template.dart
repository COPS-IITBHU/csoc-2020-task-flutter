import 'package:flutter/material.dart';
import '../Models/maildb.dart';
import '../Utility/database_settings.dart';

class EmailShow extends StatefulWidget{

  final MailDB detail;

  EmailShow(this.detail);
  @override
  State<StatefulWidget> createState(){
    return EmailShowState(this.detail);
  }
}

class EmailShowState extends State<EmailShow>{

  DatabaseHelper helper= DatabaseHelper();

  MailDB detail;



  EmailShowState(this.detail);

  @override
  Widget build(BuildContext context){

    

    return MaterialApp(
      home:Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: (){
              gotoPrevious();
            },
            child: Icon(Icons.arrow_back),
          ),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.delete), onPressed: null),
            IconButton(icon: Icon(Icons.mail), onPressed: null),
            IconButton(icon: Icon(Icons.more_vert), onPressed: null)
          ],
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            Container(
              
              color: Colors.white,
              child: Text(detail.subject, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),)
            ),
            Container(
              
              color: Colors.white,
              child:
                 ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.people),
          ),
          title: Text(detail.sender, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
          subtitle: Row(
            children: [
              Text('to '+detail.recepient, style: TextStyle( fontSize: 12.0)),
            ]
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: Icon(Icons.reply), onPressed: null) ,
              IconButton(icon: Icon(Icons.more_vert), onPressed: null) ,
            ]))
            ),
            Container(
              child: Text('Date: '+ detail.date, style: TextStyle(fontWeight: FontWeight.w100),) 
            ),
                  
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              color: Colors.white,
              child: Text(detail.mail),             
            )
          ],
        ),
      )
    );
  }

 
  void gotoPrevious(){
    Navigator.pop(context,true);   
  } 
}