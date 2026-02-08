import 'package:flutter/material.dart';

class CropAnalysisPage extends StatelessWidget {
  const CropAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final crops = [
      {'name': 'Dragon Fruit', 'expense': 42000, 'income': 58000},
      {'name': 'Passion Fruit', 'expense': 30000, 'income': 26000},
      {'name': 'Papaya', 'expense': 18000, 'income': 27000},
      {'name': 'Turmeric', 'expense': 25000, 'income': 22000},
      {'name': 'Banana', 'expense': 35000, 'income': 52000},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: crops.length,
      itemBuilder: (context, index) {
        final crop = crops[index];
        final expense = crop['expense'] as int;
        final income = crop['income'] as int;
        final profit = income - expense;
        final isProfit = profit >= 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              /// LEFT INDICATOR BAR
              Container(
                width: 6,
                height: 110,
                decoration: BoxDecoration(
                  color: isProfit ? Colors.green : Colors.red,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(14),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            crop['name'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          /// PROFIT / LOSS BADGE
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isProfit
                                  ? Colors.green.withOpacity(0.12)
                                  : Colors.red.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isProfit ? 'PROFIT' : 'LOSS',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isProfit ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// INCOME / EXPENSE ROW
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoTile(
                            label: 'Income',
                            value: income,
                            color: Colors.blue,
                          ),
                          _infoTile(
                            label: 'Expense',
                            value: expense,
                            color: Colors.orange,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// PROFIT VALUE
                      Text(
                        '${isProfit ? 'Net Profit' : 'Net Loss'}: ₹${profit.abs()}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isProfit ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoTile({
    required String label,
    required int value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '₹$value',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
