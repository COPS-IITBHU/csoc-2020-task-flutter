import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/services.dart';
import 'package:gmail_app/providers/database_helper.dart';
import 'package:gmail_app/providers/models.dart';
import 'package:provider/provider.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';

class EmailCompose extends StatefulWidget {
  static String navigator = "/email_Compose";
  @override
  State<StatefulWidget> createState() {
    return _EmailComposeState();
  }
}

class _EmailComposeState extends State<EmailCompose> {
  var _formKey = GlobalKey<FormState>();

  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController ccController = TextEditingController();
  TextEditingController bccController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Compose"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.attachment,
              color: Colors.grey[850],
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.grey[850],
            ),
            onPressed: () async {
              debugPrint("send button pressed");
              if (_formKey.currentState.validate()) _sendMail();
            },
          ),
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Text("Schedule send"),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Text("Add from Contacts"),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Text("Confidential mode"),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: Text("Save draft"),
                    ),
                    PopupMenuItem(
                      value: 5,
                      child: Text("Discard"),
                    ),
                    PopupMenuItem(
                      value: 6,
                      child: Text("Settings"),
                    ),
                    PopupMenuItem(
                      value: 7,
                      child: Text("Help & feedback"),
                    ),
                  ]),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 12.0, left: 8.0, right: 8.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 56.0,
                    child: Text(
                      "From",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: fromController,
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(border: InputBorder.none),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Field cannot be empty";
                        }
                        if (!(EmailValidator.validate(value))) {
                          return "Invalid Email Id";
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 56.0,
                    child: Text(
                      "To",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: toController,
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(border: InputBorder.none),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Field cannot be empty";
                        }
                        if (!(EmailValidator.validate(value))) {
                          return "Invalid Email Id";
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 56.0,
                    child: Text(
                      "Cc",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: ccController,
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(border: InputBorder.none),
                      validator: (String value) {
                        if (value.isNotEmpty &&
                            !(EmailValidator.validate(value))) {
                          return "Invalid Email Id";
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 56.0,
                    child: Text(
                      "bcc",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: bccController,
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(border: InputBorder.none),
                      validator: (String value) {
                        if (value.isNotEmpty &&
                            !(EmailValidator.validate(value))) {
                          return "Invalid Email Id";
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              padding: (EdgeInsets.only(left: 8.0)),
              child: TextFormField(
                maxLines: null,
                controller: subjectController,
                style: TextStyle(fontSize: 18.0),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Subject",
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              padding: EdgeInsets.only(
                left: 8.0,
              ),
              child: TextFormField(
                maxLines: null,
                controller: bodyController,
                style: TextStyle(fontSize: 18.0),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Compose",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> getAddressesList(String addresses, List<String> mailList) {
    mailList = addresses.split(',');
    mailList = mailList.map((e) => e.trim()).toList();
    for (var i in mailList) {
      debugPrint(i);
    }
    return mailList;
  }

  bool validatemails(List<String> mailingList) {
    bool b = true;
    for (String address in mailingList) {
      if (!EmailValidator.validate(address)) {
        b = false;
        break;
      }
    }
    return b;
  }

  void _sendMail() async {
    String from = fromController.text;
    String to = toController.text;
    String cc = ccController.text.isEmpty ? "" : ccController.text;
    String bcc = bccController.text.isEmpty ? "" : bccController.text;
    String subject = subjectController.text.isEmpty
        ? "[no subject]"
        : subjectController.text;
    String body = bodyController.text.isEmpty ? "" : bodyController.text;
    DateTime date = DateTime.now();

    Email mail = Email(
        from: from,
        to: to,
        cc: cc,
        bcc: bcc,
        subject: subject,
        body: body,
        date: date,
        favorite: false);
    final emails = Provider.of<Emails>(context, listen: false);
    int result = await emails.insertMail(mail.toMap());
    debugPrint(result.toString());
    if (result > 0) {
      Navigator.pop(context, true);
      _showAlertDialog('Status', 'Email sent succesfully');
    } else {
      _showAlertDialog('Status', 'Mail could not be sent');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog =
        AlertDialog(title: Text(title), content: Text(message));
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }
}
