import 'package:flutter/material.dart';
import 'package:gmail/Database/EmailDatabase.dart';
import 'package:gmail/Database/EmailModel.dart';
import 'package:sqflite/sqflite.dart';
class Emaildetail extends StatelessWidget{
  int id;
  Emaildetail(int id){
    this.id=id;
  }
  @override
  Widget build(BuildContext context) {
    EmailDatabase edb = EmailDatabase();
    Future<Database> database =edb.database;
    return FutureBuilder(
      future: database,
      builder: (context,snapshotdb){
        if(snapshotdb.data==null){
          return Text("Loading",style: TextStyle(color: Colors.white),);
        }
        Future<Emails> email=edb.getEmail(snapshotdb.data,id);
        return FutureBuilder(
          future: email,
          builder: (context, snapshot) {
            if(snapshot.data==null){
              return Text("Loading email",style: TextStyle(color: Colors.white),);
            }
            return  Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black,),
        body: Container(
          color: Colors.black,
          child:ListView(
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    Text("To:",style: TextStyle(color: Colors.white30,fontSize: 20),),
                    SizedBox(width: 10,),
                    Text(snapshot.data.to,style:TextStyle(color: Colors.white,fontSize: 15))
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    Text("From:",style: TextStyle(color: Colors.white30,fontSize: 20),),
                    SizedBox(width: 10,),
                    Text(snapshot.data.from,style:TextStyle(color: Colors.white,fontSize: 15))
                  ],
                ),
              ),Container(
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    Text("Subject:",style: TextStyle(color: Colors.white30,fontSize: 20),),
                    SizedBox(width: 10,),
                    Text(snapshot.data.subject,style:TextStyle(color: Colors.white,fontSize: 15))
                  ],
                ),
              ),Container(
                width: double.infinity,
                child: 
                    Text(snapshot.data.message,style:TextStyle(color: Colors.white,fontSize: 15)),
              )
            ],
          ),
        ),
    );
      },
      
    );
    
  });}

}