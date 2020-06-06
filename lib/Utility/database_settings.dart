import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../Models/maildb.dart';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper;
  static Database _database;
  String mailTable='mail_table';
  String colId='id';
  String colSender='sender';
  String colRecepient='recepient';
  String colSubject='subject';
  String colMail='mail';
  String colDate='date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if(_databaseHelper==null){
      _databaseHelper= DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if (_database==null){
      _database= await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async{
    Directory dir=await getApplicationDocumentsDirectory();
    String path= dir.path + 'mails.db';
    var mailsDatabase= await openDatabase(path, version:1, onCreate:_createDb);
    return mailsDatabase;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $mailTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colSender TEXT, $colRecepient TEXT, $colSubject TEXT, $colMail TEXT, $colDate TEXT)');
  }

  Future <List<Map<String, dynamic>>> getMailMapList() async{
    Database db= await this.database;
    var result = await db.query(mailTable, orderBy: '$colId ASC');
    return result;
  }

  Future <int> insertMail(MailDB mail) async{
    Database db= await this.database;
    var result= await db.insert(mailTable, mail.toMap());
    return result;
  }

  Future <int> deleteMail(int id) async{
    var db= await this.database;
    int result = await db.rawDelete('DELETE FROM $mailTable WHERE $colId=$id');
    return result;
  }

  Future <List<MailDB>> getMailList() async{
    var mailMapList= await getMailMapList();
    int count= mailMapList.length;

    List<MailDB> mailList= List<MailDB>();
    for (int i=0; i<count; i++){
      mailList.add(MailDB.fromMapObject(mailMapList[i]));
    }
    return mailList;
  }


  Future <List<MailDB>> getSearchList(String sv) async{
    var mailMapList= await getMailMapList();
    int count= mailMapList.length;

    List<MailDB> mailList= List<MailDB>();
    MailDB mailtocheck;
    String s;
    String r;
    String sub;
    String m;
    for (int i=0; i<count; i++){
      mailtocheck=MailDB.fromMapObject(mailMapList[i]);
      s=mailtocheck.sender;
      r=mailtocheck.recepient;
      sub=mailtocheck.subject;
      m=mailtocheck.mail;
      if (s.contains(sv) || r.contains(sv) || sub.contains(sv) || m.contains(sv))
        mailList.add(MailDB.fromMapObject(mailMapList[i]));
    }
    return mailList;
  }
}
