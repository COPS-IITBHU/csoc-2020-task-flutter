import 'package:flutter/foundation.dart';

import 'database_helper.dart';

class Email extends ChangeNotifier {
  int id;
  String from;
  String to;
  String cc;
  String bcc;
  DateTime date;
  bool favorite = false;
  String subject;
  String body;

  Email(
      {this.id,
      @required this.from,
      @required this.to,
      this.cc,
      this.bcc,
      this.subject,
      this.body,
      @required this.date,
      this.favorite = false});

  int get getid => id;
  String get getfrom => from;
  String get getto => to;
  String get getcc => cc;
  String get getbcc => bcc;
  DateTime get getdate => date;
  bool get getfavorite => favorite;
  String get getsubject => subject;
  String get getbody => body;

  set setfrom(String newFrom) => (this.from = newFrom);
  set setto(String newto) => (this.from = newto);
  set setcc(String newcc) => (this.cc = newcc);
  set setbcc(String newbcc) => (this.from = newbcc);
  set setdate(DateTime newdate) => (this.date = newdate);
  set setfavorite(bool newfavorite) => (this.favorite = newfavorite);
  set setsubject(String newsubject) => (this.subject = newsubject);
  set setbody(String newbody) => (this.body = newbody);

  Future<bool> toggleFavorite(Email email) async {
    email.favorite = !(email.favorite);
    var result = await Emails().updateMail(email);
    if(result>0){
      notifyListeners();
      return true;
    }
    return false;
  }

  factory Email.fromMapObject(Map<String, dynamic> map) =>
      new Email(
        id: map['id'],
        from: map['FFrom'],
        to: map['TTo'],
        date: DateTime.parse(map['date']),
        subject: map['subject'],
        body: map['body'],
        cc: map['cc'],
        bcc: map['bcc'],
        favorite: (map['favorite']>0)?true:false,
      );
  
  Map<String,dynamic> toMap() {
    var map = Map<String, dynamic>();
    if(id != null){
      map['id'] = id;
    }
    map["FFrom"] = from;
    map["TTo"] = to;
    map["cc"] = cc;
    map["bcc"] = bcc;
    map["subject"] = subject;
    map["body"] = body;
    map["date"] = date.toIso8601String();
    map["favorite"] = favorite?1:0;
    return map;
  }
}
