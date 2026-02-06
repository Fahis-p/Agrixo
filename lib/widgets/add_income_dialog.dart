import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class AddIncomeDialog extends StatefulWidget {
  const AddIncomeDialog({super.key});

  @override
  State<AddIncomeDialog> createState() => _AddIncomeDialogState();
}

class _AddIncomeDialogState extends State<AddIncomeDialog> {
  String? selectedCategory;
  String? selectedType;

  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  List<String> typeOptions = [];

  void _onCategoryChanged(String? value) {
    setState(() {
      selectedCategory = value;
      selectedType = null;

      if (value == 'Sales') {
        typeOptions = [
          'Papaya',
          'Dragon Fruit',
          'Passion Fruit',
          'Banana',
          'Other',
        ];
      } else if (value == 'Capital') {
        typeOptions = [
          'Kunheedu',
          'Mujeeb',
        ];
      } else {
        typeOptions = [];
      }
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveIncome() async {
    if (selectedCategory == null ||
        selectedType == null ||
        amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final income = TransactionModel(
      type: 'income',
      category: selectedCategory!,
      subType: selectedType!,
      amount: double.parse(amountController.text),
      description: descriptionController.text,
      crop: selectedType!, // crop = fruit or investor
      date: DateTime.now().toIso8601String().split('T').first,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    await TransactionService.addIncome(income);
    await TransactionService.printAllTransactions();
    Navigator.pop(context); // close dialog
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Income',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 10, 85, 0),
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

              /// Category
              const Text('Category'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                items: const [
                  DropdownMenuItem(value: 'Sales', child: Text('Sales')),
                  DropdownMenuItem(value: 'Capital', child: Text('Capital')),
                ],
                onChanged: _onCategoryChanged,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              /// Type (dynamic)
              const Text('Type'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                items: typeOptions
                    .map(
                      (t) => DropdownMenuItem(
                        value: t,
                        child: Text(t),
                      ),
                    )
                    .toList(),
                onChanged: typeOptions.isEmpty
                    ? null
                    : (v) => setState(() => selectedType = v),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              /// Amount
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

              /// Description
              const Text('Description'),
              const SizedBox(height: 6),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              /// Actions
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
