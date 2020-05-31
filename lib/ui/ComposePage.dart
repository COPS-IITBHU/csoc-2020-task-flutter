import 'package:flutter/material.dart';
import 'package:gmail17/data/AvatarColors.dart';
import 'package:provider/provider.dart';
import 'package:gmail17/data/EmailData.dart';

class ComposePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String from = "", to = "", subject = "", description = "";
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
        title: Text("Compose"),
        actions: <Widget>[
          IconButton(
            onPressed: null,
            icon: Icon(Icons.attachment),
          ),
          IconButton(
            onPressed: () {
              if (to.indexOf("@") == -1) {
                to = to + "@gmail.com";
              }
              Provider.of<EmailData>(context, listen: false).addEmail(
                EmailItem(
                  avatar: "S",
                  recEmail: to,
                  recName: to.substring(0, to.indexOf('@')),
                  description: description,
                  subject: subject,
                  fav: false,
                  date: DateTime.now(),
                  colorIndex: getColorIndex(),
                  read: true,
                  sender: "Shreyansh",
                ),
              );
              Navigator.pop(context);
            },
            icon: Icon(Icons.send),
          ),
          IconButton(
            onPressed: null,
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 40,
                  child: Text("From"),
                ),
              ),
              Expanded(
                child: Text(
                  myEmail,
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 40,
                  child: Text("To"),
                ),
              ),
              Expanded(
                child: TextField(
                  autofocus: true,
                  onChanged: (text) {
                    to = text;
                  },
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Subject",
              ),
              onChanged: (text) {
                subject = text;
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Compose email",
                ),
                onChanged: (text) {
                  description = text;
                },
                minLines: 40,
                maxLines: null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
