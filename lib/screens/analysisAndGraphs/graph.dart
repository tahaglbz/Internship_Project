// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import 'package:google_fonts/google_fonts.dart';
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
  final User? currentUser = FirebaseAuth.instance.currentUser;

  double expensePaidTotal = 0.0;
  double expenseUnpaidTotal = 0.0;
  double expenseTotal = 0.0;
  double creditTotal = 0.0;
  double creditRemaining = 0.0;
  double creditPaid = 0.0;
  double incomeTotal = 0.0;

  Widget _pieChart = const Center(child: Text('Select an option'));
  Widget _chart = const Center(child: Text('Select an option'));

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = context.deviceWidth;
    // final double deviceHeight = context.deviceHeight;
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
          title: Text(
            'Graphics',
            style: GoogleFonts.adamina(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 9, 99),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRadioButton('expenses', 'Expenses'),
                  const SizedBox(width: 16),
                  _buildRadioButton('credit', 'Credit'),
                  const SizedBox(width: 16),
                  _buildRadioButton('coins', 'Coins'),
                  const SizedBox(width: 16),
                  _buildRadioButton('exchange', 'Exchange'),
                  const SizedBox(
                    width: 16,
                  ),
                  _buildRadioButton('inc-exp', 'Income-Expense')
                ],
              ),
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
                        : selectedOption == 'coins'
                            ? _pieChart
                            : selectedOption == 'exchange'
                                ? _pieChart
                                : selectedOption == 'inc-exp'
                                    ? _buildIncomeChart()
                                    : const Center(
                                        child: Text('Select an option')),
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
          } else if (value == 'credit') {
            _loadCreditData();
          } else if (value == 'coins') {
            _loadCoinData();
          } else if (value == 'exchange') {
            _loadExchangeData();
          } else if (value == 'inc-exp') {
            _loadTotalIncome();
            _loadExpenseData();
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

  Future<void> _loadCoinData() async {
    try {
      final result = await dataService.getCoinData();
      final double totalValue = result['totalValue'] as double;
      final List<Map<String, dynamic>> coinData =
          result['coinData'] as List<Map<String, dynamic>>;

      setState(() {
        _pieChart = _buildCoinPieChart(coinData, totalValue);
      });
    } catch (e) {
      print("Error loading coin data: $e");
    }
  }

  Future<void> _loadTotalIncome() async {
    try {
      final totalIncome = await dataService.getTotalIncome();
      setState(() {
        incomeTotal = totalIncome;
        _chart = _buildIncomeChart();
      });
    } catch (e) {
      print("Error loading total income: $e");
    }
  }

  Future<void> _loadExchangeData() async {
    try {
      final result = await dataService.getExchangeData();
      final double totalValue = result['totalValue'] as double;
      final List<Map<String, dynamic>> exchangeData =
          result['exchangeData'] as List<Map<String, dynamic>>;

      print('Exchange Data Loaded: $exchangeData');

      setState(() {
        if (exchangeData.isEmpty) {
          _pieChart = const Center(child: Text('No exchange data available'));
        } else {
          _pieChart = _buildExchangePieChart(exchangeData, totalValue);
        }
      });
    } catch (e) {
      print("Error loading exchange data: $e");
    }
  }

  Widget _buildCoinPieChart(
      List<Map<String, dynamic>> data, double totalValue) {
    final List<Color> colorPalette = [
      Colors.blue.shade900,
      Colors.deepOrange.shade800,
      Colors.deepPurple.shade800,
      Colors.green.shade800,
      Colors.yellow.shade800,
      Colors.indigo
    ];

    return PieChart(
      PieChartData(
        sections: data.map((item) {
          final int index = data.indexOf(item);
          final double value = item['usdValue'] as double;
          final double percentage = (value / totalValue) * 100;
          final String title = item['symbol']; // For coins, use symbol

          return PieChartSectionData(
            color: colorPalette[index % colorPalette.length],
            value: value,
            title: '$title (${percentage.toStringAsFixed(1)}%)',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );
        }).toList(),
        borderData: FlBorderData(show: false),
        sectionsSpace: 0,
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildExchangePieChart(
      List<Map<String, dynamic>> data, double totalValue) {
    final List<Color> colorPalette = [
      Colors.blue.shade900,
      Colors.deepOrange.shade800,
      Colors.deepPurple.shade800,
      Colors.green.shade800,
      Colors.yellow.shade800,
      Colors.indigo
    ];

    return PieChart(
      PieChartData(
        sections: data.map((item) {
          final int index = data.indexOf(item);
          final double value = item['valueInUsd'] as double;
          final double percentage = (value / totalValue) * 100;
          final String title = item['assetName'];

          return PieChartSectionData(
            color: colorPalette[index % colorPalette.length],
            value: value,
            title: '$title (${percentage.toStringAsFixed(1)}%)',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );
        }).toList(),
        borderData: FlBorderData(show: false),
        sectionsSpace: 0,
        centerSpaceRadius: 40,
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
                        return const Text('paid');
                      case 1:
                        return const Text('unpaid');
                      case 2:
                        return const Text('total');
                      default:
                        return const Text('');
                    }
                  },
                )),
              ),
              borderData: FlBorderData(show: true),
              gridData: const FlGridData(show: true),
              alignment: BarChartAlignment.spaceEvenly,
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
                _buildBarGroup(0, creditTotal, Colors.blue),
                _buildBarGroup(1, creditRemaining, Colors.orange),
                _buildBarGroup(2, creditPaid, Colors.green),
              ],
              titlesData: FlTitlesData(
                leftTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 0:
                        return const Text('Total');
                      case 1:
                        return const Text('Remaining');
                      case 2:
                        return const Text('Paid');
                      default:
                        return const Text('');
                    }
                  },
                )),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              gridData: const FlGridData(show: true),
              alignment: BarChartAlignment.spaceAround,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeChart() {
    return BarChart(
      BarChartData(
        barGroups: [
          _buildBarGroup(0, incomeTotal, Colors.green),
          _buildBarGroup(1, expenseTotal, Colors.orange),
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
        borderData: FlBorderData(show: true),
        gridData: const FlGridData(show: true),
        alignment: BarChartAlignment.spaceEvenly,
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 22,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 0,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ],
    );
  }
}
