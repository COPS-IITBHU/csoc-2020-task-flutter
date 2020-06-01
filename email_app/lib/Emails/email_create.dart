import 'package:flutter/material.dart';
import '../models/email.dart';
import '../database/database_helper.dart';
import 'dart:math' as math;

class EmailCreate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EmailCreate();
  }
}

class _EmailCreate extends State<EmailCreate> {
  DatabaseHelper helper = DatabaseHelper();

  final _formKey = GlobalKey<FormState>();
  Mail _add = Mail(recepient: null, date: null);

  void formValidate() async {
    if (_formKey.currentState.validate()) {
      _add.body ??= ' ';
      _add.subject ??= ' ';
      _add.favourite = 0;
      _add.archive = 0;

      var date = DateTime.now();
      _add.date = '$date';

      await helper.insertMail(_add);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Compose"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.attach_file),
              onPressed: () {},
            ),
            Transform.rotate(
              angle: -45 * math.pi / 180,
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    setState(() {
                      formValidate();
                    });
                  },
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "From",
                  hintStyle: TextStyle(color: Colors.grey),
                  errorStyle: TextStyle(
                    color: Colors.purple,
                    letterSpacing: 1.0,
                  ),
                  border: InputBorder.none,
                  suffix: IconButton(
                    icon: Icon(Icons.group_add),
                    onPressed: () {},
                  ),
                ),
                validator: (value) {
                  bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value);

                  if (value.isEmpty) {
                    value = null;
                    return "Enter an email";
                  } else if (emailValid == false) {
                    return "Invalid Email";
                  }

                  return null;
                },
                onChanged: (value) => {_add.recepient = value},
              ),
              Divider(
                color: Colors.grey,
                indent: 0,
                thickness: 0.1,
                height: 0.2,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Subject',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: (value) => {_add.subject = value},
              ),
              Divider(
                color: Colors.grey,
                indent: 0,
                thickness: 0.4,
                height: 0.4,
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.send,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Compose email',
                ),
                onChanged: (value) => {_add.body = value},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
