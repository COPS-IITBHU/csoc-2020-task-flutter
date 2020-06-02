import 'package:flutter/material.dart';
import 'package:gmailapp/models/helpers.dart';
import 'dart:async';
import 'package:gmailapp/models/mail.dart';
import 'package:sqflite/sqflite.dart';
import './detail_view.dart';

class FavView extends StatefulWidget {
  @override
  _FavViewState createState() => _FavViewState();
}

class _FavViewState extends State<FavView> {

DbHelper databaseHelper = DbHelper();
  List<Mail> mailList;
  List<Mail> favList;
  int count =0 ;

  @override
  Widget build(BuildContext context) {

    if (mailList == null) {
			mailList = List<Mail>();
			updateListView();
		} 
     return Scaffold(
     
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                 // centerTitle: true,
                  title: Text("Starred",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      )),
                  background: Image.asset(
                    "assets/starred.gif",
                    fit: BoxFit.cover,
                  )),
            ),
          ];
        },
        body: getfavListView(),
      ),
       );
  }

  ListView getfavListView() {
    //updateListView();
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return  Card(
                shadowColor: Colors.purple,
                
                color: Colors.white,
                elevation: 10.0,
                child: ListTile(
                  leading :  CircleAvatar(
                    radius:20,
                    backgroundColor: Colors.purple,
                                      child: CircleAvatar(
                                        radius:17,
                      backgroundColor: Colors.yellow,
                      child: Text(
                        mailList[position].from[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    
                    this.mailList[position].from ,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  ),
                  subtitle: Text(
                    this.mailList[position].sub,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    children: <Widget>[
                      Text(mailList[position].date.substring(0,12)),
                      Expanded(
                        child: IconButton(
                            // iconSize: 5,
                            icon: this.mailList[position].fav
                                ? Icon(Icons.star, color: Colors.yellow)
                                : Icon(Icons.star_border),
                                
                            onPressed: () {
                              setState(() {
                                this.mailList[position].fav =
                                    !this.mailList[position].fav;
                                updateFav(this.mailList[position]);
                              });
                            }),
                      ),
                    ],
                  ),
                  onTap: () {

                   showfavDetail(this.mailList[position]);
                  },
                ),
              );
        });
  }  

   void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDb();
    dbFuture.then((db) {
      Future<List<Mail>> mailListFuture = databaseHelper.getMailList();
      mailListFuture.then((newList) {
        setState(() {
          this.mailList = newList.where((element)=>element.fav==true).toList().reversed.toList();
          
          this.count = mailList.length;
        });
      });
    });
  }

  void updateFav(Mail mail) async {
    await databaseHelper.updateFav(mail);
    updateListView();
  }

  void showfavDetail(Mail mail) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MailDetail(mail);
    }));
    //updateListView();
  }
}