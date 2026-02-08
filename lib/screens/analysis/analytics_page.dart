import 'package:flutter/material.dart';
import 'crop_analysis_page.dart';
import 'monthly_analysis_page.dart';
import 'profit_loss_page.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analytics'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.agriculture), text: 'Crops'),
              Tab(icon: Icon(Icons.bar_chart), text: 'Monthly'),
              Tab(icon: Icon(Icons.account_balance), text: 'P / L'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CropAnalysisPage(),
            MonthlyAnalysisPage(),
            ProfitLossPage(),
          ],
        ),
      ),
    );
  }
}
