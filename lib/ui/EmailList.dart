import 'package:flutter/material.dart';
import 'package:gmail17/data/EmailData.dart';
import 'package:gmail17/ui/EmailListTile.dart';
import 'package:provider/provider.dart';

class EmailList extends StatefulWidget {
  @override
  _EmailListState createState() => _EmailListState();
}

class _EmailListState extends State<EmailList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EmailData>(
      builder: (context, data, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return EmailListTile(
              index: index,
              tileEmailData: data.defaultData[index],
              toggleFavCallback: () => data.toggleFav(data.defaultData[index]),
            );
          },
          itemCount: data.defaultData.length,
        );
      },
    );
  }
}
