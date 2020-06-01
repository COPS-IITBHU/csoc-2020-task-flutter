import 'dart:async';
import 'package:flutter/material.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:sqflite/sqflite.dart';
import '../compose/compose.dart';
import '../model/Email.dart';
import '../utils/database_helper.dart';
import './Search_bar.dart';
import './Floating_button.dart';
import '../email_description/email_description.dart';
import './DismissibleStyle.dart';
import './RouteTransition.dart';
import './Drawer.dart';

class Gmaillist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Gmaillist();
  }
}

class _Gmaillist extends State<Gmaillist> {
  Email email = Email('', '', '', '', '', 1, '');
  Databasehelper databasehelper = Databasehelper();
  List<Email> emaillist;
  int count = 0;

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    TextStyle titlestyle = Theme.of(context).textTheme.subtitle1;
    if (emaillist == null) {
      emaillist = List<Email>();
      updateemail();
    }

    return Scaffold(
        key: _scaffoldkey,
        body: Builder(
            builder: (context) => Container(
                margin: EdgeInsets.only(
                  top: 10.0,
                ),
                child: FloatingSearchBar.builder(
                  itemCount: count,
                  itemBuilder: (BuildContext context, int position) {
                    return Dismissible(
                      key: UniqueKey(),
                      background: Style(),
                      secondaryBackground: SecondStyle(),
                      onDismissed: (direction) {
                        _deleteEmail(context, this.emaillist[position]);
                      },
                      child: Card(
                        margin: EdgeInsets.only(
                            top: 1.0, bottom: 1.0, left: 10.0, right: 10.0),
                        elevation: 3.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(
                                int.parse(this.emaillist[position].color)),
                            child: Text(
                              this.emaillist[position].subject[0].toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                          title: Column(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(top: 5.0, bottom: 0),
                                  child: SizedBox(
                                    height: 25,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                            child: Text(
                                          ('To: ' +
                                              this
                                                  .emaillist[position]
                                                  .reciever
                                                  .split('@')[0]),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 18),
                                        )),
                                        Padding(
                                          padding: EdgeInsets.only(left: 3),
                                          child: Text(
                                            this
                                                .emaillist[position]
                                                .date
                                                .split(',')[0],
                                            style: titlestyle,
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.57,
                                    child: Text(
                                      this.emaillist[position].subject,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          subtitle: Container(
                            margin: EdgeInsets.only(bottom: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  this.emaillist[position].compose,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black54),
                                )),
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      star(position);
                                    },
                                    child: emaillist[position].star == 1
                                        ? Icon(Icons.star_border)
                                        : Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                          ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Icon ref = emaillist[position].star == 1
                                ? const Icon(Icons.star_border)
                                : const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  );
                            navigatetodescription(
                                this.emaillist[position], ref, context);
                          },
                        ),
                      ),
                    );
                  },
                  trailing: CircleAvatar(
                    backgroundImage: AssetImage('images/Yash.jpg'),
                  ),
                  drawer: Drawers(),
                  onTap: () async {
                    final searches = subjects();

                    Email result = await showSearch<Email>(
                      context: context,
                      delegate: Searchbar(searches),
                    );

                    if (result != null) {
                      navigatetodescription(
                          result,
                          result.star == 1
                              ? const Icon(Icons.star_border)
                              : const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                          context);
                    }

                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  decoration:
                      InputDecoration.collapsed(hintText: "Search mail"),
                ))),
        floatingActionButton: Container(
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            tooltip: 'Compose Email',
            child: CustomPaint(
              child: Container(),
              foregroundPainter: Floatingpainter(),
            ),
            onPressed: () {
              navigatetocompose(email);
            },
          ),
        ));
  }

  void navigatetocompose(Email email) async {
    var result =
        await Navigator.push(context, Transition(page: Compose(email)));

    if (result == true) {
      updateemail();
    }
  }

  void navigatetodescription(
      Email email, Icon icon, BuildContext context) async {
    var result = await Navigator.push(
        context, Transition(page: Description(email, icon)));
    if (result == 1) {
      updateemail();
    } else {
      updateemail();
      showsnackbar(context, 'Email deleted Successfully');
    }
  }

  void _deleteEmail(BuildContext context, Email email) async {
    int result = await databasehelper.deleteEmail(email.id);
    if (result != 0) {
      showsnackbar(context, 'Email deleted Successfully');
      updateemail();
    }
  }

  void star(int pos) async {
    if (this.emaillist[pos].star == 1) {
      this.emaillist[pos].star = 2;
      int result = await databasehelper.updateemail(emaillist[pos]);
      if (result != 0) {
        setState(() {});
      }
    } else {
      this.emaillist[pos].star = 1;
      int result = await databasehelper.updateemail(emaillist[pos]);
      if (result != 0) {
        setState(() {});
      }
    }
  }

  void showsnackbar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void updateemail() {
    final Future<Database> dbfuture = databasehelper.initializeDatabase();
    dbfuture.then((emailList) {
      Future<List<Email>> emailListFuture = databasehelper.getEmaillist();
      emailListFuture.then((emailList) {
        setState(() {
          this.emaillist = emailList;
          this.count = emailList.length;
        });
      });
    });
  }

  List<List<String>> subjects() {
    int count = emaillist.length;
    List<List<String>> searches = new List.generate(count, (i) => new List(2));

    for (int i = 0; i < count; i++) {
      searches[i][0] = this.emaillist[i].subject;
      searches[i][1] = this.emaillist[i].color;
    }
    return searches;
  }
}
