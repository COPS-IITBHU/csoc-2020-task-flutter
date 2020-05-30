import 'package:flutter/material.dart';
import './models/email.dart';
import './Emails/email_detail.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<Mail> _mails;
  CustomSearchDelegate(this._mails);

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
        this.close(context, null);
      },
    );
  }

  bool update = false;
  @override
  Widget buildResults(BuildContext context) {
    final List<Mail> suggestions = query.isEmpty
        ? List<Mail>()
        : _mails
            .where((e) =>
                e.subject.contains(query) ||
                e.body.contains(query) ||
                e.recepient.contains(query))
            .toList();

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
                bool result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmailDetail(suggestions[index]),
                  ),
                );
                if (result == true) update = true;
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
    return Container();
  }
}
