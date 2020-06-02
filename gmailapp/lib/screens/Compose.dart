import 'package:flutter/material.dart';
import 'package:gmail/Database/EmailDatabase.dart';
import 'package:gmail/Database/EmailModel.dart';
class Compose extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ComposeState();
  }

}
class _ComposeState extends State<Compose>{
  final _formKey = GlobalKey<FormState>();
  Emails newEmail=Emails();
  EmailDatabase em=EmailDatabase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        floatingActionButton: Builder(builder:(BuildContext context){return FloatingActionButton(onPressed: (){
          if(_formKey.currentState.validate()){
            _formKey.currentState.save();
            em.database.then((value){
              em.createEmail(value, newEmail);
              Scaffold
          .of(context)
          .showSnackBar(SnackBar(content: Text('Email added')));
          Navigator.pop(context);
              });
            Scaffold
          .of(context)
          .showSnackBar(SnackBar(content: Text('Email adding wait...')));
          }
        },backgroundColor: Colors.blue,child: Icon(Icons.send),);},),
        appBar: AppBar(backgroundColor: Colors.black,),
        body: Form(
          key: _formKey,
          child:ListView(
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 400,
                    child:TextFormField(
                      onSaved: (value){
                        newEmail.to=value;
                      },
                      validator:(value){
                      if(value.isEmpty){
                        return "Field cant be blank";
                      } 
                      return null;
                    },style: TextStyle(color: Colors.white,fontSize: 15),
                        decoration: InputDecoration(
                          hintText: "To",
                          hintStyle: TextStyle(color: Colors.white30,fontSize: 20)
                        )
                    )
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 400,child:TextFormField(
                      onSaved: (value){
                        newEmail.from=value;
                      },
                      validator:(value){
                      if(value.isEmpty){
                        return "Field cant be blank";
                      } 
                      return null;
                    },style: TextStyle(color: Colors.white,fontSize: 15),decoration: InputDecoration(hintText: "From",hintStyle: TextStyle(color: Colors.white30,fontSize: 20)))),
                  ],
                ),
              ),Container(
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 400,child:TextFormField(
                      onSaved: (value){
                        newEmail.subject=value;
                      },
                      validator:(value){
                      if(value.isEmpty){
                        return "Field cant be blank";
                      } 
                      return null;
                    },style: TextStyle(color: Colors.white,fontSize: 15),decoration: InputDecoration(hintText: "subject",hintStyle: TextStyle(color: Colors.white30,fontSize: 20)))),
                  ],
                ),
              ),Container(
                width: double.infinity,
                child: 
                    SizedBox(width: 400,child:TextFormField(
                      onSaved: (value){
                        newEmail.message=value;
                      },
                      validator:(value){
                      if(value.isEmpty){
                        return "Field cant be blank";
                      } 
                      return null;
                    },keyboardType: TextInputType.multiline,maxLines: null,style: TextStyle(color: Colors.white,fontSize: 15),decoration: InputDecoration(hintText: "Compose message",hintStyle: TextStyle(color: Colors.white30,fontSize: 20)))),
              )
            ],
          ),
        ),
    );
  }

}