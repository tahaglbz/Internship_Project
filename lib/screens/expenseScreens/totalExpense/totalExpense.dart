import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_app/extensions/media_query.dart';
import '../../../widgets/appColors.dart';
import '../../../auth/firestore/firestoreService.dart';

class TotalExpense extends StatelessWidget {
  String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  const TotalExpense({super.key});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = context.deviceWidth;
    final double deviceHeight = context.deviceHeight;

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
                  return const Center(
                      child: Text(
                    'No expenses found.',
                    style: TextStyle(color: Colors.grey),
                  ));
                }

                List<Map<String, dynamic>> expenses = snapshot.data!
                    .where((expense) => expense['paid'] == false)
                    .toList();

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
                          return Dismissible(
                            key: Key(expense['expName'] ?? 'Unnamed Expense'),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) async {
                              try {
                                await firestoreService
                                    .deleteExpense(expense['expName']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('${expense['expName']} silindi'),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Hata: ${e.toString()}'),
                                  ),
                                );
                              }
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Card(
                              margin: const EdgeInsets.all(8.0),
                              elevation: 4,
                              child: ListTile(
                                leading: Image.asset(
                                  expense['imageUrl'] ?? 'lib/assets/money.png',
                                ),
                                title: Text(expense['expName'] ?? 'No Name'),
                                subtitle:
                                    Text('Debt: ${expense['amount'] ?? 0}'),
                                trailing: Column(
                                  children: [
                                    Text(
                                      'Date: ${formatDate(DateTime.parse(expense['lastPaymentDate'] ?? DateTime.now().toIso8601String()))}',
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          await firestoreService
                                              .markAsPaidExpense(
                                                  expense['expName']);
                                          // Optionally, refresh the UI if needed
                                        },
                                        label: Text(
                                          'Paid',
                                          style: TextStyle(
                                              color: AppColors.color2),
                                        ),
                                        icon: const Icon(Icons.check),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
          const Divider(
            color: Colors.white,
            thickness: 1,
            height: 20,
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
                  return const Center(
                      child: Text(
                    'No credits found.',
                    style: TextStyle(color: Colors.grey),
                  ));
                }

                List<Map<String, dynamic>> credits = snapshot.data!;

                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Loan Debt',
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
                          return Dismissible(
                            key: Key(credit['aim'] ?? 'Unnamed Credit'),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) async {
                              try {
                                await firestoreService
                                    .deleteCredit(credit['aim']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${credit['aim']} deleted'),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Hata: ${e.toString()}'),
                                  ),
                                );
                              }
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Card(
                              margin: const EdgeInsets.all(8.0),
                              elevation: 4,
                              child: ListTile(
                                leading: Image.asset(
                                  credit['imageUrl'] ?? 'lib/assets/money.png',
                                ),
                                title: Text(credit['bankName'] ?? 'No Name'),
                                subtitle:
                                    Text('Debt: ${credit['remaining'] ?? 0}'),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Date: ${formatDate(DateTime.parse(credit['lastPaymentDate'] ?? DateTime.now().toIso8601String()))}',
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Get.offNamed(
                                            '/loandetails',
                                            arguments: credit,
                                          );
                                        },
                                        label: Text(
                                          'Details',
                                          style: TextStyle(
                                              color: AppColors.color2),
                                        ),
                                        icon: Image.asset(
                                            'lib/assets/clicking.png'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
