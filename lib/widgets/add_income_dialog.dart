import 'package:flutter/material.dart';

class AddIncomeDialog extends StatefulWidget {
  const AddIncomeDialog({super.key});

  @override
  State<AddIncomeDialog> createState() => _AddIncomeDialogState();
}

class _AddIncomeDialogState extends State<AddIncomeDialog> {
  String? selectedCategory;
  String? selectedType;

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
                  value: selectedCategory,
                  items: const [
                    DropdownMenuItem(
                      value: 'Sales',
                      child: Text('Sales'),
                    ),
                    DropdownMenuItem(
                      value: 'Capital',
                      child: Text('Capital'),
                    ),
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
                  value: selectedType,
                  items: typeOptions
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ),
                      )
                      .toList(),
                  onChanged: typeOptions.isEmpty
                      ? null
                      : (value) {
                          setState(() {
                            selectedType = value;
                          });
                        },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                /// Amount
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
                          // Save income logic later
                          Navigator.pop(context);
                        },
                        child: const Text('Add Income'),
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
