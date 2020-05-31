import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../model/Email.dart';

class Databasehelper {
  static Databasehelper _databasehelper;
  static Database _database;
  Databasehelper._createinstance();

  String emailTable = 'email_table';
  String emailid = 'id';
  String emailsender = 'sender';
  String emailreciever = 'reciever';
  String emailsubject = 'subject';
  String emailcompose = 'compose';
  String emaildate = 'date';
  String emailstar = 'star';
  String color = 'color';

  factory Databasehelper() {
    if (_databasehelper == null) {
      _databasehelper = Databasehelper._createinstance();
    }
    return _databasehelper;
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

    var database = await openDatabase(path, version: 1, onCreate: _createDb);
    return database;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $emailTable($emailid INTEGER PRIMARY KEY AUTOINCREMENT, $emailsender TEXT, $emailreciever TEXT, $emailsubject TEXT, $emailcompose TEXT, $emaildate TEXT, $emailstar INTEGER, $color TEXT)');
  }

  Future<List<Map<String, dynamic>>> getEmailMapList() async {
    Database db = await this.database;

    var emails = await db.query(emailTable, orderBy: '$emailid DESC');
    return emails;
  }

  Future<List<Map<String, dynamic>>> getitem(String sub) async {
    Database db = await this.database;
    var ref = await db.query(emailTable, where: "$emailsubject LIKE '%$sub%'");

    return ref;
  }

  Future<int> insertEmail(Email email) async {
    Database db = await this.database;
    var emails = await db.insert(emailTable, email.toMap());
    return emails;
  }

  Future<int> deleteEmail(int id) async {
    var db = await this.database;
    int email =
        await db.rawDelete('DELETE FROM $emailTable WHERE $emailid = $id');
    return email;
  }

  Future<int> updateemail(Email email) async {
    var db = await this.database;
    var result = await db.update(emailTable, email.toMap(),
        where: '$emailid = ?', whereArgs: [email.id]);
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.query(emailTable);
    int numberofemails = Sqflite.firstIntValue(x);
    return numberofemails;
  }

  Future<List<Email>> getEmaillist() async {
    var emailmaplist = await getEmailMapList();
    int count = emailmaplist.length;
    List<Email> emailList = List<Email>();

    for (int i = 0; i < count; i++) {
      emailList.add(Email.fromMapObject(emailmaplist[i]));
    }
    return emailList;
  }
}
