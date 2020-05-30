import 'package:email_app/database/database_helper.dart';
import 'package:flutter/material.dart';
import '../Drawer.dart';
import '../models/email.dart';
import './email_detail.dart';
import '../search.dart';
import './email_create.dart';

class FavouriteList extends StatefulWidget {
  @override
  _FavouriteListState createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Mail> emailList;
  bool update = false;

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
                  child: Icon(Icons.star),
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
            "Favourites",
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
    List<Mail> emailsFuture = await databaseHelper.getFavouriteList();
    setState(() {
      this.emailList = emailsFuture;
    });
  }

  void _delete(BuildContext context, Mail mail) async {
    int result = await databaseHelper.deleteMail(mail.id);
    if (result != 0) {
      update = true;
      updateListView();
    }
  }
}
