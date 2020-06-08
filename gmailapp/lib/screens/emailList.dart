//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:gmail/Database/EmailDatabase.dart';
import 'package:gmail/Database/EmailModel.dart';
import 'package:gmail/screens/Compose.dart';
import 'package:gmail/screens/emailCompose.dart';
import 'EmailListView.dart';
class EmailList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body:CustomScrollView(
          slivers:<Widget>[
            SliverAppBar(
              backgroundColor: Colors.black,
              shape: ContinuousRectangleBorder(
                side: BorderSide(color: Colors.white,style: BorderStyle.solid,width: 1),
                borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
              title: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  
                  fillColor: Colors.white,
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.white),
                  hoverColor: Colors.blueAccent
                ),
              ),
              floating: true,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Search',
                  onPressed: () { /* ... */ },
                ),
              ]
            ),
          SliverList(
            delegate:SliverChildListDelegate(
              <Widget>[
                Wrap(
                  //add list builder here to view gmail
                  children:<Widget>[EmailListView()],
                )
              ]
            ) ,
            )
          ]
          ), 
        drawer:SafeArea(
          child:Container(
          color:Colors.white,
          child:Drawer(
            child:Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Container(
              child: Image(image: AssetImage('assets/mail.png'),width: 100,),
            ),
            Container(child: Text("Gmail",style: TextStyle(
              color: Colors.blue,
              fontSize: 30,
            ),),),
            ListTile(
              title: Text("Sent mails"),
              leading: Icon(Icons.mail),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text("Compose Mail"),
              leading: Icon(Icons.email),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>Compose())),
            )
        ],
        ),
      )
    ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Compose()));
    },
    child: Icon(Icons.message,color: Colors.white,),
    backgroundColor: Colors.blue,
    tooltip: "Add Mail",
    ),
    );
  }
}