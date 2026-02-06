import 'dart:io';
import 'package:flutter/material.dart';

import '../widgets/add_expense_dialog.dart';
import '../widgets/add_income_dialog.dart';
import '../screens/configuration_page.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> expenseCategories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final list = await CategoryService.getLastCategories(
    type: 'expense',
    limit: 50,
  );
    setState(() {
      expenseCategories = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Agrixo',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4E7D5B),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ConfigurationPage()),
              );
              _loadCategories(); // 🔄 refresh when coming back
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Farm Transactions',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            const Text(
              'Today',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 24),

            _primaryButton(
              gradientColors: const [Color(0xFFD32F2F), Color(0xFFB71C1C)],
              icon: Icons.remove_circle_outline,
              text: 'Add Expense',
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const AddExpenseDialog(),
                );
              },
            ),

            const SizedBox(height: 16),

            _primaryButton(
              gradientColors: const [Color(0xFF2E7D32), Color(0xFF1B5E20)],
              icon: Icons.add_circle_outline,
              text: 'Add Income',
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const AddIncomeDialog(),
                );
              },
            ),

            const SizedBox(height: 28),

            const Text(
              'Select Crop',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            _cropRow(),

            const SizedBox(height: 28),

            _summaryCard(),

            const SizedBox(height: 20),
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _transactionTile(
              Icons.local_gas_station,
              'Diesel',
              '- ₹837',
              Colors.red,
            ),
            _transactionTile(Icons.restaurant, 'Food', '- ₹300', Colors.red),
            _transactionTile(
              Icons.eco,
              'Papaya Sale',
              '+ ₹2,500',
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  // ================= buttons =================
  Widget _primaryButton({
    required List<Color> gradientColors,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color textColor = Colors.white,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 22),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CROPS =================

  Widget _cropRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _cropTile(
            name: 'All',
            icon: Image.asset(
              'assets/icons/crops/all.png',
              width: 40,
              height: 40,
            ),
          ),

          ...expenseCategories.map((cat) {
            return _cropTile(
              name: cat.name,
              icon: cat.iconPath != null
                  ? Image.file(
                      File(cat.iconPath!),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.category, size: 40),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _cropTile({required String name, required Widget icon}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        width: 80,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF3EA),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SUMMARY =================

  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: const [
          _SummaryRow(label: 'Today Expense', value: '₹837', color: Colors.red),
          Divider(),
          _SummaryRow(
            label: 'Today Income',
            value: '₹2,500',
            color: Colors.green,
          ),
          Divider(),
          _SummaryRow(label: 'Balance', value: '₹1,663', color: Colors.green),
        ],
      ),
    );
  }
}

// ================= SMALL WIDGETS =================

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ================= TRANSACTIONS =================
_transactionTile(IconData icon, String title, String amount, Color color) {
  return ListTile(
    leading: Icon(icon, color: color),
    title: Text(title),
    trailing: Text(
      amount,
      style: TextStyle(color: color, fontWeight: FontWeight.w600),
    ),
  );
}
