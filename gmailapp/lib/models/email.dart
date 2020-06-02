import 'package:flutter/material.dart';

class Mail {
  Mail(
      {@required this.recepient,
      @required this.sender,
      @required this.date,
      this.body,
      this.subject,
      this.favourite,
      this.archive});

  Mail.withId(
      {@required this.id,
      @required this.recepient,
      @required this.sender,
      @required this.date,
      this.body,
      this.subject,
      this.favourite,
      this.archive});

  int id;
  String recepient;
  String sender;
  String body;
  String subject;
  String date;
  int favourite;
  int archive;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) map['id'] = id;

    map['recepient'] = recepient;
    map['sender'] = sender;
    map['body'] = body;
    map['date'] = date;
    map['subject'] = subject;
    map['favourite'] = favourite;
    map['archive'] = archive;
    return map;
  }

  Mail.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.recepient = map['recepient'];
    this.sender = map['sender'];
    this.body = map['body'];
    this.date = map['date'];
    this.subject = map['subject'];
    this.favourite = map['favourite'];
    this.archive = map['archive'];
  }
}
