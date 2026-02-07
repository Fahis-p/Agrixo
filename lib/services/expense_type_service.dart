import '../db/app_database.dart';
import '../models/expense_type_model.dart';

class ExpenseTypeService {
  /// Add new expense type
  static Future<void> addExpenseType(ExpenseTypeModel model) async {
    await AppDatabase.instance.insertExpenseType(model.toMap());
  }

  /// Get all expense types by type (expense / income)
  static Future<List<ExpenseTypeModel>> getExpenseTypes({
    required String type,
  }) async {
    final rows = await AppDatabase.instance.getExpenseTypes(
      type: type,
    );

    return rows.map(ExpenseTypeModel.fromMap).toList();
  }

  /// Get last added expense types (used in config page)
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

  static Future<List<ExpenseTypeModel>> getIncomeTypesByCategory(
  int categoryId,
) async {
  final rows = await AppDatabase.instance.getExpenseTypes(
    type: 'income',
  );

  // filter by categoryId
  return rows
      .where((e) => e['categoryId'] == categoryId)
      .map(ExpenseTypeModel.fromMap)
      .toList();
}
}
