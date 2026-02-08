import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../widgets/monthly_pl_summary_card.dart';

class MonthlyAnalysisPage extends StatelessWidget {
  const MonthlyAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        const Text(
          'Monthly Performance',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 14),

        /// CHART CARD
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE + LEGEND
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Income vs Expense',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  Row(
                    children: const [
                      _Legend(color: Colors.blue, text: 'Income'),
                      SizedBox(width: 10),
                      _Legend(color: Colors.orange, text: 'Expense'),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              /// BAR CHART
              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 60000,
                    barTouchData: BarTouchData(enabled: true),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 10000, // 👈 IMPORTANT
                          reservedSize: 36,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) {
                              return const Text(
                                '0',
                                style: TextStyle(fontSize: 11),
                              );
                            }
                            return Text(
                              '${(value / 1000).toInt()}K',
                              style: const TextStyle(fontSize: 11),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const months = ['Jan', 'Feb', 'Mar'];
                            if (value.toInt() >= months.length) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              months[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),

                    barGroups: [
                      _barGroup(0, 45000, 32000),
                      _barGroup(1, 38000, 29000),
                      _barGroup(2, 52000, 41000),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// MONTH SUMMARY CARD
        const MonthlyPLSummaryCard(
          month: 'January 2026',
          income: 45000,
          expense: 32000,
        ),
      ],
    );
  }

  static BarChartGroupData _barGroup(int x, double income, double expense) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: income,
          width: 14,
          borderRadius: BorderRadius.circular(6),
          color: Colors.blue,
        ),
        BarChartRodData(
          toY: expense,
          width: 14,
          borderRadius: BorderRadius.circular(6),
          color: Colors.orange,
        ),
      ],
    );
  }
}

/// LEGEND WIDGET
class _Legend extends StatelessWidget {
  final Color color;
  final String text;

  const _Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
