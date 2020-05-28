import 'package:flutter/material.dart';
import 'package:gmailapp/models/mail.dart';
import 'package:gmailapp/models/helpers.dart';

class MailDetail extends StatefulWidget {
  final Mail mail;

  MailDetail(this.mail);

  @override
  _MailDetailState createState() => _MailDetailState(this.mail);
}

class _MailDetailState extends State<MailDetail> {
  final Mail mail;
  bool _isVisible = false;
  bool _showCc = true;
  bool _showBcc = true;
  
  DbHelper helper = DbHelper();
   void show(){
     setState(() {
         _isVisible = !(_isVisible);
      });
  }

  _MailDetailState(this.mail);
  var to = '';
  var cc = ' ';
  var bcc = ' ' ;

  @override
  Widget build(BuildContext context) {
    setState(() {
      
      cc = mail.cc;
      bcc = mail.bcc;
      to = mail.to;
      if(mail.cc==null)
       {
         _showCc = false;
           cc  = "fake";
       }
       if(mail.bcc==null)
       {
         _showBcc = false;
          bcc  = "fake";
       }
    });
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.yellow,
              ),
              onPressed: () {
                showAlertDialog(context);
              }),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                mail.sub,
                style: TextStyle(fontSize: 40),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(2),
              child: Card(
                elevation: 5,
                child:ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.purple,
                  child: Icon(Icons.mail),
                ),
                title: Text('Madhava Dasari',
                style: TextStyle(fontSize: 20),),
                subtitle: Text('to: $to'),
                trailing: IconButton(
                  icon: _isVisible ?  Icon(Icons.keyboard_arrow_down): Icon(Icons.keyboard_arrow_up),
                  onPressed: (){
                    show();
                  },
                  color: Colors.purple,
                ),
              )),
            ),
            Visibility(
              visible: _isVisible,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.purple
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                
                  children:
                     <Widget>[
                       ListTile(
                         leading: Text('From :'),
                         title: Text(mail.from),
                       ),
                       ListTile(
                         leading: Text('To :'),
                         title: Text(mail.to),
                       ),
                       ListTile(
                         leading: Text('Date :'),
                         title: Text(mail.date),
                       ),
                       Visibility(
                         visible: _showCc,
                         child:  ListTile(
                         leading: Text('Cc :'),
                         title: Text(cc),
                       ),
                       ),
                       Visibility(
                         visible: _showBcc,
                         child:  ListTile(
                         leading: Text('Bcc :'),
                         title: Text(bcc),
                       ),
                       ),
                    ],
                  ),
              ),
              ),
            
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(mail.content),
            ),
          ],
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text('Confrim : '),
      content: Text('Are You Sure to Delete This Mail ? '),
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
                _delete();
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

  void _delete() async {
    Navigator.pop(context);
    await helper.deleteMail(mail.id);
    debugPrint(mail.id.toString());
  }

}
