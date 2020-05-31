import 'package:flutter/material.dart';
import 'package:gmail17/data/EmailData.dart';
import 'package:gmail17/ui/EmailList.dart';
import 'package:gmail17/ui/EmailListTile.dart';
import 'package:gmail17/ui/FloatAppBar.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  final String text;
  SearchPage(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: FloatAppBar(text, true),
          body: SearchPageEmailList(text),
        ),
      ),
    );
  }
}

class SearchPageEmailList extends StatefulWidget {
  String text;
  SearchPageEmailList(this.text);
  @override
  _SearchPageEmailListState createState() => _SearchPageEmailListState();
}

class _SearchPageEmailListState extends State<SearchPageEmailList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EmailData>(
      builder: (context, data, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            if (foundIn(data.defaultData[index], widget.text)) {
              return EmailListTile(
                index: index,
                tileEmailData: data.defaultData[index],
                toggleFavCallback: () =>
                    data.toggleFav(data.defaultData[index]),
              );
            }
            return null;
          },
          itemCount: data.defaultData.length,
        );
      },
    );
  }
}

bool foundIn(EmailItem item, String text) {
  String txt = text.toLowerCase();
  return item.subject.toLowerCase().contains(txt) ||
      item.description.toLowerCase().contains(txt) ||
      item.recEmail.toLowerCase().contains(txt) ||
      item.recName.toLowerCase().contains(txt);
}
