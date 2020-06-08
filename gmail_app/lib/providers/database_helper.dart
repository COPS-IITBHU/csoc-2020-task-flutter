import 'dart:io';
import 'dart:async';
import 'models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class Emails with ChangeNotifier {
  String mailTable = 'mailTable';
  String colId = 'id';
  String colFrom = 'FFrom';
  String colTo = 'TTo';
  String colCc = 'cc';
  String colBcc = 'bcc';
  String colDate = 'date';
  String colSubject = 'subject';
  String colBody = 'body';
  String colFavorite = 'favorite';

  Future<List<Email>> get emails async {
    return await getAllMails();
  }

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "email.db");
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $mailTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colFrom TEXT,$colTo TEXT,$colCc TEXT,$colBcc TEXT,$colSubject TEXT,$colBody TEXT,$colDate TEXT,$colFavorite INT)');
  }

  Future<int> insertMail(Map<String,dynamic> emailMap) async {
    Database db = await this.database;
    int result = await db.insert(mailTable, emailMap,conflictAlgorithm: ConflictAlgorithm.ignore);
    notifyListeners();
    return result;
  }

  Future<int> updateMail(Email email) async {
    Database db = await this.database;
    int result = await db.update(mailTable, email.toMap(),
        where: '$colId = ?', whereArgs: [email.id]);
    notifyListeners();
    return result;
  }

  Future<int> deleteMail(int id) async {
    Database db = await this.database;
    debugPrint("from delete function: "+id.toString());
    int result =
        await db.rawDelete('DELETE FROM $mailTable WHERE $colId = $id');
    notifyListeners();
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $mailTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Map<String, dynamic>>> getMailMapList() async {
    Database db = await this.database;
    var result = await db.query(mailTable, orderBy: '$colId ASC');
    return result.reversed.toList();
  }

  Future<List<Email>> getAllMails() async {
    var mailMapList = await getMailMapList();
    int count = mailMapList.length;
    debugPrint("mailMapList count = $count.toString()");
    List<Email> mailList = List<Email>();

    for (int i = 0; i < count; i++) {
      mailList.add(Email.fromMapObject(mailMapList[i]));
    }
    return mailList;
  }
}
