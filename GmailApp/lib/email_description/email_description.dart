import 'package:GmailApp/GmailList/RouteTransition.dart';
import 'package:flutter/material.dart';
import '../utils/database_helper.dart';
import '../model/Email.dart';
import './Sender_description.dart';
import '../compose/compose.dart';

class Description extends StatefulWidget {
  final Email email;
  final Icon icon;

  Description(this.email, this.icon);
  @override
  State<StatefulWidget> createState() {
    return _Description(this.email, this.icon);
  }
}

class _Description extends State<Description> {
  Databasehelper databasehelper = Databasehelper();
  List<Email> emaillist;
  int count = 0;
  Email email;
  Email newEmail = Email('', '', '', '', '', 1, '');
  Icon _icon;
  bool sender = true;
  int value;

  _Description(this.email, this._icon);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          moveback(1);
          return null;
        },
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              child: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.white,
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      moveback(1);
                    }),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        _deleteEmail(context, this.email);
                        moveback(2);
                      }),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: (MediaQuery.of(context).size.width * 0.85),
                        padding: EdgeInsets.only(top: 30, left: 30),
                        child: Text(
                          this.email.subject,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w100),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(right: 20, top: 30),
                          child: _icon),
                    ],
                  ),
                  Card(
                    margin: EdgeInsets.only(top: 25),
                    elevation: 0,
                    child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(int.parse(this.email.color)),
                          child: Text(
                            this.email.subject[0].toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                        title: SizedBox(
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  "Yash Jain",
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                              Text(
                                this.email.date,
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        trailing: IconButton(
                            icon: icon,
                            onPressed: () {
                              setState(() {
                                show();
                              });
                            })),
                  ),
                  Details(
                      email.sender, email.reciever, email.date, width, height),
                  Container(
                    margin: EdgeInsets.only(top: 60, right: 20, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          this.email.compose,
                          style: TextStyle(fontSize: 20),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 80, bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 30),
                          width: (MediaQuery.of(context).size.width * 0.35),
                          height: (MediaQuery.of(context).size.height * 0.06),
                          child: FlatButton(
                              color: Color(0xFFEA7773),
                              textColor: Colors.white,
                              onPressed: () {
                                navigatetocompose(newEmail);
                              },
                              child: Text(
                                'Reply All',
                                style: TextStyle(fontSize: 20),
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 30),
                          width: (MediaQuery.of(context).size.width * 0.35),
                          height: (MediaQuery.of(context).size.height * 0.06),
                          child: FlatButton(
                              color: Color(0xFFEA7773),
                              textColor: Colors.white,
                              onPressed: () {
                                navigatetocompose(newEmail);
                              },
                              child: Text(
                                'Reply',
                                style: TextStyle(fontSize: 20),
                              )),
                        )
                      ],
                    ),
                  )
                ],
              )),
            )));
  }

  void moveback(int num) {
    if (num == 1) {
      Navigator.pop(context, 1);
    } else {
      Navigator.pop(context, 2);
    }
  }

  void navigatetocompose(Email email) async {
    var result =
        await Navigator.push(context, SlideRightRoute(page: Compose(email)));

    if (result == true) {
      moveback(1);
    }
  }

  void _deleteEmail(BuildContext context, Email email) async {
    await databasehelper.deleteEmail(email.id);
  }

  int width = 0;
  int height = 0;
  Icon icon = Icon(Icons.keyboard_arrow_down);
  void show() {
    if (sender) {
      width = (MediaQuery.of(context).size.width * 0.9).toInt();
      height = (MediaQuery.of(context).size.height * 0.3).toInt();
      sender = !sender;
      icon = Icon(Icons.keyboard_arrow_up);
    } else {
      width = 0;
      height = 0;
      sender = !sender;
      icon = Icon(Icons.keyboard_arrow_down);
    }
  }
}
