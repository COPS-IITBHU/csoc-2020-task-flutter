import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import './mail.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper{

   static DbHelper _helper ;
   static Database _database ;

   DbHelper._createInstane();

   factory DbHelper (){

     if(_helper ==null)
       _helper = DbHelper._createInstane();

     return _helper ;  
   }

   Future<Database> get database async{

     if(_database==null)
       _database = await initializeDb();

    return _database;
   }

   
  Future<Database> initializeDb() async {

      Directory  directory =  await getApplicationDocumentsDirectory();
      String path = directory.path + 'mail.db';

      var mailDataBase = await openDatabase(path,version:1,onCreate: _createDb) ;

      return mailDataBase;
  }

  void _createDb(Database db,int version) async {
         
          await db.execute('CREATE TABLE "Mail" ("id" INTEGER PRIMARY KEY NOT NULL ,"to" TEXT,"from" TEXT,"sub" TEXT,"content" TEXT,"date" TEXT,"cc" Text,"bcc" TEXT)');
  }


    Future <List<Map<String,dynamic>>> getMailMapList() async {

            Database db =  await this.database;
            var list = db.rawQuery('SELECT * from "Mail"');
            return list;
    }

    Future<int> addMail(Mail mail) async {

      Database db = await this.database;

      int x = await  db.insert('Mail',mail.toMap());
      return x ;

    }

    Future<int> deleteMail(int id) async {

        Database db = await this.database ;

        int x = await db.delete('Mail',where :'"id"=?',whereArgs: [id]);
        return x ;
    }
    
    Future<int> getCount() async {

      Database db = await this.database;
        List<Map<String,dynamic>> x = await  db.rawQuery('SELECT COUNT (*) from "Mail"');
        int count = Sqflite.firstIntValue(x);
        return count ;
    }

    Future<List<Mail>>  getMailList() async{
           
            var mailMapList = await getMailMapList();
            int count = mailMapList.length;

            List<Mail> mailList = List<Mail>();

            for(int i=0;i<count;i++)
            {
               mailList.add(Mail.toObject(mailMapList[i]));
            }

            return mailList;
     } 
}