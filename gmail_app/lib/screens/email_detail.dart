import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:gmail_app/providers/database_helper.dart';
import 'package:gmail_app/providers/models.dart';
import 'package:gmail_app/ui/avatar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EmailDetail extends StatefulWidget {
  static String navigator = "/email_detail";
  @override
  State<StatefulWidget> createState() {
    return _EmailDetailState();
  }
}

class _EmailDetailState extends State<EmailDetail> {
  @override
  void initState() {
    super.initState();
  }

  bool extra = false;
  @override
  Widget build(BuildContext context) {
    final mapData =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final emails = Provider.of<Emails>(context, listen: false);
    debugPrint(mapData.toString());
    final email = mapData["email"] as Email;
    final to = email.to;
    final from = email.from;
    final cc = email.cc;
    final bcc = email.bcc;
    final subject = email.subject;
    final body = email.body;
    final date = DateFormat.MMMd().format(email.date).toString();
    var favorite = email.favorite;
    final String avatarLetter = from.substring(0, 1).toUpperCase();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.archive),
            onPressed: () {},
          ),
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                //debugPrint("hi "+id.toString());
                int result = await emails.deleteMail(email.id);
                if (result != 0) {
                  Navigator.pop(context, true);
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.mail_outline),
            onPressed: () {},
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(value: 1, child: Text("Snooze")),
              PopupMenuItem(value: 2, child: Text("Change labels")),
              PopupMenuItem(value: 3, child: Text("Mark not important")),
              PopupMenuItem(value: 4, child: Text("Mute")),
              PopupMenuItem(value: 5, child: Text("Print")),
              PopupMenuItem(
                value: 6,
                child: Text(
                  "Report spam",
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
              PopupMenuItem(value: 7, child: Text("Add to Tasks")),
            ],
          ),
        ],
      ),
      body: Scrollbar(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 12.0, bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          subject,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.values[4],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: (favorite)
                            ? Icon(
                                Icons.star,
                                color: Colors.amber,
                              )
                            : Icon(Icons.star_border),
                        onPressed: () async {
                          await email.toggleFavorite(email);
                          setState(
                            () {
                              favorite = !favorite;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  ConfigurableExpansionTile(
                    initiallyExpanded: true,
                    header: Container(
                      padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(
                              child: CircleAvatar(
                                radius: 20.0,
                                backgroundColor: AvatarBackgroundColor()
                                    .getColor(avatarLetter.toLowerCase()),
                                child: Text(
                                  avatarLetter,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      width: 235.0,
                                      child: Text(
                                        from,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .copyWith(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      width: 235.0,
                                      child: Text(
                                        body,
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                fontSize: 16.0,
                                                color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              date,
                            )
                          ]),
                    ),
                    headerBackgroundColorStart: Colors.transparent,
                    headerExpanded: Container(
                      padding: EdgeInsets.all(4.0),
                      margin: EdgeInsets.only(
                        bottom: 6.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              child: CircleAvatar(
                                radius: 20.0,
                                backgroundColor: AvatarBackgroundColor()
                                    .getColor(avatarLetter.toLowerCase()),
                                child: Text(
                                  avatarLetter,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    width: 120.0,
                                    child: Text(
                                      from,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Container(
                                          width: 120.0,
                                          child: Text(
                                            "to $to",
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    fontSize: 16.0,
                                                    color: Colors.grey),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(
                                            () {
                                              this.extra = !this.extra;
                                            },
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.expand_more),
                                        onPressed: () {
                                          setState(
                                            () {
                                              this.extra = !this.extra;
                                              debugPrint(
                                                  "Expand_more button pressed " +
                                                      this.extra.toString());
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                DateFormat.yMMMd()
                                    .format(email.date)
                                    .toString(),
                                style: TextStyle(fontSize: 10.0),
                              ),
                              IconButton(
                                icon: Icon(Icons.reply),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(value: 1, child: Text("Reply all")),
                              PopupMenuItem(value: 2, child: Text("Forward")),
                              PopupMenuItem(value: 3, child: Text("Add Star")),
                              PopupMenuItem(value: 4, child: Text("Print")),
                            ],
                          ),
                        ],
                      ),
                    ),
                    children: <Widget>[
                      Container(
                        height: 6.0,
                      ),
                      (this.extra)
                          ? Column(
                              children: <Widget>[
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.grey[400]),
                                  ),
                                  elevation: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(6.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              width: 60,
                                              child: Text(
                                                "From:",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(from),
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 8.0,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              width: 60,
                                              child: Text(
                                                "To:",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(to),
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 8.0,
                                        ),
                                        (cc.length > 0)
                                            ? Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width: 60,
                                                        child: Text(
                                                          "Cc:",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .subtitle2,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(cc),
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 8.0,
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                width: 0.0,
                                                height: 0.0,
                                              ),
                                        //not included bcc field here beacause bcc is not shown in headers
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              width: 60,
                                              child: Text(
                                                "Date:",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(date),
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 8.0,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              width: 60,
                                              child: Icon(Icons.lock_outline,size: 20.0,),
                                              alignment: AlignmentDirectional
                                                  .centerStart,
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Security Encryption (TLS).",
                                                textAlign: TextAlign.left,
                                              ),
                                            )
                                          ],
                                        ),
                                        Text(
                                          "See security details",
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 6.0,
                                ),
                              ],
                            )
                          : Container(
                              width: 0.0,
                              height: 0.0,
                            ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 8.0,
                        ),
                        child: Text(
                          body,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10.0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.reply,
              color: Colors.grey[700],
            ),
            title: Text(
              "Reply",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15.0,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.reply_all,
              color: Colors.grey[700],
            ),
            title: Text(
              "Reply all",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15.0,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.redo,
              color: Colors.grey[700],
            ),
            title: Text(
              "Forward",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
