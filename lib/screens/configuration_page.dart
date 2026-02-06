import 'dart:io';
import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../services/category_service.dart';
import '../models/expense_type_model.dart';
import '../services/expense_type_service.dart';
import '../widgets/add_category_dialog.dart';
import '../widgets/add_expense_type_dialog.dart';
import '../widgets/add_income_type_dialog.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  List<CategoryModel> recentExpenseCategories = [];
  List<CategoryModel> recentIncomeCategories = [];
  List<ExpenseTypeModel> recentExpenseTypes = [];
  List<ExpenseTypeModel> recentIncomeTypes = [];

  @override
  void initState() {
    super.initState();
    _loadRecentExpenseCategories();
    _loadRecentIncomeCategories();
    _loadRecentExpenseTypes();
    _loadRecentIncomeTypes();
  }

  Future<void> _loadRecentExpenseCategories() async {
  final list = await CategoryService.getLastCategories(
    type: 'expense',
    limit: 3,
  );
  setState(() {
    recentExpenseCategories = list;
  });
}

Future<void> _loadRecentIncomeCategories() async {
  final list = await CategoryService.getLastCategories(
    type: 'income',
    limit: 3,
  );
  setState(() {
    recentIncomeCategories = list;
  });
}

  Future<void> _loadRecentExpenseTypes() async {
  final list = await ExpenseTypeService.getLastExpenseTypes(
    3,
    type: 'expense',
  );
  setState(() {
    recentExpenseTypes = list;
  });
}

Future<void> _loadRecentIncomeTypes() async {
  final list = await ExpenseTypeService.getLastExpenseTypes(
    3,
    type: 'income',
  );
  setState(() {
    recentIncomeTypes = list;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== EXPENSE SECTION =====
            Text(
              'Expense',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Expense Category'),
                      onPressed: () async {
                        final result = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              const AddCategoryDialog(type: 'expense'),
                        );

                        if (result == true) {
                          _loadRecentExpenseCategories(); // 🔥 refresh list
                        }
                      },
                    ),

                    // ===== LAST 3 CATEGORIES =====
                   if (recentExpenseCategories.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Recently Added',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),

                      Column(
                        children: recentExpenseCategories.map((cat) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: cat.iconPath != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(cat.iconPath!),
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(Icons.category),
                            title: Text(cat.name),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 12),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Expense Type'),
                      onPressed: () async {
                        final result = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const AddExpenseTypeDialog(),
                        );

                        if (result == true) {
                          _loadRecentExpenseTypes();
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    // ===== LAST 3 EXPENSE TYPES =====
                    if (recentExpenseTypes.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Recently Added Types',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),

                      Column(
                        children: recentExpenseTypes.map((type) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Text(
                              type.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                            title: Text(type.name),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // ===== INCOME SECTION =====
            Text(
              'Income',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Income Category'),
                      onPressed: () async {
                        final result = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              const AddCategoryDialog(type: 'income'),
                        );

                        if (result == true) {
                          _loadRecentIncomeCategories();
                        }
                      },
                    ),

                    // ===== LAST 3 CATEGORIES =====
                    if (recentIncomeCategories.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Recently Added',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),

                      Column(
                        children: recentIncomeCategories.map((cat) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: cat.iconPath != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(cat.iconPath!),
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(Icons.category),
                            title: Text(cat.name),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 12),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Income Type'),
                      onPressed: () async {
                        final result = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const AddIncomeTypeDialog(),
                        );

                        if (result == true) {
                          _loadRecentIncomeTypes();
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    // ===== LAST 3 INCOME TYPES =====
                    if (recentIncomeTypes.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Recently Added Types',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),

                      Column(
                        children: recentIncomeTypes.map((type) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Text(
                              type.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                            title: Text(type.name),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
