import 'package:flutter/material.dart';
import '../models/expense_type_model.dart';
import '../services/expense_type_service.dart';
class AddExpenseTypeDialog extends StatefulWidget {
  const AddExpenseTypeDialog({super.key});

  @override
  State<AddExpenseTypeDialog> createState() =>
      _AddExpenseTypeDialogState();
}

class _AddExpenseTypeDialogState extends State<AddExpenseTypeDialog> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emojiCtrl = TextEditingController(text: '🧾');

  void _onNameChanged(String value) {
    emojiCtrl.text = suggestEmoji(value);
  }

  Future<void> _save() async {
    if (nameCtrl.text.trim().isEmpty) return;

    final model = ExpenseTypeModel(
      name: nameCtrl.text.trim(),
      emoji: emojiCtrl.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    await ExpenseTypeService.addExpenseType(model);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Expense Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            const Text('Type Name'),
            TextField(
              controller: nameCtrl,
              onChanged: _onNameChanged,
              decoration: const InputDecoration(
                hintText: 'e.g. Diesel',
              ),
            ),

            const SizedBox(height: 16),

            const Text('Emoji'),
            TextField(
              controller: emojiCtrl,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            )
          ],
        ),
      ),
    );
  }
}


// ================= EMOJI SUGGESTION HELPER =================

String suggestEmoji(String text) {
  final t = text.toLowerCase();

  if (t.contains('diesel') || t.contains('fuel')) return '⛽';
  if (t.contains('seed')) return '🌱';
  if (t.contains('fertilizer')) return '🧪';
  if (t.contains('food')) return '🍽️';
  if (t.contains('labour') || t.contains('worker')) return '👨‍🌾';
  if (t.contains('transport')) return '🚚';

  return '🧾';
}