import 'package:flutter/material.dart';
import '../models/email.dart';
import '../database/database_helper.dart';
import '../database/shared_preferences.dart';
import 'dart:math' as math;

class EmailCreate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EmailCreate();
  }
}

class _EmailCreate extends State<EmailCreate> {
  DatabaseHelper helper = DatabaseHelper();
  SharedPreference profile1 = SharedPreference();

  Mail _add = Mail(recepient: null, date: null, sender: null);
  final _formKey = GlobalKey<FormState>();

  void formValidate() async {
    if (_formKey.currentState.validate()) {
      _add.body ??= ' ';
      _add.subject ??= ' ';
      await helper.insertMail(_add);
      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    super.initState();
    loadMail();
  }

  void loadMail() async {
    _add.favourite = 0;
    _add.archive = 0;

    var date = DateTime.now();
    _add.date = '$date';

    Profile _profile = Profile();
    _profile = await profile1.getProfile();
    setState(() {
      _add.sender = _profile.emailId;
    });
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
              Text.rich(
                TextSpan(
                  text: "From ",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                  children: [
                    TextSpan(
                      text: "   ",
                    ),
                    TextSpan(
                      text: _add.sender,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "To",
                  hintStyle: TextStyle(color: Colors.grey),
                  errorStyle: TextStyle(
                    color: Colors.purple,
                    letterSpacing: 1.0,
                  ),
                  border: InputBorder.none,
                  suffix: Icon(Icons.group_add),
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
                onFieldSubmitted: (value) {
                  setState(() {
                    formValidate();
                  });
                },
              ),
              Divider(
                color: Colors.grey,
                indent: 0,
                thickness: 0.4,
                height: 0.2,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Subject',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: (value) => {_add.subject = value},
                onFieldSubmitted: (value) {
                  setState(() {
                    formValidate();
                  });
                },
              ),
              Divider(
                color: Colors.grey,
                indent: 0,
                thickness: 0.4,
                height: 0.2,
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
                onFieldSubmitted: (value) {
                  setState(() {
                    formValidate();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
