import 'package:flutter/material.dart';

class PLStatementCard extends StatelessWidget {
  final String period;

  const PLStatementCard({
    super.key,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profit & Loss Account – $period',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const Divider(),

            /// TABLE HEADER
            Row(
              children: const [
                Expanded(child: Text('Particulars', style: TextStyle(fontWeight: FontWeight.bold))),
                Text('Amount'),
                SizedBox(width: 20),
                Expanded(child: Text('Particulars', style: TextStyle(fontWeight: FontWeight.bold))),
                Text('Amount'),
              ],
            ),
            const Divider(),

            /// ROWS
            _row('To Salaries', '12,000', 'By Sales', '30,000'),
            _row('To Fertilizer', '8,000', 'By Other Income', '5,000'),
            _row('To Transport', '3,000', 'By Interest', '2,000'),
            _row('To Misc Expenses', '4,000', '', ''),

            const Divider(),

            /// NET PROFIT
            _row(
              'To Net Profit',
              '10,000',
              '',
              '',
              highlightLeft: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    String leftParticular,
    String leftAmount,
    String rightParticular,
    String rightAmount, {
    bool highlightLeft = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              leftParticular,
              style: TextStyle(
                fontWeight: highlightLeft ? FontWeight.bold : FontWeight.normal,
                color: highlightLeft ? Colors.green : null,
              ),
            ),
          ),
          Text(leftAmount),
          const SizedBox(width: 20),
          Expanded(child: Text(rightParticular)),
          Text(rightAmount),
        ],
      ),
    );
  }
}
