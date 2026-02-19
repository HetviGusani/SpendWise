import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Mydb {
  static late final _databasename = "expense.db";
  static final _databaseVersion = 1;
  static final table = 'user';
  static final columnId = '_id';
  static final columnname = 'name';
  static final columnEmail = 'email';
  static final columnPass = 'pass';
  static Database? _database;

  //table 2
  static final table2 = 'Category';
  static final columnId1 = 'category_id';
  static final columnCategory = 'category';
  static final columnAmount = 'amount';
  static final userId = 'user_id';

  Mydb._privateConstructor();

  static final Mydb instance = Mydb._privateConstructor();

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
                        CREATE TABLE $table (
                          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
                          $columnname TEXT NOT NULL,
                          $columnEmail TEXT NOT NULL UNIQUE,
                          $columnPass TEXT NOT NULL
                        )
    ''');

    await db.execute('''
                          CREATE TABLE $table2 (
                          $columnId1 INTEGER PRIMARY KEY AUTOINCREMENT,
                          $columnCategory TEXT NOT NULL,
                          $columnAmount TEXT NOT NULL,
                          $userId INTEGER NOT NULL,
                          FOREIGN KEY ($userId) REFERENCES $table($columnId)
                          ) 
    ''');
  }

  Future<Database> get database async => _database ??= await _initDatabase();

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databasename);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<int> insertData(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db.insert(table, row);
  }

  Future<Map<String, dynamic>?> checkLogin(String email, String pass) async {
    final dbC = await database;

    List<Map<String, dynamic>> result = await dbC.query(
      table,
      where: '$columnEmail = ? AND $columnPass = ?',
      whereArgs: [email, pass],
    );

    if (result.isNotEmpty) {
      return result.first; // contains name, email, pass
    }
    return null;
  }

  Future<int> insertExpense(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db.insert(table2, row);
  }

  Future<List<Map<String, dynamic>>> fetchData(int id) async {
    Database db = await instance.database;
    return await db.query(table2, where: '$userId=?', whereArgs: [id]);
  }

  Future<int> editAmount(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.update(
      table2,
      {columnAmount: row[columnAmount]},
      where: '$userId = ? AND $columnCategory = ?',
      whereArgs: [row[userId], row[columnCategory]],
    );
  }

  Future<int> deleteData(Map<String,dynamic> row)async{
    Database db=await instance.database;
    return await db.delete(table2,where: '$userId=? AND $columnCategory=?',whereArgs: [row[userId],row[columnCategory]]);
  }
}
