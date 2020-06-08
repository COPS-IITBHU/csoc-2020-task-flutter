import 'package:flutter/material.dart';

import 'package:gmailapp/models/helpers.dart';
import 'package:gmailapp/models/mail.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:async';

class Compose extends StatefulWidget {
  @override
  _ComposeState createState() => _ComposeState();
}

class _ComposeState extends State<Compose> {
  TextEditingController toController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ccController = TextEditingController();
  TextEditingController bccController = TextEditingController();
  TextEditingController subController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  DbHelper helper = DbHelper();
  bool dropDown = false;
  bool showHidden = false;
  bool save = true;
  bool showPassword = false;
  
  void _showPassword() {
    setState(() {
      showPassword = true;
    });
  }

  void _set() {
    setState(() {
      save = false;
    });
  }

  void _changed() {
    setState(() {
      dropDown = !dropDown;
    });
  }

  final Mail mail = Mail(to: '', from: '', sub: '');
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Compose'),
          actions: <Widget>[
            IconButton(icon:Icon(Icons.info_outline,
            color: Colors.yellow,
           ),
           onPressed:() {
             showInfoDialog(context);
           } ,
           ),
            IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.yellow,
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  showToast(context, 'loading');
                  var error = await mailer();
                  debugPrint('msg : '+error);
                  if (error.length > 45) error = "Invalid Mail Address ";
                  if (save) {
                    showAlertDialog(context);
                  } else {
                    showError(context, error);
                  }
                  setState(() {
                    save =true ;
                  });
                  // showAlertDialog(context);
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
                      enableSuggestions: true,
                      toolbarOptions: ToolbarOptions(copy: true),
                      autofocus: true,
                      controller: fromController,
                      validator: (text) {
                        debugPrint(text);
                        if (text.isEmpty) {
                          return ('Please Enter your mailaddress  ');
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        this.mail.from = fromController.text;
                        _showPassword();
                      },
                      decoration: InputDecoration(
                          labelText: 'From :',
                          hintText: 'ex : name@gmail.com',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Visibility(
                    visible: showPassword,
                    child: ListTile(
                      title: TextFormField(
                        controller: passwordController,
                         validator: (text) {
                        if (text.isEmpty) {
                          return ('Please Enter Your Mail  Password  ');
                        }
                        return null;
                      },
                        obscureText: !showHidden,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            labelText: 'Password : ',
                            suffixIcon: IconButton(
                            icon: !showHidden
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                showHidden = !showHidden;
                              });
                            },
                          ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      
                      enableSuggestions: true,
                      toolbarOptions: ToolbarOptions(copy: true,paste:true),
                      controller: toController,
                      
                      validator: (text) {
                        if (text.isEmpty) {
                          return ('Please Enter the mailaddress of recepient ');
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        this.mail.to = toController.text;
                      },
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: dropDown
                                ? Icon(Icons.keyboard_arrow_up)
                                : Icon(Icons.keyboard_arrow_down),
                            onPressed: () {
                              _changed();
                            },
                          ),
                          labelText: 'To : ',
                          hintText: 'ex :  name@gmail.com',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Visibility(
                      visible: dropDown,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: TextFormField(
                              toolbarOptions: ToolbarOptions(copy: true),
                              controller: ccController,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                this.mail.cc = ccController.text;
                                debugPrint(ccController.text);
                              },
                              decoration: InputDecoration(
                                  
                                  labelText: 'Cc : ',
                                  hintText: 'ex :  name@gmail.com',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
                            ),
                          ),
                          ListTile(
                            title: TextFormField(
                               toolbarOptions: ToolbarOptions(copy: true),
                              enableSuggestions: true,
                              controller: bccController,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                this.mail.bcc = bccController.text;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Bcc : ',
                                  hintText: 'ex :  name@gmail.com',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      maxLines : 3,
                      controller: subController,
                      onChanged: (value) {
                        this.mail.sub = subController.text;
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
                      onChanged: (value) {
                        this.mail.content = contentController.text;
                        
                      },
                      maxLines: 40,
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
      title:Text('Are You Sure to Send This Mail ? ') ,
      content: Image.asset('assets/confrim.gif'),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _save();
              });
            },
            child: Text('Ok',style:TextStyle(fontSize:20) ,)),
            FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel',style:TextStyle(fontSize:20) ,)),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void showInfoDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title:Text('Info : ') ,
      content:  Text('https://myaccount.google.com/lesssecureapps \n Go to this page and ‘ON’ the status of Less secure of app of your google account, otherwise, the google would not let you send emails.'),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop(); },
            child: Text('Ok',style:TextStyle(fontSize:20) ,)),    
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert; });
  }
       
  void showError(BuildContext context, String msg) {
    AlertDialog alert = AlertDialog(
      title: Text(msg),
      content: Image.asset('assets/comp_3.gif'),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel')),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void _save() async {
    showToast(context,'save');
    Navigator.pop(context);
    mail.date = (DateFormat.yMMMd().format(DateTime.now())).toString()+" , "+(DateFormat.Hm().format(DateTime.now())).toString();
    if (mail.sub.isEmpty) mail.sub = '(no subject )';
    if (mail.content == null) {
      mail.content = " ";
    }
    await helper.addMail(mail);
  }
  
  Future<String> mailer() async {
    String msg;
    final smtpServer = gmail(mail.from, passwordController.text);

    final message = Message();
      message.from = Address(mail.from);
      message.recipients.add(mail.to);
      if(mail.cc!=null&&mail.cc.isNotEmpty){
      message.ccRecipients.add(mail.cc);
      }
      if(mail.bcc!=null&&mail.bcc.isNotEmpty){
      message.bccRecipients.add(mail.bcc);
      }
      message.subject = mail.sub;
      message.text = mail.content;

    try {
      final sendReport = await send(message, smtpServer);
      debugPrint('Message Sent ' + sendReport.toString());
      msg = sendReport.toString();
    } on MailerException catch (e) {
      msg = e.toString();
      if (this.mounted) {
        _set();
      }
      debugPrint('message not sent : ' + e.toString());
    }
    return msg;
  }

    static void showToast(BuildContext context,String w) {

    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
        builder: (context) => ToastWidget(w)
    );
    Overlay.of(context).insert(overlayEntry);
    Timer(Duration(seconds: 6 ), () =>  overlayEntry.remove());

  }
 }

class ToastWidget extends StatelessWidget {
  final String w;
  ToastWidget(this.w);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Center(child:  w=='save' ? Image.asset('assets/sendmail.gif',fit: BoxFit.fill,)
                                      :Image.asset('assets/loading1.gif',fit: BoxFit.fill,) ),
    );
  }
}
