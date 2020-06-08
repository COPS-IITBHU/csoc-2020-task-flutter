import 'package:flutter/material.dart';
import 'mail.dart';

class DetailView extends StatefulWidget {
  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  bool arrowDown = true;
  List<TableRow> _tableRows(Mail mail) {
    var ret = [
      TableRow(
        children: <Widget>[
          Text(
            "From",
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("Me"),
          ),
        ],
      ),
      TableRow(
        children: <Widget>[
          Text(
            "To",
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(mail.displayReceivers),
          ),
        ],
      ),
      TableRow(
        children: <Widget>[
          Text(
            "Date",
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
          Text(mail.time),
        ],
      ),
    ];
    if (mail.displayCC != '') {
      ret.insert(
        2,
        TableRow(
          children: <Widget>[
            Text(
              "CC",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(mail.displayCC),
            ),
          ],
        ),
      );
    }
    if (mail.displayBCC != '') {
      ret.insert(
        2,
        TableRow(
          children: <Widget>[
            Text(
              "BCC",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(mail.displayBCC),
            ),
          ],
        ),
      );
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    final Mail mail = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        elevation: 1.5,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete_outline,
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              mail.subject,
              style: TextStyle(),
              textScaleFactor: 1.7,
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.jpg'),
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Text(
                    "Me",
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    mail.time,
                    textAlign: TextAlign.end,
                    textScaleFactor: 0.7,
                  ),
                )
              ],
            ),
            subtitle: Text(
              "to " + mail.displayReceivers,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
              softWrap: false,
            ),
            trailing: IconButton(
              icon: Icon(arrowDown
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_up),
              onPressed: () {
                setState(() {
                  arrowDown = !arrowDown;
                });
              },
            ),
          ),
          Visibility(
            visible: !arrowDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.top,
                  columnWidths: {0: FixedColumnWidth(50.0)},
                  children: _tableRows(mail),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                    color: Colors.black12,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(mail.content),
          ),
        ],
      ),
    );
  }
}
