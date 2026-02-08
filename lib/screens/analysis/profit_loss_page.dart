import 'package:flutter/material.dart';
import '../../widgets/pl_month_card.dart';

class ProfitLossPage extends StatelessWidget {
  const ProfitLossPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: const [
        PLMonthCard(period: 'January 2026'),
        PLMonthCard(period: 'February 2026'),
        PLMonthCard(period: 'March 2026'),
      ],
    );
  }
}
