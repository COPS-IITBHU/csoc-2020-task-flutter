import 'package:flutter/material.dart';
import 'package:gmailapp/models/mail.dart';
import 'dart:async';
import 'package:gmailapp/models/helpers.dart';


class MailDetail extends StatefulWidget {
  final Mail mail;

  MailDetail(this.mail);

  @override
  _MailDetailState createState() => _MailDetailState(this.mail);
}

class _MailDetailState extends State<MailDetail> {
  final Mail mail;
  bool _isVisible = false;
  DbHelper databaseHelper = DbHelper();
  bool _showCc = true;
  bool _showBcc = true;

  DbHelper helper = DbHelper();
  void show() {
    setState(() {
      _isVisible = !(_isVisible);
    });
  }

  _MailDetailState(this.mail);
  var to = '';
  var cc = ' ';
  var bcc = ' ';

  @override
  Widget build(BuildContext context) {
    String name = '';
    int i = 1;
    String x = mail.from[0];
    while (x != "@" && i < mail.from.length) {
      name += x;
      x = mail.from[i];
      i++;
    }
    setState(() {
      cc = mail.cc;
      bcc = mail.bcc;
      to = mail.to;
      if (mail.cc == null || mail.cc.isEmpty) {
        _showCc = false;
        cc = "fake";
      }
      if (mail.bcc == null || mail.bcc.isEmpty) {
        _showBcc = false;
        bcc = "fake";
      }
    });
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.yellow,
              ),
              onPressed: () {
                showAlertDialog(context);
              }),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              trailing: IconButton(
                  icon: mail.fav
                      ? Icon(Icons.star, color: Colors.yellow)
                      : Icon(Icons.star_border),
                  onPressed: () {
                              setState(() {
                                this.mail.fav =
                                    !this.mail.fav;
                                updateFav(this.mail);
                              });
                            }),
              title: Text(
                mail.sub,
                style: TextStyle(fontSize: 40),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(2),
              child: Card(
                  elevation: 5,
                  child: ListTile(
                    leading:CircleAvatar(
                    radius:20,
                    backgroundColor: Colors.purple,
                                      child: CircleAvatar(
                                        radius:17,
                      backgroundColor: Colors.yellow,
                      child: Text(
                        mail.from[0],
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                    title: Text(
                      name,
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text('to: $to'),
                    trailing: IconButton(
                      icon: _isVisible
                          ? Icon(
                              Icons.keyboard_arrow_down,
                              size: 30,
                            )
                          : Icon(Icons.keyboard_arrow_up, size: 30),
                      onPressed: () {
                        show();
                      },
                      color: Colors.purple,
                    ),
                  )),
            ),
            Visibility(
              visible: _isVisible,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.purple)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      leading: Text('From :'),
                      title: Text(mail.from),
                    ),
                    ListTile(
                      leading: Text('To :'),
                      title: Text(mail.to),
                    ),
                    ListTile(
                      leading: Text('Date :'),
                      title: Text(mail.date),
                    ),
                    Visibility(
                      visible: _showCc,
                      child: ListTile(
                        leading: Text('Cc :'),
                        title: Text(cc),
                      ),
                    ),
                    Visibility(
                      visible: _showBcc,
                      child: ListTile(
                        leading: Text('Bcc :'),
                        title: Text(bcc),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(mail.content,
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      content: Image.asset(
        'assets/delete.gif',
        width: 450,
        height: 300,
      ),
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
                _delete();
              });
              showToast(context);
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

   void updateFav(Mail mail) async {
    await databaseHelper.updateFav(mail);
  }

  void _delete() async {
    Navigator.pop(context);
    await helper.deleteMail(mail.id);
    debugPrint(mail.id.toString());
  }

  static void showToast(BuildContext context) {
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(builder: (context) => ToastWidget());
    Overlay.of(context).insert(overlayEntry);
    Timer(Duration(seconds: 2), () => overlayEntry.remove());
  }
}

class ToastWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[400],
      body: Center(
          child: Image.asset(
        'assets/delete-animation.gif',
        fit: BoxFit.fill,
      )),
    );
  }
}
