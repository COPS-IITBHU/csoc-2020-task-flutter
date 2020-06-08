
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'EmailModel.dart';
class EmailDatabase{
  Database _database;
  Future<Database> get database async{
    if(_database !=null){
      return database;
    }else{
      _database = await createDatabase();
      return _database;
    }
  }
  createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'emails.db');
    var db = await openDatabase(dbPath, version: 1, onCreate: populateDb);
    return db;
  }
  void populateDb(Database database, int version) async {
    await database.execute("CREATE TABLE Emails (id INTEGER PRIMARY KEY,toCol TEXT,fromCol TEXT,subject TEXT,message TEXT)");
  }
  Future<int> createEmail(Database database,Emails email) async {
    var result = await database.insert("Emails", email.toMap());
    return result;
  }
  Future<List<Emails>> getEmails(Database database) async {
    var result = await database.query("Emails", columns: ["id", "toCol", "fromCol", "subject","message"]);
    List<Emails> emaillist=[];
    for(Map res in result){
      emaillist.add(Emails.fromMap(res));
    }
    return emaillist;
  }
  Future<Emails> getEmail(Database db,int id) async {
    List<Map> results = await db.query("Emails",
        columns: ["id", "toCol", "fromCol", "subject","message"],
        where: 'id = ?',
        whereArgs: [id]);

    if (results.length > 0) {
      return new Emails.fromMap(results.first);
    }

    return null;
  }
  Future<int> deleteCustomer(int id,Database database) async {
    return await database.delete("Emails", where: 'id = ?', whereArgs: [id]);
  }
}