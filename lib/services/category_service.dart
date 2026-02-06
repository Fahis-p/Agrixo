import 'package:agrixo_min/models/category_model.dart';

import '../db/app_database.dart';

class CategoryService {
  static Future<void> addExpenseCategory(CategoryModel category) async {
    await AppDatabase.instance.insertCategory({
      'name': category.name,
      'iconPath': category.iconPath,
      'type': category.type,
      'createdAt': category.createdAt,
    });
  }

  // 🔥 GENERIC METHOD (USE THIS)
  static Future<List<CategoryModel>> getLastCategories({
    required String type,
    required int limit,
  }) async {
    final rows = await AppDatabase.instance.getCategories(
      type: type,
      limit: limit,
    );

    return rows.map((e) => CategoryModel.fromMap(e)).toList();
  }
}

