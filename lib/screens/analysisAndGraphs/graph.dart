import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import 'package:my_app/extensions/media_query.dart';
import 'package:my_app/screens/analysisAndGraphs/datas.dart';

class Graph extends StatefulWidget {
  const Graph({super.key});

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  String? selectedOption; // Track the selected option
  final DataService dataService = DataService();
  double expensePaidTotal = 0.0;
  double expenseUnpaidTotal = 0.0;
  double expenseTotal = 0.0;
  double creditTotal = 0.0;
  double creditRemaining = 0.0;
  double creditPaid = 0.0;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = context.deviceWidth;
    final double deviceHeight = context.deviceHeight;
    double appBarHeight = deviceWidth * 0.28;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
              onPressed: () => Get.offAllNamed('/mainmenu'),
              icon: const Icon(Icons.arrow_back_ios_new_sharp)),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Image.asset(
            'lib/assets/logo.png',
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 9, 99),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRadioButton('expenses', 'Expenses'),
                const SizedBox(width: 16),
                _buildRadioButton('credit', 'Credit'),
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: selectedOption == 'expenses'
                    ? _buildExpenseChart()
                    : selectedOption == 'credit'
                        ? _buildCreditChart()
                        : const Center(child: Text('Select an option')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton(String value, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = value;
          if (value == 'expenses') {
            _loadExpenseData();
          } else {
            _loadCreditData();
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: selectedOption == value
              ? Colors.blue.shade900
              : Colors.blue.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                selectedOption == value ? Colors.white : Colors.blue.shade900,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _loadExpenseData() async {
    double paid = await dataService.getPaidExpensesTotal();
    double unpaid = await dataService.getUnpaidExpensesTotal();
    double totalExpense = await dataService.getTotalExpenses();
    setState(() {
      expensePaidTotal = paid;
      expenseUnpaidTotal = unpaid;
      expenseTotal = totalExpense;
    });
  }

  void _loadCreditData() async {
    double total = await dataService.getTotalCredit();
    double remaining = await dataService.getTotalRemainingCredit();
    double paid = await dataService.getTotalPaidCredit();

    setState(() {
      creditTotal = total;
      creditRemaining = remaining;
      creditPaid = paid;
    });
  }

  Widget _buildExpenseChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Expenses Overview",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BarChart(
            BarChartData(
              barGroups: [
                _buildBarGroup(0, expensePaidTotal, Colors.green),
                _buildBarGroup(1, expenseUnpaidTotal, Colors.red),
                _buildBarGroup(2, expenseTotal, Colors.blue),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 0:
                          return const Text('Paid');
                        case 1:
                          return const Text('Unpaid');
                        case 2:
                          return const Text('Total');
                        default:
                          return const Text('');
                      }
                    },
                    reservedSize: 32,
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              gridData: const FlGridData(show: true),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreditChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Credit Overview",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BarChart(
            BarChartData(
              barGroups: [
                _buildBarGroup(0, creditPaid, Colors.green),
                _buildBarGroup(1, creditRemaining, Colors.red),
                _buildBarGroup(2, creditTotal, Colors.blue),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 0:
                          return const Text('Paid');
                        case 1:
                          return const Text('Remaining');
                        case 2:
                          return const Text('Total');
                        default:
                          return const Text('');
                      }
                    },
                    reservedSize: 32,
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              gridData: const FlGridData(show: true),
            ),
          ),
        ),
      ],
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 30,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
      showingTooltipIndicators: [0],
    );
  }
}
