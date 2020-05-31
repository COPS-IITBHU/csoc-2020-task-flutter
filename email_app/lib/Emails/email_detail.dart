import 'package:flutter/material.dart';
import '../models/email.dart';
import '../database/database_helper.dart';
import '../widgets/expansiontile.dart';

class EmailDetail extends StatefulWidget {
  EmailDetail(this._mail);

  final Mail _mail;

  @override
  _EmailDetailState createState() => _EmailDetailState(_mail);
}

class _EmailDetailState extends State<EmailDetail> {
  _EmailDetailState(this._mail);

  Mail _mail;
  bool update = false;
  DatabaseHelper helper = DatabaseHelper();
  bool expaned = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context, update);
            },
          ),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.archive), onPressed: null),
            IconButton(
                color: Colors.grey,
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    helper.deleteMail(_mail.id);
                    update = true;
                    Navigator.pop(context, update);
                  });
                }),
            IconButton(icon: Icon(Icons.mail_outline), onPressed: null),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Wrap(
                  children: <Widget>[
                    Container(
                      width: 320.0,
                      child: Text(
                        _mail.subject,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                    favourite(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      child: Text(
                        _mail.recepient.substring(0, 2).toUpperCase(),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          _mail.recepient,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            Text("to students.all"),
                            IconButton(
                                icon: Icon(Icons.arrow_drop_down),
                                onPressed: () {
                                  setState(() {
                                    expaned = !expaned;
                                  });
                                })
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.reply),
                  ],
                ),
              ),
              ExpandedSection(
                expand: expaned,
                child: Container(
                  width: double.infinity,
                  height: 145.0,
                  margin: EdgeInsets.all(10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0.8,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text.rich(
                            TextSpan(
                              text: "From   ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15.0,
                              ),
                              children: [
                                TextSpan(
                                  text: _mail.recepient,
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                                text: "To       ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                ),
                                children: [
                                  TextSpan(
                                    text: "students.all@itbhu.ac.in",
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  )
                                ]),
                          ),
                          Text.rich(
                            TextSpan(
                                text: "Date   ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                ),
                                children: [
                                  TextSpan(
                                    text: _mail.date,
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  )
                                ]),
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.lock_outline,
                                size: 18,
                              ),
                              SizedBox(
                                width: 23.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Standard encryption (TLS)."),
                                  Text(
                                    "View Security Details",
                                    style: TextStyle(
                                        color: Colors.lightBlueAccent),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15.0),
                child: Text(
                  _mail.body,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.black87,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  IconButton favourite() {
    return _mail.favourite == 1
        ? IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              setState(() {
                _mail.favourite = 0;
                update = true;
                helper.updateMail(_mail);
              });
            },
          )
        : IconButton(
            icon: Icon(Icons.star_border),
            onPressed: () {
              setState(() {
                _mail.favourite = 1;
                update = true;
                helper.updateMail(_mail);
              });
            });
  }
}
