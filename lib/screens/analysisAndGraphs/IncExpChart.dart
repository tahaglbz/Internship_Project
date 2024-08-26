import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IncomeExpenseChart extends StatelessWidget {
  final double incomeTotal;
  final double expenseTotal;

  const IncomeExpenseChart({
    required this.incomeTotal,
    required this.expenseTotal,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: incomeTotal,
                color: Colors.green,
                width: 22,
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 0,
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: expenseTotal,
                color: Colors.orange,
                width: 22,
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 0,
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              switch (value.toInt()) {
                case 0:
                  return const Text('Total Income');
                case 1:
                  return const Text('Total Expense');
                default:
                  return const Text('');
              }
            },
          )),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceEvenly,
      ),
    );
  }
}
