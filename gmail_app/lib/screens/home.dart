import 'package:flutter/material.dart';
import 'package:gmail_app/screens/email_compose.dart';
import 'package:gmail_app/widgets/email_fab.dart';
import 'package:gmail_app/widgets/email_list.dart';
import 'package:gmail_app/widgets/swipe_disable.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SwipeDisablerWidget(
        child: EmailList(),
      ),
      floatingActionButton: EmailFAB(
        onPressed: () {
          return Navigator.of(context).pushNamed(EmailCompose.navigator);
        },
      ),
      drawer: Drawer(
        child: Scrollbar(
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: 5.0,
                  bottom: 3.0,
                ),
                child: ListTile(
                  title: Text(
                    "Gmail",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[350]))),
              ),
              Container(
                padding: EdgeInsets.only(top: 3.0),
                child: ListTile(
                  leading: Icon(Icons.collections),
                  title: Text("All inboxes"),
                  onTap: () {},
                ),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[350]))),
              ),
              Container(
                child: ListTile(
                  leading: Icon(Icons.inbox),
                  title: Text("Inbox"),
                  onTap: () {},
                ),
              ),
              ListTile(
                title: Text("ALL LABELS"),
              ),
              ListTile(
                leading: Icon(Icons.star_border),
                title: Text("Starred"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text("Snoozed"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.loyalty),
                title: Text("Important"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.send),
                title: Text("Sent"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.timer),
                title: Text("scheduled"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.description),
                title: Text("Drafts"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text("All mail"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.error_outline),
                title: Text("Spam"),
                onTap: () {},
              ),
              ListTile(
                title: Text("Google Apps"),
              ),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text("Calendar"),
                onTap: () {},
              ),
              Container(
                child: ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text("Contacts"),
                  onTap: () {},
                ),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[350]))),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.help_outline),
                title: Text("Help & feedback"),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
