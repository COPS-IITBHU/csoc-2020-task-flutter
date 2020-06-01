import 'package:flutter/material.dart';

import 'package:gmailapp/models/helpers.dart';
import 'dart:async';
import 'package:gmailapp/models/mail.dart';
import './compose.dart';
import './detail_view.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gmailapp/screens/search.dart';
import './fav_view.dart';

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
    if (mailList == null) {
      mailList = List<Mail>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundColor: Colors.yellow,
          radius : 10,
                  child: CircleAvatar(
             radius : 24,
            child: Icon(Icons.send,color: Colors.yellow,),
            backgroundColor: Colors.purple,
          ),
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
              }),
          IconButton(
              icon: Icon(
                Icons.star,
                color: Colors.yellow,
                size: 30,
              ),
              onPressed: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return FavView();
                }));
                updateListView();
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
    // updateListView();
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Dismissible(
              key: ObjectKey(mailList[position]),
              background: deleteBackground(),
              onDismissed: (direction) {
                // undo = false;
                _delete(mailList[position].id);
                showToast(context, 'delete');
                updateListView();
              },
              child: Card(
                margin: EdgeInsets.all(6),
                shadowColor: Colors.purple,
                color: Colors.white,
                elevation: 10.0,
                child: ListTile(
                  leading: CircleAvatar(
                    radius:20,
                    backgroundColor: Colors.purple,
                                      child: CircleAvatar(
                                        radius:17,
                      backgroundColor: Colors.yellow,
                      child: Text(
                        mailList[position].from[0],
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    this.mailList[position].from,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  ),
                  subtitle: Text(
                    this.mailList[position].sub,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    children: <Widget>[
                      Text(mailList[position].date.substring(0,12)),
                      Expanded(
                        child: IconButton(
                            // iconSize: 5,
                            icon: this.mailList[position].fav
                                ? Icon(Icons.star, color: Colors.yellow)
                                : Icon(Icons.star_border),
                                
                            onPressed: () {
                              setState(() {
                                this.mailList[position].fav =
                                    !this.mailList[position].fav;
                                updateFav(this.mailList[position]);
                              });
                            }),
                      ),
                    ],
                  ),
                  onTap: () {
                    showToast(context, 'detail');
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

  void updateFav(Mail mail) async {
    await databaseHelper.updateFav(mail);
  }

  void showDetail(Mail mail) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MailDetail(mail);
    }));
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
    updateListView();
    debugPrint(id.toString());
  }

  void showAlertDialog(BuildContext context, int id) {
    AlertDialog alert = AlertDialog(
      title: Text('Confrim : '),
      content: Image.asset('assert/noresults.jpg'),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 20),
            )),
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();

              setState(() {
                _delete(id);
              });
            },
            child: Text(
              'Ok',
              style: TextStyle(fontSize: 20),
            )),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  static void showToast(BuildContext context, String w) {
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(builder: (context) => ToastWidget(w));
    Overlay.of(context).insert(overlayEntry);
    Timer(Duration(seconds: 2), () => overlayEntry.remove());
  }
}

class ToastWidget extends StatelessWidget {
  final String w;
  @override
  ToastWidget(this.w);
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[400],
      body: Center(
          child: w == 'detail'
              ? Image.asset(
                  'assets/mail_detail.gif',
                  fit: BoxFit.fill,
                )
              : Image.asset(
                  'assets/delete-animation.gif',
                  fit: BoxFit.fill,
                )),
    );
  }
}
