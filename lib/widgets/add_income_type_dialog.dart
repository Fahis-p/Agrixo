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
    insetPadding: const EdgeInsets.symmetric(horizontal: 20),
    child: LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  const Text(
                    'Add Income Type',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),

                  /// CATEGORY
                  const Text('Income Category'),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<CategoryModel>(
                    initialValue: selectedCategory,
                    items: incomeCategories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(c.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => selectedCategory = v),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// TYPE NAME
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

                  /// EMOJI
                  const Text('Emoji'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: emojiCtrl,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// SAVE BUTTON
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
          ),
        );
      },
    ),
  );
}

}

String suggestEmoji(String text) {
  final t = text.toLowerCase();

  if (t.contains('sale')) return '📈';
  if (t.contains('capital')) return '💵';
  if (t.contains('rent')) return '🏠';

  return '💰';
}
