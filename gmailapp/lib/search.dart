import 'mail.dart';
import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate<Mail> {
  final List<Mail> _mails;
  List<Mail> _queryResults = [];
  CustomSearchDelegate(this._mails);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _queryResults = [];
    for (int i = 0; i < _mails.length && query != ''; i++) {
      if (_mails[i].content.toLowerCase().contains(query.toLowerCase()) ||
          _mails[i].subject.toLowerCase().contains(query.toLowerCase())) {
        _queryResults.add(_mails[i]);
      }
    }
    return ListView.builder(
      itemBuilder: _getTile,
      itemCount: _queryResults.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }

  Widget _getTile(BuildContext context, int index) {
    return ListTile(
      contentPadding: EdgeInsets.all(12.0),
      leading: CircleAvatar(
        backgroundImage: AssetImage("assets/images/avatar.jpg"),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Text(
              _queryResults[index].subject,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _queryResults[index].time,
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
            _queryResults[index].displayReceivers,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            _queryResults[index].displayContent,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )
        ],
      ),
      onTap: () => close(context, _queryResults[index]),
    );
  }
}
