import 'package:flutter/material.dart';
import './models/email.dart';
import './Emails/email_detail.dart';
import 'database/shared_preferences.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<Mail> _mails;
  CustomSearchDelegate(this._mails);

  SharedPreference preference = SharedPreference();

  Widget loadsuggestions() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return CircularProgressIndicator();
        } else if (projectSnap.data == null) return Container();
        return ListView.builder(
          itemBuilder: (context, index) {
            String data = projectSnap.data[index];
            return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
              padding: EdgeInsets.all(10.0),
              color: Colors.grey[200],
              child: GestureDetector(
                onTap: () {
                  query = data;
                },
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text(
                    data,
                    style: TextStyle(
                      fontSize: 20.0,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: projectSnap.data.length,
        );
      },
      future: getdata(),
    );
  }

  Future<List<String>> getdata() async {
    return await preference.getSuggestions();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: theme.primaryTextTheme.subtitle1.color)),
      primaryColor: theme.primaryColor,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.primaryTextTheme,
      textTheme: theme.textTheme.copyWith(
        headline6: theme.textTheme.headline6
            .copyWith(color: theme.primaryTextTheme.headline6.color),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query.isNotEmpty
          ? IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          : IconButton(
              icon: const Icon(Icons.mic),
              tooltip: 'Voice input',
              onPressed: () {
                this.query = '';
              },
            ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        this.close(context, update);
      },
    );
  }

  String update = 'false';
  @override
  Widget buildResults(BuildContext context) {
    final List<Mail> suggestions = query.isEmpty
        ? List<Mail>()
        : _mails
            .where((e) =>
                e.subject.toLowerCase().contains(query.toLowerCase()) ||
                e.body.toLowerCase().contains(query.toLowerCase()) ||
                e.recepient.toLowerCase().contains(query.toLowerCase()) ||
                e.sender.toLowerCase().contains(query.toLowerCase()))
            .toList();

    if (suggestions.isNotEmpty) preference.setSuggestions(query);

    return suggestions.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text.rich(
                  TextSpan(
                    text: " No ",
                    style: TextStyle(
                      color: Colors.black,
                      backgroundColor: Colors.redAccent,
                      fontSize: 25.0,
                    ),
                    children: [
                      TextSpan(
                        text: " Results ",
                        style: TextStyle(
                          color: Colors.red,
                          backgroundColor: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: " Found ",
                        style: TextStyle(
                          color: Colors.black,
                          backgroundColor: Colors.redAccent,
                          fontSize: 25.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.network(
                    "https://i.pinimg.com/originals/5d/35/e3/5d35e39988e3a183bdc3a9d2570d20a9.gif"),
              ],
            ),
          )
        : ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () async {
                String result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmailDetail(suggestions[index]),
                  ),
                );
                if (result == 'true')
                  update = 'true';
                else if (result == 'delete') {
                  update = 'true';
                  _mails.remove(suggestions[index]);
                  suggestions.removeAt(index);
                  showSuggestions(context);
                }
              },
              child: ListTile(
                leading: Icon(Icons.mail),
                title: Text(suggestions[index].recepient),
                subtitle: Text(suggestions[index].subject),
              ),
            ),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return loadsuggestions();
  }
}
