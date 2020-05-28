import 'package:flutter/material.dart';

import 'package:gmailapp/models/helpers.dart';
import 'package:gmailapp/models/mail.dart';
import './compose.dart';
import './detail_view.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gmailapp/screens/search.dart';

class MailList extends StatefulWidget {
  @override
  _MailListState createState() => _MailListState();
}

class _MailListState extends State<MailList> {

  DataSearch item = DataSearch();
  DbHelper databaseHelper = DbHelper();
  List<Mail> mailList;
  bool undo = false;
  int count = 0;

  @override
  Widget build(BuildContext context) {
   // updateListView();
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          child: Icon(Icons.email),
          backgroundColor: Colors.yellow,
        ),
        title: Text('Sent'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.yellow,
                size: 30,
              ),
              onPressed: () {
             
                showSearch(context: context, delegate: DataSearch());
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(
          Icons.edit,
          color: Colors.yellow,
        ),
        tooltip: 'Compose Email',
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Compose();
          }));
          updateListView();
        },
      ),
      body: getMailListView(),
    );
  }

  ListView getMailListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Dismissible(
              key: ObjectKey(mailList[position]),
              background: deleteBackground(),
              onDismissed: (direction) {
                 _delete(mailList[position].id);
                 updateListView();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Deleting Mail...'),
                  action: SnackBarAction(label: 'Undo', onPressed: () {
                     setState(() {
                       undo = true;
                       updateListView();
                     });
                       
                  }),
                ));
              },
              child: Card(
                shadowColor: Colors.yellow,
                color: Colors.white,
                elevation: 3.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.mail),
                  ),
                  title: Text(this.mailList[position].from),
                  subtitle: Text(this.mailList[position].sub),
                  trailing: Text(this.mailList[position].date),
                  onTap: () {
                    showDetail(this.mailList[position]);
                    
                  },
                ),
              ));
        });
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDb();
    dbFuture.then((db) {
      Future<List<Mail>> mailListFuture = databaseHelper.getMailList();
    
      mailListFuture.then((newList) {
        setState(() {
          this.mailList = newList.reversed.toList();
          this.count = newList.length;
        });
      });
    });
  }

  void showDetail(Mail mail) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MailDetail(mail);
    }));
    updateListView();
  }
  
  void undoMail(int position,Mail mail) async{
      
      await databaseHelper.addMail(mail);
      updateListView();
  }
  Widget deleteBackground() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(15),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  void _delete(int id) async {
    await databaseHelper.deleteMail(id);
    debugPrint(id.toString());
  }
}

