import 'package:flutter/material.dart';
import './Emails/email_detail.dart';
import './Drawer.dart';
import './Emails/email_create.dart';
import './database/database_helper.dart';
import './models/email.dart';
import './search.dart';
import './Emails/favourites.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => MyHomePage(),
        '/favourites': (context) => FavouriteList(),
      },
    ),
  );
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePage();
  }
}

class _MyHomePage extends State<MyHomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Mail> emailList;
  int count = 0;

  Widget _listBuilder(BuildContext context, int index) {
    return Dismissible(
      background: Container(
        padding: EdgeInsets.only(left: 15.0),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: AlignmentDirectional.centerStart,
      ),
      secondaryBackground: Container(
        padding: EdgeInsets.only(right: 15.0),
        color: Colors.green,
        child: Icon(Icons.archive),
        alignment: AlignmentDirectional.centerEnd,
      ),
      key: ObjectKey(emailList[index]),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 5.0,
        child: InkWell(
          onTap: () async {
            bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return EmailDetail(emailList[index]);
                },
              ),
            );
            if (result == true) updateListView();
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              child: Text(
                emailList[index].recepient.substring(0, 2).toUpperCase(),
              ),
            ),
            title: Text(emailList[index].recepient),
            subtitle: Text(emailList[index].subject),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(emailList[index].date.substring(0, 2)),
                Expanded(
                  child: favourite(emailList[index]),
                ),
              ],
            ),
          ),
        ),
      ),
      onDismissed: (direction) => {
        setState(() {
          _delete(context, emailList[index]);
          emailList.removeAt(index);
        })
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (emailList == null) {
      emailList = List<Mail>();
      updateListView();
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Primary",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(emailList),
                );
              },
            ),
          ],
        ),
        body: intialize(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: () async {
            bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return EmailCreate();
                },
              ),
            );
            if (result == true) {
              updateListView();
            }
            print(result);
          },
        ),
        drawer: SideNav(),
      ),
    );
  }

  Widget intialize() {
    if (emailList.isEmpty)
      return Center(
        child: Container(
          child: Image(
            image: AssetImage('assets/email.gif'),
          ),
        ),
      );
    else
      return ListView.builder(
        padding: EdgeInsets.only(top: 20),
        itemCount: emailList.length,
        itemBuilder: _listBuilder,
      );
  }

  void updateListView() async {
    await databaseHelper.initializeDatabase();
    List<Mail> emailsFuture = await databaseHelper.getMailList();
    setState(() {
      this.emailList = emailsFuture;
      this.count = emailList.length;
    });
  }

  void _delete(BuildContext context, Mail mail) async {
    int result = await databaseHelper.deleteMail(mail.id);
    if (result != 0) {
      updateListView();
    }
  }

  void _update(BuildContext context, Mail mail) async {
    await databaseHelper.updateMail(mail);
  }

  IconButton favourite(Mail _mail) {
    return _mail.favourite == 1
        ? IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              setState(() {
                _mail.favourite = 0;
              });
              _update(context, _mail);
            })
        : IconButton(
            icon: Icon(Icons.star_border),
            onPressed: () {
              setState(() {
                _mail.favourite = 1;
              });
              _update(context, _mail);
            });
  }
}
