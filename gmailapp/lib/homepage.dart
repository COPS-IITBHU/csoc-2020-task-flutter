import 'package:flutter/material.dart';
import 'mail.dart';
import 'search.dart';

class MailHomeList extends StatefulWidget {
  @override
  _MailHomeListState createState() => _MailHomeListState();
}

class _MailHomeListState extends State<MailHomeList> {
  List<Mail> _mails = [];
  final MailDatabaseHelper mailDatabaseHelper = MailDatabaseHelper();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> retrieveMails() async {
    _mails = await mailDatabaseHelper.getMails();
    setState(() {});
  }

  Future<void> deleteMailAt(int index) async {
    String message = "Deleted Successfully";
    try {
      await mailDatabaseHelper.deleteMail(_mails[index].id);
      _mails.removeAt(index);
    } catch (e) {
      print('error : $e');
      message = "Error Occurred! Unable to Delete";
    } finally {
      setState(() {});
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    retrieveMails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            title: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0, 0.5),
                    blurRadius: 2.5,
                    spreadRadius: 0.0,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                dense: true,
                leading: Icon(Icons.dehaze),
                title: Text(
                  "Search in emails",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/avatar.jpg'),
                ),
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(this._mails),
                  ).then(
                    (mail) => mail != null
                        ? viewMail(_mails
                            .indexWhere((element) => mail.id == element.id))
                        : null,
                  );
                },
              ),
            ),
            centerTitle: true,
          ),
          SliverList(
            delegate: _mails.length > 0
                ? (SliverChildBuilderDelegate(
                    (context, index) => _getTile(index),
                    childCount: _mails.length))
                : SliverChildListDelegate([
                    Image(
                      image: AssetImage("assets/images/duck.jpg"),
                    ),
                    Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "No Mails",
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.center,
                        ))
                  ]),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 40.0,
        ),
        onPressed: composeMail,
      ),
    );
  }

  Widget _avatar = CircleAvatar(
    backgroundImage: AssetImage('assets/images/avatar.jpg'),
  );

  Widget _dismissibleBackground = Container(
    color: Colors.red,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Icon(Icons.delete_outline),
        Icon(Icons.delete_outline),
      ],
    ),
  );

  Widget _getTile(int index) {
    return Dismissible(
      key: Key(_mails[index].id.toString()),
      background: _dismissibleBackground,
      child: ListTile(
        contentPadding: EdgeInsets.all(12.0),
        leading: _avatar,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Text(
                _mails[index].subject,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                _mails[index].time,
                textScaleFactor: 0.8,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _mails[index].displayReceivers,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _mails[index].displayContent,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          ],
        ),
        onTap: () => viewMail(index),
      ),
      onDismissed: (direction) => deleteMailAt(index),
    );
  }

  Future<void> composeMail() async {
    final mail = await Navigator.of(context).pushNamed('/compose');
    if (mail != null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Mail Sent."),
        ),
      );
      this.setState(() {
        this._mails.insert(0, mail);
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Mail Discarded."),
        ),
      );
    }
  }

  viewMail(int index) async {
    var res = await Navigator.of(context)
        .pushNamed('/detail', arguments: _mails[index]);
    if (res == true) {
      deleteMailAt(index);
    }
  }
}
