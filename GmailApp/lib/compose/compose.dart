import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../model/Email.dart';
import '../utils/database_helper.dart';
import './inputdecoration.dart';

class Compose extends StatefulWidget {
  final Email email;
  Compose(this.email);
  @override
  State<StatefulWidget> createState() {
    return _Compose(this.email);
  }
}

class _Compose extends State<Compose> {
  var _formkey = GlobalKey<FormState>();

  TextEditingController sender = TextEditingController();
  TextEditingController reciever = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController compose = TextEditingController();

  Databasehelper databasehelper = Databasehelper();
  Email email;

  _Compose(this.email);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          moveback();
          return null;
        },
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              leading: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    moveback();
                  }),
              title: Text(
                "Compose",
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                IconButton(
                    color: Colors.blue,
                    icon: Icon(Icons.send),
                    onPressed: () {
                      setState(() {
                        if (_formkey.currentState.validate()) {
                          sender.clear();
                          reciever.clear();
                          subject.clear();
                          compose.clear();
                          _send();
                        }
                      });
                    }),
                IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.attach_file),
                    onPressed: () {}),
              ],
            ),
            body: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                        top: 40,
                        left: 20,
                        right: 20,
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: sender,
                        validator: _validateEmail,
                        style: TextStyle(fontSize: 20.0),
                        decoration: decoration('From', context),
                        onChanged: (value) {
                          email.sender = sender.text;
                        },
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 20,
                        right: 20,
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: reciever,
                        validator: _validateEmail,
                        style: TextStyle(fontSize: 20.0),
                        decoration: decoration('To', context),
                        onChanged: (value) {
                          email.reciever = reciever.text;
                        },
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 20,
                        right: 20,
                      ),
                      child: TextFormField(
                        style: TextStyle(fontSize: 20.0),
                        keyboardType: TextInputType.text,
                        controller: subject,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter Subject';
                          }
                          return null;
                        },
                        decoration: decoration('Subject', context),
                        onChanged: (value) {
                          email.subject = subject.text;
                        },
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 20,
                        right: 20,
                      ),
                      child: TextFormField(
                        maxLines: 3,
                        keyboardType: TextInputType.text,
                        controller: compose,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please Enter Compose';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 20.0),
                        decoration: decoration('Compose Email', context),
                        onChanged: (value) {
                          email.compose = compose.text;
                        },
                      )),
                ]),
              ),
            )));
  }

  void _send() async {
    moveback();

    email.date = DateFormat.MMMd().format(DateTime.now());
    email.color = random();
    int result = await databasehelper.insertEmail(email);

    if (result != 0) {
      _showAlertDialog('Status', 'Email Sent Successfully');
    } else {
      _showAlertDialog('Status', 'Error Sending Email');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void moveback() {
    Navigator.pop(context, true);
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return "Enter email address";
    }
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      if (sender.text == reciever.text) {
        return 'Emails are Equal';
      } else {
        return null;
      }
    }

    return 'Email is not valid';
  }

  String random() {
    var rand = Random();
    int number = rand.nextInt(10);
    if (number == 1) {
      return '0xFFFF4848';
    } else if (number == 2) {
      return '0xFF0A79DF';
    } else if (number == 3) {
      return '0xFF67E6DC';
    } else if (number == 4) {
      return '0xFFBB2CD9';
    } else if (number == 5) {
      return '0xFFE74292';
    } else if (number == 6) {
      return '0xFFA3CB37';
    } else if (number == 7) {
      return '0xFFEEC213';
    } else if (number == 8) {
      return '0xFFF9DDA4';
    } else if (number == 9) {
      return '0xFF758AA2';
    } else {
      return '0xFF4BCFFA';
    }
  }
}
