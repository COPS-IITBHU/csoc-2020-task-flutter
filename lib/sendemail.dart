import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import './models/email.dart';
import './email_data.dart';
import './home_page.dart';

class SendMail extends StatelessWidget {
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final subjectController = TextEditingController();
  final contentController = TextEditingController();

  void createMail(ctx, a, b, c, d) {
    Email newEmail = Email(
      id: DateTime.now().toString(),
      toSend: b,
      title: c,
      date: DateTime.now(),
      content: d,
      username: b.toString(),
    );
    print(newEmail.id);
    EmailData.insert(0, newEmail);
    print(EmailData.length);
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return MyHomePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Compose",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.attachment),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (!EmailValidator.validate(fromController.text) ||
                  !EmailValidator.validate(toController.text)) {

                    print("email not valid");

                 showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) {
                return AlertDialog(
                  title: Text("Emails are not valid"),
                  content: Text("CLick anywhere to continue"),
                  elevation: 5,
                );});
              } else if (fromController.text.trim().isEmpty ||
                  toController.text.trim().isEmpty ||
                  subjectController.text.trim().isEmpty ||
                  contentController.text.trim().isEmpty) {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) {
                    return AlertDialog(
                      title: Text("plz fill all fields"),
                      content: Text(
                          "Don't Forgot to fill valid email. \nCLick anywhere to continue"),
                      elevation: 5,
                    );
                  },
                );
              } else {
                createMail(context, fromController.text, toController.text,
                    subjectController.text, contentController.text);
              }
            },
          ),
        ],
        actionsIconTheme: IconThemeData(color: Colors.blueGrey),
        bottomOpacity: 0,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(prefixIcon: Text("From")),
                controller: fromController,
              ),
              TextField(
                decoration: InputDecoration(prefixIcon: Text("To")),
                controller: toController,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Subject'),
                controller: subjectController,
              ),
              TextField(
                scrollController: ScrollController(),
                minLines: null,
                maxLines: null,
                decoration: InputDecoration(hintText: 'Content email'),
                controller: contentController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlertBoxNormal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('AlertDialog Title'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('This is a demo alert dialog.'),
            Text('Would you like to approve of this message?'),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Approve'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
