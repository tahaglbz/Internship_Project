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
              children: [
                Radio<String>(
                  value: 'expenses',
                  groupValue: selectedOption,
                  onChanged: (String? value) {
                    setState(() {
                      selectedOption = value;
                      _loadExpenseData();
                    });
                  },
                ),
                const Text("Expenses"),
                Radio<String>(
                  value: 'credit',
                  groupValue: selectedOption,
                  onChanged: (String? value) {
                    setState(() {
                      selectedOption = value;
                      _loadCreditData();
                    });
                  },
                ),
                const Text("Credit"),
              ],
            ),
            Expanded(
              child: selectedOption == 'expenses'
                  ? _buildExpenseChart()
                  : selectedOption == 'credit'
                      ? _buildCreditChart()
                      : const Center(child: Text('Select an option')),
            ),
          ],
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
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: expensePaidTotal,
            title: 'Paid Expenses',
            color: Colors.green,
          ),
          PieChartSectionData(
            value: expenseUnpaidTotal,
            title: 'Unpaid Expenses',
            color: Colors.red,
          ),
          PieChartSectionData(
              value: expenseTotal, title: 'Total Expenses', color: Colors.blue)
        ],
      ),
    );
  }

  Widget _buildCreditChart() {
    return Column(
      children: [
        Text("Credit Overview"),
        Expanded(
          child: BarChart(
            BarChartData(
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: creditTotal,
                      color: Colors.blue,
                      width: 20,
                    ),
                  ],
                  showingTooltipIndicators: [0],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: creditRemaining,
                      color: Colors.orange,
                      width: 20,
                    ),
                  ],
                  showingTooltipIndicators: [0],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(
                      toY: creditPaid,
                      color: Colors.green,
                      width: 20,
                    ),
                  ],
                  showingTooltipIndicators: [0],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
