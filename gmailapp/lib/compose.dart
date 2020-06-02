import 'package:flutter/material.dart';

import 'mail.dart';

class ComposeMail extends StatefulWidget {
  @override
  _ComposeMailState createState() => _ComposeMailState();
}

class _ComposeMailState extends State<ComposeMail> {
  final _formKey = GlobalKey<FormState>();
  final RegExp emailExp = RegExp(
      r'^\s*[\w\.\-]+@[\w]+(\.[A-Za-z]{2,3})+\s*(,\s*[\w\.\-]+@[\w]+(\.[A-Za-z]{2,3})+)*\s*$');
  final RegExp ccExp = RegExp(
      r'^(\s*[\w\.\-]+@[\w]+(\.[A-Za-z]{2,3})+\s*(,\s*[\w\.\-]+@[\w]+(\.[A-Za-z]{2,3})+)*\s*)?$');
  final MailDatabaseHelper mailDatabaseHelper = MailDatabaseHelper();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _ccVisible = false;

  String _receiver;
  String _content;
  String _subject;
  String _cc;
  String _bcc;

  void sendMail() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Mail mail = Mail(
        sub: this._subject,
        receivers: this._receiver,
        content: this._content,
        created: DateTime.now().toIso8601String(),
        carbonCopy: this._cc,
        blindCarbonCopy: this._bcc,
      );
      mailDatabaseHelper.saveMail(mail).then(
            (value) => Navigator.pop(context, mail),
            onError: (error) => _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text("Error Occurred!")),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Compose E-mail'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => (!emailExp.hasMatch(value))
                          ? "Enter valid Email comma separated"
                          : null,
                      onSaved: (value) => this._receiver = value,
                      decoration: InputDecoration(
                        hintText: "To",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(!_ccVisible
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up),
                      onPressed: () {
                        setState(() {
                          _ccVisible = !_ccVisible;
                        });
                      },
                    ),
                  )
                ],
              ),
              Divider(),
              Visibility(
                visible: _ccVisible,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => (!ccExp.hasMatch(value))
                          ? "Enter valid Email comma separated"
                          : null,
                      onSaved: (value) => this._cc = value,
                      decoration: InputDecoration(
                        hintText: "CC",
                        border: InputBorder.none,
                      ),
                    ),
                    Divider(),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => (!ccExp.hasMatch(value))
                          ? "Enter valid Email comma separated"
                          : null,
                      onSaved: (value) => this._bcc = value,
                      decoration: InputDecoration(
                        hintText: "BCC",
                        border: InputBorder.none,
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                onSaved: (value) => this._subject = value,
                decoration: InputDecoration(
                  hintText: "Subject",
                  border: InputBorder.none,
                ),
                validator: (value) =>
                    (value.length == 0) ? "Enter a subject" : null,
              ),
              Divider(),
              TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 10,
                maxLines: null,
                onSaved: (value) => this._content = value,
                decoration: InputDecoration(
                  hintText: "Your Content Here",
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.send,
        ),
        onPressed: sendMail,
      ),
    );
  }
}
