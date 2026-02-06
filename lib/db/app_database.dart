import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
  static Database? _database;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'agrixo.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT,
            category TEXT,
            subType TEXT,
            amount REAL,
            description TEXT,
            crop TEXT,
            date TEXT,
            createdAt INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertTransaction(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('transactions', data);
  }

  Future<List<Map<String, dynamic>>> getAllTransactions() async {
  final db = await database;
  return await db.query(
    'transactions',
    orderBy: 'createdAt DESC',
  );
}
}
