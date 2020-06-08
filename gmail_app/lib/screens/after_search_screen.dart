import 'package:flutter/material.dart';
import 'package:gmail_app/providers/database_helper.dart';
import 'package:gmail_app/providers/models.dart';
import 'package:gmail_app/widgets/appbar_searchscreen.dart';
import 'package:gmail_app/widgets/swipe_disable.dart';
import 'package:gmail_app/widgets/tile.dart';
import 'package:provider/provider.dart';

class SearchList extends StatefulWidget {
  static final navigator = "/after_search_screen";
  @override
  State<StatefulWidget> createState() {
    return _SearchListState();
  }
}

class _SearchListState extends State<SearchList> {
  Future<List<Email>> emailList;

  @override
  Widget build(BuildContext context) {
    final emails = Provider.of<Emails>(context, listen: false);
    String value = ModalRoute.of(context).settings.arguments as String;
    debugPrint("value = $value");
    emailList = toShow(emails, value.toLowerCase());

    return SwipeDisablerWidget(
      child: FutureBuilder<List<Email>>(
        future: emailList,
        builder: (context, AsyncSnapshot<List<Email>> ajaxQuery) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Scrollbar(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    floating: true,
                    backgroundColor: Colors.transparent,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(5.0),
                      child: SizedBox(),
                    ),
                    flexibleSpace: MySearchAppBar(context),
                  ),
                  SliverToBoxAdapter(
                    child: (ajaxQuery.hasData && ajaxQuery.data.isEmpty)
                        ? Container(
                            height: 0.0,
                            width: 0.0,
                          )
                        : Container(
                            margin: EdgeInsets.all(8.0),
                            child: Text(
                              "Sent",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                  ),

                  //check if the data has been fetched

                  (ajaxQuery.hasData)
                      ? (ajaxQuery.data.isEmpty)
                          ? SliverToBoxAdapter(
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).padding.top +
                                        170.0,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Image(
                                        image: AssetImage(
                                            "assets/images/noresultsfound.jpg"),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          "No results",
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, index) {
                                return ChangeNotifierProvider.value(
                                  value: ajaxQuery.data[index],
                                  //so that i can delete by swiping
                                  child: Dismissible(
                                    key: UniqueKey(),
                                    child: EmailTile(),
                                    background: Container(
                                      alignment: Alignment.centerLeft,
                                      color: Colors.greenAccent[700],
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.delete_sweep,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    secondaryBackground: Container(
                                      alignment: Alignment.centerRight,
                                      color: Colors.greenAccent[700],
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.delete_sweep,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onDismissed: (_) async {
                                      //make snackbar for showing after deleting the mail
                                      int id = ajaxQuery.data[index].id;
                                      ajaxQuery.data.removeAt(index);
                                      int result = await emails.deleteMail(id);
                                      if (result > 0) {
                                        _showSnackBar(context,
                                            "Email deleted successfully");
                                      }
                                    },
                                  ),
                                );
                              }, childCount: ajaxQuery.data.length),
                            )
                      : SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<Email>> toShow(Emails mails, String value) async {
    final allemails = await mails.getAllMails();

    return allemails.where((element) {
      return element.to.toLowerCase().contains(value) ||
          element.from.toLowerCase().contains(value) ||
          element.cc.toLowerCase().contains(value) ||
          element.bcc.toLowerCase().contains(value) ||
          element.subject.toLowerCase().contains(value) ||
          element.body.toLowerCase().contains(value);
    }).toList();
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
