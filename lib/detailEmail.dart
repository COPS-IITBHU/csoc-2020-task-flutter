import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './models/email.dart';
import './email_data.dart';
import './home_page.dart';
import './sendemail.dart';

class DetailEmail extends StatefulWidget {
  final Email email;

  DetailEmail(this.email);

  @override
  _DetailEmailState createState() => _DetailEmailState();
}

class _DetailEmailState extends State<DetailEmail> {
  void pressFavorite(String key) {
    if (isSaved(key))
      setState(() {
        Saved.remove(key);
      });
    else
      setState(() {
        Saved.add(key);
      });
  }

  bool isSaved(String key) {
    return Saved.contains(key);
  }

  void deleteEmail(email, ctx) {
    EmailData.remove(email);
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return MyHomePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.archive),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteEmail(widget.email, context);
            },
          ),
          IconButton(
            icon: Icon(Icons.mail_outline),
            onPressed: () {},
          ),
        ],
        actionsIconTheme: IconThemeData(color: Colors.blueGrey),
        bottomOpacity: 0,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          widget.email.title,
                          maxLines: 2,
                          style: TextStyle(fontSize: 28),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        )),
                    IconButton(icon: Icon(Icons.star,color: isSaved(widget.email.id)
                                    ? Colors.amber
                                    : Colors.grey,), onPressed: () {
                      pressFavorite(widget.email.id);

                    })
                  ],
                ),
              ),
              Container(
                height: 70,
                child: ListTile(
                  leading: CircleAvatar(
                      radius: 30,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.blue),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[

                      Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.35),
                          child: Text(
                            widget.email.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          )),
                     
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.2),
                        child: Text(
                          '${DateTime.now().difference(widget.email.date).inDays.toString()} Days ago',
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  trailing: Container(
                    width: MediaQuery.of(context).size.width * 0.08,
                    child: IconButton(
                      icon: Icon(Icons.reply),
                      onPressed: () => {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) {
                          return SendMail();
                        }))
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                child: Card(
                  elevation: 0.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              child: Text(
                                "From ",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              )),
                          Text(widget.email.toSend)
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              child: Text("Bcc",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey))),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              child: Text("Date ",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey))),
                          Text(DateFormat.yMd().add_jm().format(widget.email.date)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              child: Icon(
                                Icons.lock,
                                size: 12,
                                color: Colors.grey,
                              )),
                          Text(
                            "Standard encryption (TLS).",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Card(
                      elevation: 0.0,
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Text(
                            'Dear Mam/Sir\n,THis is the content of all your email , my email content was short so i added it mannually, and here goes my email content ${widget.email.content} THis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i addedTHis is the content of all your email , Dear Mam/Sir\n,THis is the content of all your email , my email content was short so i added it mannually, and here goes my email content ${widget.email.content} THis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i addedmy email content was short so i added Dear Mam/Sir\n,THis is the content of all your email , my email content was short so i added it mannually, and here goes my email content ${widget.email.content} THis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i added Dear Mam/Sir\n,THis is the content of all your email , my email content was short so i added it mannually, and here goes my email content ${widget.email.content} THis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i addedTHis is the content of all your email , my email content was short so i added'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                            child: Text("Reply"),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return SendMail();
                              }));
                            }),
                        RaisedButton(
                            child: Text("Reply All"),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return SendMail();
                              }));
                            }),
                        RaisedButton(
                            child: Text("Forward"),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return SendMail();
                              }));
                            })
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
