import 'dart:async';
import 'package:flutter/material.dart';
import '../Models/maildb.dart';
import '../Utility/database_settings.dart';
import '../Screens/mail_detail.dart';
import '../Screens/mail_template.dart';
import 'package:sqflite/sqflite.dart';
import '../Screens/mail_search.dart';

class EmailList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => EmailListState();
}

class EmailListState extends State<EmailList>{
  DatabaseHelper databaseHelper= DatabaseHelper();
  List<MailDB> emailList;
  int count=0;

  TextEditingController searchController= TextEditingController();
  
  @override
  void dispose(){
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    if(emailList==null){
      emailList=List<MailDB>();
      updateEmailView();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            navigateToSend(MailDB('', '', '', ''));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.lightBlue,
          ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(1,18.0,1,1),
              child: TextField(
                autofocus: false,
                controller: searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Search',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search), 
                    onPressed: () => searchOf(searchController.text),
                    splashColor: Colors.cyan[300],
                    ),
                  prefixIcon: Icon(Icons.menu)
                  ),
                ),
              ),
            Text('SENT'),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: count,
                itemBuilder: (BuildContext context, int position){
                  return Dismissible(
                    background: Container(color: Colors.red[200]),
                    key: ObjectKey(this.emailList[position]),
                    child: GestureDetector(
                      onTap: ()=> navigateToShow(this.emailList[position]),
                      child: Card(
                        color: Colors.white,
                        elevation: 2.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.people),
                          ),
                          title: Text(this.emailList[position].subject, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(subbody(this.emailList[position].mail)),
                          trailing: Text(this.emailList[position].date, style: TextStyle(fontWeight: FontWeight.w100, fontSize: 10.0)),
                        )
                      )
                    ),
                    onDismissed: (direction){
                      setState(() {
                      
                        _delete(context, this.emailList[position]);
                      
                      });
                    },
                  );
                  }
                )
              )
            ]
          )
        )
      );

    
  }

  String subbody(String val){
    if (val.length<=30)
    return val;
    else
    return val.substring(0,28)+"..";
  }

  void navigateToSend(MailDB mail) async{
    bool result= await Navigator.push(context, MaterialPageRoute(builder: (context){
      return EmailDetail(mail);
    }));

    if(result){
      updateEmailView();
    }
  }

  void navigateToShow(MailDB detail){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return EmailShow(detail);
    }));
  }

  void searchOf(String str){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return SearchList(str);
    }));
  }


  
  void updateEmailView(){
    final Future<Database> db= databaseHelper.initializeDatabase();
    db.then((database){
      Future<List<MailDB>> mailListFuture = databaseHelper.getMailList();
      mailListFuture.then((emailList){
        setState(() {
          this.emailList=emailList;
          this.count=emailList.length;
        });
      });
    });
  }

  void _delete(BuildContext context, MailDB mail) async{
    int result= await databaseHelper.deleteMail(mail.id);
    if (result!=0){
      _showmessage(context, 'Email Deleted');
      updateEmailView();
    }
  }

  void _showmessage(BuildContext context, String message){
    final snack= SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snack);
  }
}

