import 'package:flutter/material.dart';
import 'package:gmailapp/models/helpers.dart';
import 'package:gmailapp/models/mail.dart';
import 'package:intl/intl.dart';

class Compose extends StatefulWidget {
  @override
  _ComposeState createState() => _ComposeState();
}

class _ComposeState extends State<Compose> {
  
  TextEditingController toController = TextEditingController();
  TextEditingController ccController = TextEditingController();
  TextEditingController bccController = TextEditingController();
  TextEditingController subController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  DbHelper helper = DbHelper();
  bool dropDown = false;
  void _changed(){
     setState(() {
       dropDown=!dropDown;
     });
  }
  final Mail mail = Mail(to:'',from: '',sub: '');
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Compose'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.yellow,
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  showAlertDialog(context);
                }
              },
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
              padding: EdgeInsets.all(15),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      validator: (text) {
                        debugPrint(text);
                        if (text.isEmpty) {
                          return ('Please Enter your mailaddress  ');
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value){
                         this.mail.from = 'me';
                      },
                      decoration: InputDecoration(
                          labelText: 'From : dasarimadhava@gmail.com ',
                          hintText: 'dasarimadhava@gmail.com',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      controller: toController,
                      validator: (text) {
                        if (text.isEmpty) {
                          return ('Please Enter the mailaddress of recepient ');
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      onChanged:(value){
                        this.mail.to = toController.text;
                      },
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                             icon: dropDown ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
                              onPressed: (){
                                _changed();
                              },
                          ),
                          labelText: 'To : ',
                          hintText: 'ex :  user@gmail.com',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                 
                    Visibility(
                      visible: dropDown,
                      child: Column(
                      children: <Widget>[
                        ListTile(
                        title : TextFormField(
                          controller: ccController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged:(value){
                        this.mail.cc = toController.text;
                      },
                          decoration: InputDecoration(
                              labelText: 'Cc : ',
                              hintText: 'ex :  user@gmail.com',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                  ),
                  ListTile(
                        
                        title: TextFormField(
                          controller: bccController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged:(value){
                        this.mail.to = toController.text;
                      },
                          decoration: InputDecoration(
                              labelText: 'Bcc : ',
                              hintText: 'ex :  user@gmail.com',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                  ),
                        ],
                        
                      
                    ) 
                    ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      controller: subController,
                      onChanged: (value){
                          this.mail.sub=subController.text;
                      },
                      decoration: InputDecoration(
                          labelText: 'Subject : ',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),  
                  
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      controller: contentController,
                      onChanged: (value){
                           this.mail.content=contentController.text;
                      },
                      maxLines: 20,
                      decoration: InputDecoration(
                          labelText: 'Content : ',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                ],
              )),
        ));
  }

  void showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text('Confrim : '),
      content: Text('Are You Sure to Send This Mail ? '),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel')),
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _save();
              });
            },
            child: Text('Ok')),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void _save() async {
    Navigator.pop(context);
    mail.date = (DateFormat.yMMMd().format(DateTime.now())).toString();
    if (mail.sub.isEmpty) mail.sub = '(no Subject )';
  
    await helper.addMail(mail);
  }
}
