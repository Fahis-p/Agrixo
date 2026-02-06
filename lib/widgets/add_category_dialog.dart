import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../models/category_model.dart';
import '../services/category_service.dart';

class AddCategoryDialog extends StatefulWidget {
  final String type; // 'expense' or 'income'

  const AddCategoryDialog({
    super.key,
    required this.type,
  });

  @override
  State<AddCategoryDialog> createState() =>
      _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController nameController = TextEditingController();
  File? selectedIcon;

  Future<void> _pickIcon() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final iconDir = Directory('${dir.path}/category_icons');

    if (!iconDir.existsSync()) {
      iconDir.createSync(recursive: true);
    }

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final savedFile =
        await File(picked.path).copy('${iconDir.path}/$fileName');

    setState(() {
      selectedIcon = savedFile;
    });
  }

  Future<void> _saveCategory() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter category name')),
      );
      return;
    }

    final category = CategoryModel(
      name: nameController.text.trim(),
      type: widget.type, // 🔥 expense or income
      iconPath: selectedIcon?.path,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    await CategoryService.addExpenseCategory(category);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isExpense = widget.type == 'expense';

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
            // ===== HEADER =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isExpense
                      ? 'Add Expense Category'
                      : 'Add Income Category',
                  style: const TextStyle(
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

            const Text('Category Name'),
            const SizedBox(height: 6),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText:
                    isExpense ? 'e.g. Fertilizers' : 'e.g. Sales',
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            const Text('Category Icon'),
            const SizedBox(height: 6),
            Row(
              children: [
                InkWell(
                  onTap: _pickIcon,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: selectedIcon == null
                        ? const Icon(Icons.image, size: 28)
                        : Image.file(
                            selectedIcon!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Tap to choose icon'),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveCategory,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isExpense ? Colors.red : Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Save Category',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
