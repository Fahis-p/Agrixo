import 'package:flutter/material.dart';

class AddExpenseDialog extends StatelessWidget {
  const AddExpenseDialog({super.key});

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
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Expense',
                      style: TextStyle(
                        fontSize: 18,
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
                  items: const [
                    DropdownMenuItem(value: 'Papaya', child: Text('Papaya')),
                    DropdownMenuItem(value: 'Banana', child: Text('Banana')),
                    DropdownMenuItem(value: 'General', child: Text('General')),
                  ],
                  onChanged: (_) {},
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                /// Expense Type
                const Text('Type'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  items: const [
                    DropdownMenuItem(
                        value: 'Fertilizer', child: Text('Fertilizer')),
                    DropdownMenuItem(
                        value: 'Seed Purchase', child: Text('Seed Purchase')),
                    DropdownMenuItem(
                        value: 'Plant Purchase', child: Text('Plant Purchase')),
                    DropdownMenuItem(
                        value: 'Labour', child: Text('Labour')),
                    DropdownMenuItem(
                        value: 'Equipment', child: Text('Equipment')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (_) {},
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                /// Amount (NEW)
                const Text('Amount'),
                const SizedBox(height: 6),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '₹ ',
                    hintText: 'Enter amount',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                /// Description
                const Text('Description'),
                const SizedBox(height: 6),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter description',
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
                        onPressed: () {
                          // Save expense logic later
                          Navigator.pop(context);
                        },
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
