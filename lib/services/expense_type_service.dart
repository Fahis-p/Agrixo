import '../db/app_database.dart';
import '../models/expense_type_model.dart';

class ExpenseTypeService {
  /// Add new expense type
  static Future<void> addExpenseType(ExpenseTypeModel model) async {
    await AppDatabase.instance.insertExpenseType(model.toMap());
  }

  /// Get last added expense types
  static Future<List<ExpenseTypeModel>> getLastExpenseTypes(
  int limit, {
  required String type,
}) async {
  final rows = await AppDatabase.instance.getExpenseTypes(
    type: type,
    limit: limit,
  );

  return rows.map(ExpenseTypeModel.fromMap).toList();
}
}
