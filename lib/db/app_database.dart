import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
  static Database? _database;

  AppDatabase._internal();

  // =========================
  // DATABASE GETTER
  // =========================
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // =========================
  // INIT DATABASE
  // =========================
  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'agrixo.db');

    return openDatabase(
      path,
      version: 2, // 🔥 IMPORTANT: bump version when schema changes
      onCreate: (db, version) async {
        // -------------------------
        // TRANSACTIONS TABLE
        // -------------------------
        await db.execute('''
          CREATE TABLE transactions (
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

        // -------------------------
        // CATEGORIES TABLE
        // -------------------------
        await db.execute('''
          CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            type TEXT NOT NULL,
            iconPath TEXT,
            createdAt INTEGER NOT NULL
          )
        ''');
        // -------------------------
        // EXPENSE TYPES TABLE
        // -------------------------
        await db.execute('''
  CREATE TABLE expense_types (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    type TEXT NOT NULL,
    categoryId INTEGER NOT NULL DEFAULT 0,
    emoji TEXT,
    createdAt INTEGER NOT NULL
  )
''');
      },
    );
  }

  // =========================
  // TRANSACTION METHODS
  // =========================
  Future<void> insertTransaction(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('transactions', data);
  }

  Future<List<Map<String, dynamic>>> getAllTransactions() async {
    final db = await database;
    return await db.query('transactions', orderBy: 'createdAt DESC');
  }

  // =========================
  // CATEGORY METHODS
  // =========================
  Future<int> insertCategory(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('categories', data);
  }

  Future<List<Map<String, dynamic>>> getCategories({
    required String type,
    int? limit,
  }) async {
    final db = await database;

    return await db.query(
      'categories',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'createdAt DESC',
      limit: limit,
    );
  }
  // =========================
// EXPENSE TYPE METHODS
// =========================
Future<int> insertExpenseType(Map<String, dynamic> data) async {
  final db = await database;
  return await db.insert('expense_types', data);
}

Future<List<Map<String, dynamic>>> getExpenseTypes({
  required String type,
  int? limit,
}) async {
  final db = await database;

  return await db.query(
    'expense_types',
    where: 'type = ?',
    whereArgs: [type], // ✅ dynamic
    orderBy: 'createdAt DESC',
    limit: limit,
  );
}

Future<List<Map<String, dynamic>>> getTransactionsByDate(
  String date,
) async {
  final db = await database;

  return await db.query(
    'transactions',
    where: 'date = ?',
    whereArgs: [date],
    orderBy: 'createdAt DESC',
  );
}
}
