import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../widgets/appColors.dart';
import '../../auth/firestore/firestoreService.dart';

class TotalExpense extends StatelessWidget {
  String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  const TotalExpense({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    final FirestoreService firestoreService = FirestoreService();

    return Container(
      width: deviceWidth,
      height: deviceHeight,
      decoration: BoxDecoration(
        gradient: AppColors.debtCardColors,
      ),
      child: Column(
        children: [
          // Expense Section
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: firestoreService.getExpenseStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No expenses found.'));
                }

                List<Map<String, dynamic>> expenses = snapshot.data!;

                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Expenses',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          var expense = expenses[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            elevation: 4,
                            child: ListTile(
                              leading: Image.asset(
                                expense['imageUrl'],
                              ),
                              title: Text(expense['expName'] ?? 'No Name'),
                              subtitle: Text('Debt: ${expense['amount'] ?? 0}'),
                              trailing: Text(
                                  'Date: ${formatDate(DateTime.parse(expense['lastPaymentDate']))}'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Credit Section
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: firestoreService.getCreditStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No credits found.'));
                }

                List<Map<String, dynamic>> credits = snapshot.data!;

                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Credit Infos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: credits.length,
                        itemBuilder: (context, index) {
                          var credit = credits[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            elevation: 4,
                            child: ListTile(
                              leading: Image.asset(
                                credit['imageUrl'],
                              ),
                              title: Text(credit['bankName'] ?? 'No Name'),
                              subtitle:
                                  Text('Amount: ${credit['remaining'] ?? 0}'),
                              trailing: Text(
                                  'Date: ${formatDate(DateTime.parse(credit['lastPaymentDate']))}'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
