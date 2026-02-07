import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../models/category_model.dart';
import '../models/expense_type_model.dart';

import '../services/transaction_service.dart';
import '../services/category_service.dart';
import '../services/expense_type_service.dart';

class AddIncomeDialog extends StatefulWidget {
  const AddIncomeDialog({super.key});

  @override
  State<AddIncomeDialog> createState() => _AddIncomeDialogState();
}

class _AddIncomeDialogState extends State<AddIncomeDialog> {
  // ===== DATA LISTS =====
  List<CategoryModel> categories = [];
  List<ExpenseTypeModel> incomeTypes = [];

  // ===== SELECTED VALUES =====
  CategoryModel? selectedCategory;
  ExpenseTypeModel? selectedType;

  // ===== LOADING STATES =====
  bool isLoadingCategories = true;
  bool isLoadingTypes = false;

  // ===== CONTROLLERS =====
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadIncomeCategories();
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // =========================
  // LOAD INCOME CATEGORIES
  // =========================
  Future<void> _loadIncomeCategories() async {
    final list = await CategoryService.getLastCategories(
      type: 'income',
      limit: 100,
    );

    setState(() {
      categories = list;
      isLoadingCategories = false;
    });
  }

  // =========================
  // LOAD INCOME TYPES (DEPENDENT)
  // =========================
  Future<void> _loadIncomeTypes(int categoryId) async {
    setState(() {
      isLoadingTypes = true;
      incomeTypes = [];
      selectedType = null;
    });

    final list = await ExpenseTypeService.getIncomeTypesByCategory(
      categoryId,
    );

    setState(() {
      incomeTypes = list;
      isLoadingTypes = false;
    });
  }

  // =========================
  // SAVE INCOME
  // =========================
  Future<void> _saveIncome() async {
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

    final income = TransactionModel(
      type: 'income',
      category: selectedCategory!.name,
      subType: selectedType!.name,
      amount: amount,
      description: descriptionController.text.trim(),
      crop: selectedType!.name,
      date: DateTime.now().toIso8601String().split('T').first,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    await TransactionService.addIncome(income);

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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ===== HEADER =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Income',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
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
                      value: selectedCategory,
                      items: categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(cat.name),
                        );
                      }).toList(),
                      onChanged: (cat) {
                        setState(() => selectedCategory = cat);
                        if (cat != null) {
                          _loadIncomeTypes(cat.id!);
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),

              const SizedBox(height: 16),

              // ===== TYPE (DEPENDENT) =====
              const Text('Type'),
              const SizedBox(height: 6),

              if (selectedCategory == null)
                const Text(
                  'Select category first',
                  style: TextStyle(color: Colors.grey),
                )
              else if (isLoadingTypes)
                const Center(child: CircularProgressIndicator())
              else
                DropdownButtonFormField<ExpenseTypeModel>(
                  value: selectedType,
                  items: incomeTypes.map((t) {
                    return DropdownMenuItem(
                      value: t,
                      child: Text('${t.emoji ?? ''} ${t.name}'),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => selectedType = v),
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
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              // ===== ACTIONS =====
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
                      onPressed: _saveIncome,
                      child: const Text('Add Income'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
