import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/email.dart';
import 'package:intl/intl.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String emails = 'emailsTable';
  String colSender = 'sender';
  String colId = 'id';
  String colRecepient = 'recepient';
  String colBody = 'body';
  String colDate = 'date';
  String colSubject = 'subject';
  String colFavourite = 'favourite';
  String colArchived = 'archive';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'emails.db';

    // Open/create the database at a given path
    var emailsDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return emailsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $emails ("
        "$colId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$colRecepient TEXT, "
        "$colSender TEXT, "
        "$colBody TEXT, "
        "$colDate TEXT, "
        "$colSubject TEXT, "
        "$colFavourite INTEGER, "
        "$colArchived INTEGER "
        ")");
  }

  Future<List<Map<String, dynamic>>> getEmailMapList() async {
    Database db = await this.database;

    var result = await db.query(emails,
        orderBy: '$colId DESC', where: '$colArchived = ?', whereArgs: [0]);
    return result;
  }

  Future<List<Map<String, dynamic>>> getFavouritesMapList() async {
    Database db = await this.database;

    var result = await db.query(emails,
        orderBy: '$colId DESC', where: '$colFavourite = ?', whereArgs: [1]);
    return result;
  }

  Future<List<Map<String, dynamic>>> getArchiveMapList() async {
    Database db = await this.database;

    var result = await db.query(emails,
        orderBy: '$colId DESC', where: '$colArchived = ?', whereArgs: [1]);
    return result;
  }

  Future<int> insertMail(Mail mail) async {
    Database db = await this.database;
    var result = await db.insert(emails, mail.toMap());
    return result;
  }

  Future<int> updateMail(Mail mail) async {
    var db = await this.database;
    var result = await db.update(emails, mail.toMap(),
        where: '$colId = ?', whereArgs: [mail.id]);
    return result;
  }

  Future<int> deleteMail(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $emails WHERE $colId = $id');
    return result;
  }

  Future<List<Mail>> getMailList() async {
    var mailMapList = await getEmailMapList(); // Get 'Map List' from database
    int count =
        mailMapList.length; // Count the number of map entries in db table

    List<Mail> mailList = List<Mail>();
    for (int i = 0; i < count; i++) {
      mailList.add(Mail.fromMapObject(mailMapList[i]));
    }

    return mailList;
  }

  Future<List<Mail>> getFavouriteList() async {
    var mailMapList =
        await getFavouritesMapList(); // Get 'Map List' from database
    int count =
        mailMapList.length; // Count the number of map entries in db table

    List<Mail> mailList = List<Mail>();
    for (int i = 0; i < count; i++) {
      mailList.add(Mail.fromMapObject(mailMapList[i]));
    }

    return mailList;
  }

  Future<List<Mail>> getArchiveList() async {
    var mailMapList = await getArchiveMapList(); // Get 'Map List' from database
    int count =
        mailMapList.length; // Count the number of map entries in db table

    List<Mail> mailList = List<Mail>();
    for (int i = 0; i < count; i++) {
      mailList.add(Mail.fromMapObject(mailMapList[i]));
    }

    return mailList;
  }
}

String dateformat(String date) {
  DateTime sent = DateTime.parse(date);
  if (sent.year < DateTime.now().year) {
    return DateFormat.yMd().format(sent);
  }
  Duration diff = DateTime.now().difference(sent);
  if (diff.inDays >= 1) {
    return DateFormat.MMMMd().format(sent);
  } else {
    return DateFormat.jm().format(sent);
  }
}
