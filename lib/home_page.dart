import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:floating_search_bar/floating_search_bar.dart';

import './models/email.dart';
import './email_data.dart';
import './detailEmail.dart';
import './sendemail.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RandomColor _randomColor = RandomColor();
  final List<ColorHue> _hueType = <ColorHue>[
    ColorHue.green,
    ColorHue.red,
    ColorHue.pink,
    ColorHue.purple,
    ColorHue.blue,
    ColorHue.yellow,
    ColorHue.orange
  ];

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

  List<Email> _emails = EmailData;

  void selectEmail(BuildContext ctx, Email email) {
    Navigator.of(ctx).push(MaterialPageRoute(
      builder: (_) {
        return DetailEmail(email);
      },
    ));
  }

  void addemail(BuildContext ctx) {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return SendMail();
    }));
  }

  @override
  Widget build(BuildContext context) {
    print("jedf");
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.96,
              child: FloatingSearchBar.builder(
                itemCount: _emails.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(_emails[index].title),
                    onDismissed: (direction) {
                      // Remove the item from the data source.
                      setState(() {
                        _emails.removeAt(index);
                      });

                      // Then show a snackbar.
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("email successfully removed")));
                    },
                    // Show a red background as the item is swiped away.
                    background: Container(
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.all(20),
                              child: Icon(Icons.delete)),
                               Container(
                              padding: EdgeInsets.all(20),
                              child: Icon(Icons.delete))
                        ],
                      ),
                    ),
                    child: ListTile(
                      onTap: () {
                        selectEmail(context, _emails[index]);
                      },
                      contentPadding: EdgeInsets.all(5),
                      leading: CircleAvatar(
                        radius: 30,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        backgroundColor: _randomColor.randomColor(
                            colorHue: ColorHue.multiple(colorHues: _hueType),
                            colorBrightness: ColorBrightness.primary),
                      ),
                      title: Text(
                        'To:${_emails[index].username}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        ' ${_emails[index].title}\n ${_emails[index].content}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      isThreeLine: true,
                      trailing: Column(
                        
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            new DateFormat.MMMd().format(_emails[index].date),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            width: MediaQuery.of(context).size.width*0.08,
                            height: 15,
                            child: IconButton(
                              padding: new EdgeInsets.all(0.0),
                              icon: Icon(
                                Icons.star,
                                color: isSaved(_emails[index].id)
                                    ? Colors.amber
                                    : null,
                              ),
                              onPressed: () {
                                pressFavorite(_emails[index].id);
                              },
                              hoverColor: Colors.amber,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                trailing: CircleAvatar(
                  child: Text("RP"),
                ),
                drawer: Drawer(
                  child: Container(),
                ),
                onChanged: (String value) {},
                onTap: () {},
                decoration: InputDecoration.collapsed(
                  hintText: "Search...",
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 6,
        focusElevation: 6,
        backgroundColor: Colors.white,
        onPressed: () {
          addemail(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.lightBlue,
          size: 35,
        ),
      ),
    );
  }
}
