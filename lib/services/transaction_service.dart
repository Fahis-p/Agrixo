import '../db/app_database.dart';
import '../models/transaction_model.dart';

class TransactionService {
    static Future<void> addExpense(TransactionModel txn) async {
      await AppDatabase.instance.insertTransaction(txn.toMap());
    }
    static Future<void> addIncome(TransactionModel txn) async {
      await AppDatabase.instance.insertTransaction(txn.toMap());
    }

   static Future<void> printAllTransactions() async {
    final rows = await AppDatabase.instance.getAllTransactions();
    print('================ DB TRANSACTIONS ================');
    for (final row in rows) {
      print(row.toString());
    }
    print('=================================================');
  }
}
