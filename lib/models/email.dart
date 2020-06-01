import 'package:flutter/material.dart';

class Email {
  final String id;
  final String toSend;
  final String username;
  final String title;
  final DateTime date;
  final String content;

  const Email({
    @required this.id,
    @required this.toSend,
    @required this.username,
    @required this.title,
    @required this.date,
    @required this.content,
  });
}
