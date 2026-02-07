import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../models/category_model.dart';
import '../models/expense_type_model.dart';

import '../services/transaction_service.dart';
import '../services/category_service.dart';
import '../services/expense_type_service.dart';

class AddExpenseDialog extends StatefulWidget {
  const AddExpenseDialog({super.key});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  // ===== DATA LISTS =====
  List<CategoryModel> categories = [];
  List<ExpenseTypeModel> expenseTypes = [];

  // ===== SELECTED VALUES =====
  CategoryModel? selectedCategory;
  ExpenseTypeModel? selectedType;

  // ===== LOADING STATES =====
  bool isLoadingCategories = true;
  bool isLoadingTypes = true;

  // ===== CONTROLLERS =====
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadExpenseTypes();
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // =========================
  // LOAD CATEGORIES
  // =========================
  Future<void> _loadCategories() async {
    final list = await CategoryService.getLastCategories(
      type: 'expense',
      limit: 100,
    );

    setState(() {
      categories = list;
      isLoadingCategories = false;
    });
  }

  // =========================
  // LOAD EXPENSE TYPES
  // =========================
  Future<void> _loadExpenseTypes() async {
    final list = await ExpenseTypeService.getExpenseTypes(
      type: 'expense',
    );

    setState(() {
      expenseTypes = list;
      isLoadingTypes = false;
    });
  }

  // =========================
  // SAVE EXPENSE
  // =========================
  Future<void> _saveExpense() async {
    if (selectedCategory == null ||
        selectedType == null ||
        amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final amount = double.tryParse(amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount')),
      );
      return;
    }

    final expense = TransactionModel(
      type: 'expense',
      category: selectedCategory!.name,
      subType: selectedType!.name,
      amount: amount,
      description: descriptionController.text.trim(),
      crop: selectedCategory!.name,
      date: DateTime.now().toIso8601String().split('T').first,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    await TransactionService.addExpense(expense);

    Navigator.pop(context, true);
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== HEADER =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Expense',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ===== CATEGORY =====
                const Text('Category'),
                const SizedBox(height: 6),

                isLoadingCategories
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<CategoryModel>(
                        initialValue: selectedCategory,
                        items: categories.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Text(cat.name),
                          );
                        }).toList(),
                        onChanged: (v) =>
                            setState(() => selectedCategory = v),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),

                const SizedBox(height: 16),

                // ===== EXPENSE TYPE =====
                const Text('Type'),
                const SizedBox(height: 6),

                isLoadingTypes
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<ExpenseTypeModel>(
                        initialValue: selectedType,
                        items: expenseTypes.map((t) {
                          return DropdownMenuItem(
                            value: t,
                            child: Text('${t.emoji ?? ''} ${t.name}'),
                          );
                        }).toList(),
                        onChanged: (v) =>
                            setState(() => selectedType = v),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),

                const SizedBox(height: 16),

                // ===== AMOUNT =====
                const Text('Amount'),
                const SizedBox(height: 6),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '₹ ',
                    hintText: 'Enter amount',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                // ===== DESCRIPTION =====
                const Text('Description'),
                const SizedBox(height: 6),
                TextField(
                  controller: descriptionController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Optional notes',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 24),

                // ===== ACTION BUTTONS =====
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveExpense,
                        child: const Text('Add Expense'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
