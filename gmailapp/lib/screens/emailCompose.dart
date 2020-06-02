import 'package:flutter/material.dart';
class EmailCompose extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(onPressed: null,backgroundColor: Colors.blue,child: Icon(Icons.send),),
        appBar: AppBar(backgroundColor: Colors.black,),
        body: Container(
          color: Colors.black,
          child:ListView(
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 400,child:TextField(style: TextStyle(color: Colors.white,fontSize: 15),decoration: InputDecoration(hintText: "To",hintStyle: TextStyle(color: Colors.white30,fontSize: 20)))),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 400,child:TextField(style: TextStyle(color: Colors.white,fontSize: 15),decoration: InputDecoration(hintText: "From",hintStyle: TextStyle(color: Colors.white30,fontSize: 20)))),
                  ],
                ),
              ),Container(
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 400,child:TextField(style: TextStyle(color: Colors.white,fontSize: 15),decoration: InputDecoration(hintText: "subject",hintStyle: TextStyle(color: Colors.white30,fontSize: 20)))),
                  ],
                ),
              ),Container(
                width: double.infinity,
                child: 
                    SizedBox(width: 400,child:TextField(keyboardType: TextInputType.multiline,maxLines: null,style: TextStyle(color: Colors.white,fontSize: 15),decoration: InputDecoration(hintText: "Compose message",hintStyle: TextStyle(color: Colors.white30,fontSize: 20)))),
              )
            ],
          ),
        ),
    );
  }

}