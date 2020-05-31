import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gmail17/data/EmailData.dart';

class HomePageDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/drawerBackImage.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            accountName: Text("ones-and-zeroes"),
            accountEmail: Text(myEmail),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/drawerAvatar.png'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Gmail 17",
              style: TextStyle(
                fontSize: 25,
                fontFamily: "Montserrat",
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("ALL LABELS"),
          ),
          drawerTile(Icons.inbox, "Inbox"),
          drawerTile(Icons.star, "Starred"),
          drawerTile(Icons.access_time, "Snoozed"),
          drawerTile(Icons.label, "Important"),
          drawerTile(Icons.send, "Sent"),
          drawerTile(Icons.note, "Drafts"),
          drawerTile(Icons.error, "Spam"),
          drawerTile(Icons.delete, "Bin"),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Google Apps"),
          ),
          drawerTile(Icons.calendar_today, "Calendar"),
          drawerTile(Icons.people, "Contacts"),
          Divider(),
          drawerTile(Icons.settings, "Settings"),
          drawerTile(Icons.help, "Help"),
        ],
      ),
    );
  }

  Widget drawerTile(IconData icon, String text) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Icon(icon),
        ),
        Text(text),
      ],
    );
  }
}
