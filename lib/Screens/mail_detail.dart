import 'package:flutter/material.dart';
import '../Models/maildb.dart';
import '../Utility/database_settings.dart';
import 'package:intl/intl.dart';

class EmailDetail extends StatefulWidget{

  final MailDB mail;

  EmailDetail(this.mail);
  @override
  State<StatefulWidget> createState(){
    return EmailDetailState(this.mail);
  }
}

class EmailDetailState extends State<EmailDetail>{

  DatabaseHelper helper= DatabaseHelper();

  MailDB mail;

  TextEditingController senderController= TextEditingController();
  TextEditingController recepientController= TextEditingController();
  TextEditingController subjectController= TextEditingController();
  TextEditingController mailController= TextEditingController();

  EmailDetailState(this.mail);

  @override
  Widget build(BuildContext context){

    senderController.text=mail.sender;
    recepientController.text=mail.recepient;
    subjectController.text=mail.subject;
    mailController.text=mail.mail;
    final _formKey= GlobalKey<FormState>();

    return MaterialApp(
      home:Scaffold(
        appBar: AppBar(
          title: Text('Compose'),
          leading: GestureDetector(
            onTap: (){
              moveBack();
            },
            child: Icon(Icons.arrow_back),
          ),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.attach_file), onPressed: null),
            IconButton(icon: Icon(Icons.send), onPressed: (){
              setState(() {
                _save();
              });
            }),
            IconButton(icon: Icon(Icons.more_vert), onPressed: null)
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
            children: <Widget>[
            Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(child:
              TextFormField(
                controller: senderController,
                validator: (value){
                  if (value.isEmpty){
                    return 'Please enter sender email';
                  }
                  return null;
                },
                onChanged: (value){
                  updateSender();
                },
                decoration: InputDecoration(
                  hintText: 'From'
                ),
              ),
              ),
              Padding(padding: const EdgeInsets.symmetric(vertical:16.0)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(child:
              TextFormField(
                controller: recepientController,
                validator: (value){
                  if (value.isEmpty){
                    return 'Please enter recepient email';
                  }
                  return null;
                },
                onChanged: (value){
                  updateRecepient();
                },
                decoration: InputDecoration(
                  hintText: 'To'
                ),
              ),
              ),
              Padding(padding: const EdgeInsets.symmetric(vertical:16.0)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(child:
              TextFormField(
                controller: subjectController,
                validator: (value){
                  if (value.isEmpty){
                    return 'Please enter subject';
                  }
                  return null;
                },
                onChanged: (value){
                  updateSubject();
                },
                decoration: InputDecoration(
                  hintText: 'Subject'
                ),
              ),
              ),
              Padding(padding: const EdgeInsets.symmetric(vertical:16.0)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(child:
              Container(
                alignment: Alignment.center,
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(1,1,1,1),
                child:
                  TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  controller: mailController,
                  onChanged: (value){
                    updateMail();
                  },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Compose Email',
                  ),
                ),
              )
              ),
            ],
          )
        ]
      )
    ),
        )
      )
    );
  }

  void moveBack(){
    Navigator.pop(context,true);
  }

  void updateSender(){
    mail.sender=senderController.text;
  }

  void updateRecepient(){
    mail.recepient=recepientController.text;
  }

  void updateSubject(){
    mail.subject=subjectController.text;
  }

  void updateMail(){
    mail.mail=mailController.text;
  }

  void _save() async{
    moveBack();
    mail.date= DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(mail.id==null){
      result= await helper.insertMail(mail);
    }

    if(result!=0){
      alertmessage('Status', 'Email Sent');
    }
    else{
      alertmessage('Status','Email Not Sent');
    }
  }

  void alertmessage(String title, String message){

    AlertDialog alertDialog= AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_)=> alertDialog);
  }
}



