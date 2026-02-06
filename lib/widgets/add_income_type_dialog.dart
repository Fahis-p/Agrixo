import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../models/expense_type_model.dart';
import '../services/category_service.dart';
import '../services/expense_type_service.dart';

class AddIncomeTypeDialog extends StatefulWidget {
  const AddIncomeTypeDialog({super.key});

  @override
  State<AddIncomeTypeDialog> createState() => _AddIncomeTypeDialogState();
}

class _AddIncomeTypeDialogState extends State<AddIncomeTypeDialog> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emojiCtrl = TextEditingController(text: '💰');

  List<CategoryModel> incomeCategories = [];
  CategoryModel? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadIncomeCategories();
  }

  Future<void> _loadIncomeCategories() async {
    final list =
        await CategoryService.getLastCategories(type: 'income', limit: 50);
    setState(() {
      incomeCategories = list;
      if (list.isNotEmpty) selectedCategory = list.first;
    });
  }

  void _onNameChanged(String value) {
    emojiCtrl.text = suggestEmoji(value);
  }

  Future<void> _save() async {
    if (nameCtrl.text.trim().isEmpty || selectedCategory == null) return;

    final model = ExpenseTypeModel(
      name: nameCtrl.text.trim(),
      type: 'income',
      categoryId: selectedCategory!.id!,
      emoji: emojiCtrl.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    await ExpenseTypeService.addExpenseType(model);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Income Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            const Text('Income Category'),
            const SizedBox(height: 6),
            DropdownButtonFormField<CategoryModel>(
              value: selectedCategory,
              items: incomeCategories
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c.name),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => selectedCategory = v),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 16),

            const Text('Income Type'),
            const SizedBox(height: 6),
            TextField(
              controller: nameCtrl,
              onChanged: _onNameChanged,
              decoration: const InputDecoration(
                hintText: 'e.g. Papaya Sale',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            const Text('Emoji'),
            const SizedBox(height: 6),
            TextField(
              controller: emojiCtrl,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String suggestEmoji(String text) {
  final t = text.toLowerCase();

  if (t.contains('sale')) return '📈';
  if (t.contains('capital')) return '💵';

  return '💵';
}