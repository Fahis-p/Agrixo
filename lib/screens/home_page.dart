import 'package:flutter/material.dart';

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

            /// Add Expense
            _primaryButton(
              color: const Color(0xFF5E8D68),
              icon: Icons.add,
              text: 'Add Expense',
            ),

            const SizedBox(height: 16),

            /// Add Income
            _primaryButton(
              color: const Color(0xFFF6D58E),
              icon: Icons.currency_rupee,
              text: 'Add Income',
              textColor: Colors.black87,
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

  // ---------- UI helpers ----------

  static Widget _primaryButton({
    required Color color,
    required IconData icon,
    required String text,
    Color textColor = Colors.white,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _cropRow() {
    final crops = ['Papaya', 'Banana', 'Dragon', 'Turmeric', 'General'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: crops
          .map(
            (c) => Container(
              width: 70,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3EA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  c,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

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

  static Widget _summaryRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

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
