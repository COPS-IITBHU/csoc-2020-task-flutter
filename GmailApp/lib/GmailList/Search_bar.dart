import 'package:flutter/material.dart';
import '../model/Email.dart';
import '../utils/database_helper.dart';

class Searchbar extends SearchDelegate<Email> {
  List<List<String>> search;

  Searchbar(this.search);

  Databasehelper databasehelper = Databasehelper();
  Email email;
  List<Email> ref = [];
  List<String> recentsearch = [];
  BuildContext context;

  Future<List> _query(query) async {
    final row = await databasehelper.getitem(query);
    row.forEach((row) => ref.add(Email.fromMapObject(row)));
    return ref;
  }

  @override
  String get searchFieldLabel => 'Search by Subject';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          Navigator.pop(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    void navigatetodescription(ourquery) async {
      await _query(ourquery);
      List<Email> email;

      email = ref.where((element) => element.subject == ourquery).toList();
      navigate(context, email);
    }

    final suggestions =
        search.where((searching) => searching[0].startsWith(query)).toList();

    if (query.isEmpty) {
      return Container();
    } else {
      if (suggestions.isEmpty) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset('images/Noresult.jpg'),
        );
      } else {
        return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.only(top: 10),
                  child: ListTile(
                      onTap: () {
                        this.query = suggestions[index][0];
                        navigatetodescription(this.query);
                      },
                      leading: CircleAvatar(
                        backgroundColor:
                            Color(int.parse(suggestions[index][1])),
                        child: Text(
                          suggestions[index][0][0].toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                      title: Text(
                        suggestions[index][0],
                        style: TextStyle(fontSize: 20),
                      )),
                ));
      }
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    void navigatetodescription(ourquery) async {
      await _query(ourquery);
      List<Email> email;

      email = ref.where((element) => element.subject == ourquery).toList();

      navigate(context, email);
    }

    final suggestions =
        search.where((searching) => searching[0].contains(query)).toList();

    if (query.isEmpty) {
      return Container();
    } else {
      if (suggestions.isEmpty) {
        return Center(
          child: Text("No Matching Email for '$query'"),
        );
      } else {
        return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.only(top: 10),
                  child: ListTile(
                      onTap: () {
                        this.query = suggestions[index][0];
                        navigatetodescription(this.query);
                      },
                      leading: CircleAvatar(
                        backgroundColor:
                            Color(int.parse(suggestions[index][1])),
                        child: Text(
                          suggestions[index][0][0].toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                      title: Text(
                        suggestions[index][0],
                        style: TextStyle(fontSize: 20),
                      )),
                ));
      }
    }
  }

  void navigate(BuildContext context, List<Email> email) async {
    close(context, email[0]);
  }
}
