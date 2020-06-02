import 'dart:async';
import 'dart:math';

import 'package:emailapp/EmailTileContents.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart' as iter;
import 'package:random_user/models.dart';
import 'package:random_user/random_user.dart';
import 'package:flutter_lorem/flutter_lorem.dart';

import 'compose_mail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Mail App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _random = Random();
  var _mails = <EmailTileContents>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RandomUser().getUsers(results: 50).then(_updateMailList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: ListView.builder(
        itemBuilder: _itemBuilder,
        itemCount: _mails.length,
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context){
            return ComposeMail();
          }));
        },
        tooltip: 'Compose Mail',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final mail = _mails[index];
    return Dismissible(
      key: Key(mail.subject),
      onDismissed: (direction) {
        setState(() {
          _mails.removeAt(index);
        });
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Mail Deleted")));
      },
      // Show a red background as the item is swiped away.
      background: Container(color: Colors.red),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(
                          mail: mail,
                        )));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(mail.avatarUrl),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildSenderList(mail),
                      _buildSubject(mail),
                      Text(mail.snippet),
                      Row(
                          children: mail.attachments
                              .map(_buildAttachmentButton)
                              .toList())
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  Padding _buildAttachmentButton(String attachment) {
    return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: OutlineButton(
          onPressed: () => print("pressed"),
          child: Row(
            children: <Widget>[
              Icon(Icons.image),
              Text(attachment),
            ],
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ));
  }

  void _updateMailList(List<User> users) {
    setState(() {
      _mails = _generateMailSummaries(users);
    });
  }

  List<EmailTileContents> _generateMailSummaries(List<User> users) {
    return iter.partition(users, 1).map(_generateOneMail).toList();
  }

  EmailTileContents _generateOneMail(List users) {
    final senders = users.cast<User>();
    final attachmentCount = max(0, _random.nextInt(6) - 3);
    return EmailTileContents(
      //sender:senders.map((user) => user.name.first).toList(),
      sender: senders.map((user) => user.name.first.capitalize()).toList(),
      avatarUrl: senders.last.picture.medium,
      subject: lorem(paragraphs: 1, words: 4),
      snippet: lorem(paragraphs: 1, words: 4),
      unreadCount: _random.nextInt(senders.length + 1),
      attachments: List.generate(
          attachmentCount, (_) => lorem(paragraphs: 1, words: 1) + 'jpg'),
    );
  }

  Widget _buildSubject(EmailTileContents mail) {
    if (mail.unreadCount > 0) {
      return Text(
        mail.subject,
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    }
    return Text(mail.subject);
  }

  Widget _buildSenderList(EmailTileContents mail) {
    if (mail.unreadCount == 0) {
      return Text(mail.sender.join(','));
    }
    final readCount = mail.sender.length - mail.unreadCount;
    if (readCount == 0) {
      return Text(
        mail.sender.join(','),
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    }
  }
}

class DetailPage extends StatelessWidget {
  final EmailTileContents mail;

  const DetailPage({Key key, @required this.mail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: _buildMessages(),
      ),
    );
  }

  List<Widget> _buildMessages() {
    return mail.sender.map((sender) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(mail.avatarUrl),

                  //child: Text(sender[0]),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(sender.capitalize()))
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(lorem(paragraphs: 3, words: 100)),
          )
        ],
      );
    }).toList();
  }
}
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}


