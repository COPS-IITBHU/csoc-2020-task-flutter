import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gmail17/data/AvatarColors.dart';
import 'package:gmail17/data/EmailData.dart';
import 'package:gmail17/ui/DetailPage.dart';
import 'package:gmail17/ui/HomePage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EmailListTile extends StatelessWidget {
  final EmailItem tileEmailData;
  final Function toggleFavCallback;
  final int index;
  EmailListTile({
    this.index,
    this.tileEmailData,
    this.toggleFavCallback,
  });
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        color: Colors.redAccent,
      ),
      key: UniqueKey(),
      onDismissed: (direction) {
        Provider.of<EmailData>(context, listen: false)
            .deleteEmail(tileEmailData);
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Deleted"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: InkWell(
          onTap: () {
            Provider.of<EmailData>(context, listen: false).read(index);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(
                  toggleFavCallback: toggleFavCallback,
                  index: index,
                  data: tileEmailData,
                ),
              ),
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: avatarColors[tileEmailData.colorIndex],
              child: Text(
                tileEmailData.avatar,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            title: Text(
              tileEmailData.recName,
              style: TextStyle(
                fontWeight:
                    Provider.of<EmailData>(context).defaultData[index].read
                        ? FontWeight.normal
                        : FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  tileEmailData.subject,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  tileEmailData.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
            trailing: Column(
              children: <Widget>[
                Text(getTileDate(tileEmailData.date)),
                Expanded(
                  child: IconButton(
                    onPressed: toggleFavCallback,
                    icon: Icon(
                      tileEmailData.fav ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String getTileDate(DateTime date) {
  if (date.difference(DateTime.now()).inHours > -24) {
    String min = date.minute.toString();
    if (date.minute < 10) min = "0" + min;
    return "${date.hour}:" + min;
  } else {
    return DateFormat("MMMM d").format(date);
  }
}
