import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gmail17/data/AvatarColors.dart';
import 'package:gmail17/data/EmailData.dart';
import 'package:gmail17/ui/EmailListTile.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final int index;
  final Function toggleFavCallback;
  final EmailItem data;
  DetailPage({
    this.index,
    this.toggleFavCallback,
    this.data,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool shown = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.archive),
          ),
          IconButton(
            onPressed: () {
              Provider.of<EmailData>(context, listen: false)
                  .deleteEmail(widget.data);
              Navigator.pop(context);
            },
            icon: Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.markunread,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                  child: Text(
                    widget.data.subject,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.toggleFavCallback,
                icon: Icon(Provider.of<EmailData>(context)
                        .defaultData[widget.index]
                        .fav
                    ? Icons.star
                    : Icons.star_border),
                color: Colors.amber,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: avatarColors[widget.data.colorIndex],
                  child: Text(widget.data.avatar),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.data.sender == ""
                            ? widget.data.recName
                            : "Shreyansh",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text("to " +
                              (widget.data.sender == ""
                                  ? "Me"
                                  : widget.data.recName)),
                          IconButton(
                            icon: shown
                                ? Icon(Icons.keyboard_arrow_up)
                                : Icon(Icons.keyboard_arrow_down),
                            iconSize: 20,
                            onPressed: () {
                              setState(() {
                                shown = !shown;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Text(getTileDate(widget.data.date)),
              ),
              Icon(Icons.reply),
              Icon(Icons.more_vert),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          shown
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                    width: 40,
                                    child: Text(
                                      "From",
                                      style: TextStyle(color: Colors.grey),
                                    )),
                                Text(
                                    widget.data.sender == ""
                                        ? widget.data.recEmail
                                        : myEmail,
                                    style:
                                        TextStyle(color: Colors.grey.shade700)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 40,
                                  child: Text("To",
                                      style: TextStyle(color: Colors.grey)),
                                ),
                                Text(
                                    widget.data.sender == ""
                                        ? myEmail
                                        : widget.data.recEmail,
                                    style:
                                        TextStyle(color: Colors.grey.shade700)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                    width: 40,
                                    child: Text("Date",
                                        style: TextStyle(color: Colors.grey))),
                                Text(
                                  DateFormat.yMd()
                                      .add_jm()
                                      .format(widget.data.date),
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.lock_outline,
                                  color: Colors.grey.shade400,
                                  size: 20,
                                ),
                                Text("Standard Encryption(TLS)",
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.data.recEmail == "anonymous@secret.com"
                  ? Image.asset("assets/rickroll.webp")
                  : Text(
                      widget.data.description,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15),
                    ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlineButton(
                    onPressed: null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(Icons.reply),
                        Text("Reply"),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlineButton(
                    onPressed: null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(Icons.reply_all),
                        Text("Reply All"),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlineButton(
                    onPressed: null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(Icons.forward),
                        Text("Forward"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
