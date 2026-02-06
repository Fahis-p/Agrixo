import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class AddExpenseDialog extends StatefulWidget {
  const AddExpenseDialog({super.key});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  String? category;
  String? type;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveExpense() async {
    if (category == null || type == null || amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount')),
      );
      return;
    }

    final expense = TransactionModel(
      type: 'expense',
      category: category!,
      subType: type!,
      amount: amount,
      description: descriptionController.text,
      crop: category!, // using category as crop for now
      date: DateTime.now().toIso8601String().split('T').first,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    await TransactionService.addExpense(expense);
    await TransactionService.printAllTransactions();

    Navigator.pop(context); // close dialog
  }

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
                /// HEADER
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

                /// CATEGORY
                const Text('Category'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: category,
                  items: const [
                    DropdownMenuItem(value: 'Papaya', child: Text('Papaya')),
                    DropdownMenuItem(value: 'Banana', child: Text('Banana')),
                    DropdownMenuItem(value: 'General', child: Text('General')),
                  ],
                  onChanged: (v) => setState(() => category = v),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                /// EXPENSE TYPE
                const Text('Type'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: type,
                  items: const [
                    DropdownMenuItem(
                        value: 'Fertilizer', child: Text('Fertilizer')),
                    DropdownMenuItem(
                        value: 'Seed Purchase', child: Text('Seed Purchase')),
                    DropdownMenuItem(
                        value: 'Plant Purchase', child: Text('Plant Purchase')),
                    DropdownMenuItem(value: 'Labour', child: Text('Labour')),
                    DropdownMenuItem(
                        value: 'Equipment', child: Text('Equipment')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (v) => setState(() => type = v),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                /// AMOUNT
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

                /// DESCRIPTION
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

                /// ACTION BUTTONS
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
