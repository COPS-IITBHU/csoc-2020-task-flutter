import 'package:flutter/material.dart';
import 'package:gmail_app/screens/after_search_screen.dart';

class MySearchAppBar extends PreferredSize {
  final BuildContext appBarContext;
  MySearchAppBar(this.appBarContext);

  @override
  Size get preferredSize => Size.fromHeight(0);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        left: 12.0,
        top: MediaQuery.of(context).padding.top+4,
        right: 16.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 5.0,
      child: LayoutBuilder(
        builder: (BuildContext context, constraints) {
          return Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: constraints.maxWidth * 0.15),
                child: TextField(
                  onSubmitted: (value) => search(value, appBarContext),
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Search"),
                ),
                width: constraints.maxWidth * (0.85),
              ),
              SizedBox(
                width: constraints.maxWidth * (0.15),
                child: CircleAvatar(
                  child: Text(
                    "P",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  backgroundColor: Colors.deepPurple[900],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void search(String value, BuildContext context) {
    //implement search function by renavigating to search screen
    Navigator.of(context).pushReplacementNamed(SearchList.navigator, arguments: value);
  }
  void navigateBack() {
    Navigator.pop(appBarContext);
  }
}
