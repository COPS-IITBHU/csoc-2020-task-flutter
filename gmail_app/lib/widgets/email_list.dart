import 'package:flutter/material.dart';
import 'package:gmail_app/providers/database_helper.dart';
import 'package:gmail_app/providers/models.dart';
import 'package:gmail_app/widgets/my_app_bar.dart';
import 'package:gmail_app/widgets/tile.dart';
import 'package:provider/provider.dart';

class EmailList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EmailListState();
  }
}

class _EmailListState extends State<EmailList> {
  @override
  Widget build(BuildContext context) {
    final emails = Provider.of<Emails>(context);
    return FutureBuilder(
      future: emails.getAllMails(),
      builder: (context, AsyncSnapshot<List<Email>> ajaxQuery) {
        return Scrollbar(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(5.0),
                  child: SizedBox(),
                ),
                flexibleSpace: MyAppBar(context),
              ),
              SliverToBoxAdapter(
                child: ajaxQuery.hasData
                    ? ajaxQuery.data.length > 0
                        ? Container(
                            margin: EdgeInsets.all(12.0),
                            child: Text(
                              "Sent",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : Container(
                            height: 0.0,
                            width: 0.0,
                          )
                    : Container(
                        width: 0.0,
                        height: 0.0,
                      ),
              ),

              //check if the data has been fetched otherwise show a image with some text.

              (ajaxQuery.hasData)
                  ? ajaxQuery.data.length > 0
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, index) {
                            return ChangeNotifierProvider.value(
                              value: ajaxQuery.data[index],
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
                                  //remember to make a global function for it
                                  int id = ajaxQuery.data[index].id;
                                  ajaxQuery.data.removeAt(index);
                                  int result = await emails.deleteMail(id);
                                  if (result > 0) {
                                    _showSnackBar(
                                        context, "Email deleted successfully");
                                  }
                                  debugPrint(
                                      "from List page: " + result.toString());
                                },
                              ),
                            );
                          }, childCount: ajaxQuery.data.length),
                        )
                      : SliverFillRemaining(
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top + 160,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Flexible(
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/outbox_empty.png"),
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "No mails in your sent list.",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        "Consider adding one by sending \"hi\" to your friends.",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                  : SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
