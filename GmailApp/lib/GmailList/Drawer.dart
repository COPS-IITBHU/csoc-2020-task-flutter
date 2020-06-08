import 'package:flutter/material.dart';

class Drawers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            accountName: Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                'Yash Jain',
                style: TextStyle(fontFamily: 'BalsamiqSans', fontSize: 15),
              ),
            ),
            accountEmail: Text('Jainism987e@gmail.com',
                style: TextStyle(fontFamily: 'BalsamiqSans', fontSize: 15)),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('images/Yash.jpg'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.inbox),
            title: Text('Inbox'),
          ),
          ListTile(
            leading: Icon(Icons.send),
            title: Text('Sent'),
          ),
          ListTile(
            leading: Icon(Icons.drafts),
            title: Text('Draft'),
          ),
          ListTile(
            leading: Icon(Icons.mail_outline),
            title: Text('All mail'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Help and Feedback'),
          ),
        ],
      ),
    );
  }
}
