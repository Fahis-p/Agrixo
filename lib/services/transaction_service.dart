import '../db/app_database.dart';
import '../models/transaction_model.dart';

class TransactionService {
  // =========================
  // ADD EXPENSE
  // =========================
  static Future<void> addExpense(TransactionModel txn) async {
    await AppDatabase.instance.insertTransaction(txn.toMap());
  }

  // =========================
  // ADD INCOME
  // =========================
  static Future<void> addIncome(TransactionModel txn) async {
    await AppDatabase.instance.insertTransaction(txn.toMap());
  }

  // =========================
  // GET TRANSACTIONS BY DATE
  // =========================
  static Future<List<TransactionModel>> getTransactionsByDate(
    String date,
  ) async {
    final rows = await AppDatabase.instance.getTransactionsByDate(date);

    // 🔥 THIS LINE FIXES THE ERROR
    return rows
        .map((e) => TransactionModel.fromMap(e))
        .toList();
  }

  // =========================
  // DEBUG PRINT
  // =========================
  static Future<void> printAllTransactions() async {
    final rows = await AppDatabase.instance.getAllTransactions();
    for (final row in rows) {
      print(row);
    }
  }
}
