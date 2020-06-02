import 'package:flutter/material.dart';
import 'package:gmail_app/providers/models.dart';
import 'package:gmail_app/screens/email_detail.dart';
import 'package:gmail_app/ui/avatar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EmailTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final email = Provider.of<Email>(context, listen: false);
    final username = email.to.split("@").first;
    final avatarLetter = username.substring(0, 1).toUpperCase();
    final date = DateFormat.MMMd().format(email.date).toString();

    return Container(
      padding: EdgeInsets.only(bottom: 12.0),
      //wrapping show that i can accesss the detail page of email after clicking on it
      child: GestureDetector(
        onTap: () {
          return Navigator.of(context)
              .pushNamed(EmailDetail.navigator, arguments: {"email": email});
        },
        child: Container(
          child: ListTile(
            leading: Column(
              children: <Widget>[
                CircleAvatar(
                  child: Text(
                    avatarLetter,
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  backgroundColor: AvatarBackgroundColor()
                      .getColor(avatarLetter.toLowerCase()),
                  radius: 20,
                )
              ],
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    username,
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                  child: Text(
                    email.subject,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.normal),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 2),
                  child: Text(
                    email.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.normal),
                  ),
                )
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Text(
                    date,
                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                ),
                Flexible(
                  child: Consumer<Email>(
                    builder: (BuildContext context, __, ___) {
                      return IconButton(
                        icon: (email.favorite)
                            ? Icon(
                                Icons.star,
                                color: Colors.amber,
                              )
                            : Icon(Icons.star_border),
                        onPressed: () => email.toggleFavorite(email),
                      );
                    },
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
