import 'package:flutter/material.dart';

class Mail {
  Mail(
      {@required this.recepient,
      @required this.date,
      this.body,
      this.subject,
      this.favourite});

  Mail.withId(
      {@required this.id,
      @required this.recepient,
      @required this.date,
      this.body,
      this.subject,
      this.favourite});

  int id;
  String recepient;
  String body;
  String subject;
  String date;
  int favourite;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) map['id'] = id;

    map['recepient'] = recepient;
    map['body'] = body;
    map['date'] = date;
    map['subject'] = subject;
    map['favourite'] = favourite;
    return map;
  }

  Mail.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.recepient = map['recepient'];
    this.body = map['body'];
    this.date = map['date'];
    this.subject = map['subject'];
    this.favourite = map['favourite'];
  }
}
