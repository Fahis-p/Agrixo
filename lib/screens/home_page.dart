import 'package:flutter/material.dart';
import '../widgets/add_expense_dialog.dart';
import '../widgets/add_income_dialog.dart';
import '../models/crop_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              'Today, April 25, 2024',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 24),

            /// ADD EXPENSE
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

            /// ADD INCOME
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

            const SizedBox(height: 28),

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

  // ================= BUTTON =================

  static Widget _primaryButton({
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
      static Widget _cropRow() {
  final List<CropItem> crops = const [
  CropItem(name: 'All', iconPath: 'assets/icons/crops/all.png'),
  CropItem(name: 'Papaya', iconPath: 'assets/icons/crops/pappaya.png'),
  CropItem(name: 'Banana', iconPath: 'assets/icons/crops/banana.png'),
  CropItem(name: 'Dragon', iconPath: 'assets/icons/crops/dragon.png'),
  CropItem(name: 'Turmeric', iconPath: 'assets/icons/crops/turmeric.png'),
  CropItem(name: 'General', iconPath: 'assets/icons/crops/general.png'),
];

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: crops.map((crop) {
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
                Image.asset(
                  crop.iconPath,
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                Text(
                  crop.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ),
  );
}




  // ================= SUMMARY =================

  static Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _summaryRow('Today Expense', '₹837', Colors.red),
          const Divider(),
          _summaryRow('Today Income', '₹2,500', Colors.green),
          const Divider(),
          _summaryRow('Balance', '₹1,663', Colors.green),
        ],
      ),
    );
  }

  static Widget _summaryRow(String label, String value, Color color) {
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

  // ================= TRANSACTIONS =================

  static Widget _transactionTile(
    IconData icon,
    String title,
    String amount,
    Color color,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: Text(
        amount,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
