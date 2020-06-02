import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:math';

class Mail {
  int id;
  String subject;
  List<String> receiver;
  List<String> cc;
  List<String> bcc;
  String content;
  DateTime created;

  Mail({
    @required String sub,
    @required String receivers,
    @required String content,
    @required String created,
    String carbonCopy,
    String blindCarbonCopy,
  }) {
    this.subject = sub;
    this.content = content;
    this.created = DateTime.parse(created);
    this.receiver =
        receivers.split(',').map((element) => element.trim()).toList();
    if (carbonCopy != null) {
      this.cc = carbonCopy.split(',').map((element) => element.trim()).toList();
    } else {
      this.cc = [];
    }
    if (blindCarbonCopy != null) {
      this.bcc =
          blindCarbonCopy.split(',').map((element) => element.trim()).toList();
    } else {
      this.bcc = [];
    }
  }
  Map<String, dynamic> toMap() {
    return {
      'subject': this.subject,
      'receiver': this.receiver.join(','),
      'content': this.content,
      'created': this.created.toIso8601String(),
      'cc': this.cc.join(','),
      'bcc': this.bcc.join(','),
    };
  }

  String get time {
    if (DateTime.now().difference(created).inDays >= 1) {
      return DateFormat.MMMd().format(created);
    }
    return DateFormat.jm().format(created);
  }

  String get displayContent {
    return content.substring(0, min(50, content.length)).replaceAll('\n', ' ');
  }

  String get displayReceivers {
    return receiver.join(', ');
  }

  String get displayCC {
    return cc.join(', ');
  }

  String get displayBCC {
    return bcc.join(', ');
  }
}

class MailDatabaseHelper {
  MailDatabaseHelper._privateConstructor();
  static final MailDatabaseHelper _instance =
      MailDatabaseHelper._privateConstructor();

  factory MailDatabaseHelper() => _instance;

  Future<Database> get database async {
    return openDatabase(
      join(await getDatabasesPath(), 'mail_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE mails('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'created DATETIME NOT NULL, '
          'subject TEXT, '
          'receiver TEXT, '
          'cc TEXT, '
          'bcc TEXT,'
          'content TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> saveMail(Mail mail) async {
    final Database db = await database;
    await db.insert(
      'mails',
      mail.toMap(),
    );
  }

  Future<void> updateMail(int id, Mail mail) async {
    final Database db = await database;
    await db.update(
      'mails',
      mail.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Mail> getMail(int id) async {
    final Database db = await database;
    List<Map<String, dynamic>> rows = await db.query(
      'mails',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rows.length > 0) {
      var mail = Mail(
        sub: rows[0]['subject'],
        receivers: rows[0]['receiver'],
        content: rows[0]['content'],
        created: rows[0]['created'],
        carbonCopy: rows[0]['cc'],
        blindCarbonCopy: rows[0]['bcc'],
      );
      mail.id = rows[0]['id'];
      return mail;
    } else
      return null;
  }

  Future<List<Mail>> getMails() async {
    final Database db = await database;
    List<Map<String, dynamic>> rows = await db.query(
      'mails',
      orderBy: 'created desc',
    );
    List<Mail> mails = List.generate(
      rows.length,
      (index) {
        var mail = Mail(
          sub: rows[index]['subject'],
          receivers: rows[index]['receiver'],
          content: rows[index]['content'],
          created: rows[index]['created'],
          carbonCopy: rows[index]['cc'],
          blindCarbonCopy: rows[index]['bcc'],
        );
        mail.id = rows[index]['id'];
        return mail;
      },
    );

    return mails;
  }

  Future<void> deleteMail(int id) async {
    final Database db = await database;
    db.delete(
      'mails',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
