import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/screens/expenseScreens/expenseForm.dart';
import 'package:my_app/screens/expenseScreens/loandebtForm.dart';
import 'package:my_app/screens/expenseScreens/totalExpense.dart';
import '../../widgets/appColors.dart';

class Expense extends StatefulWidget {
  const Expense({super.key});

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double appBarHeight = deviceWidth * 0.28;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            'Expense Management',
            style: GoogleFonts.adamina(
                color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
          ),
          leading: IconButton(
            onPressed: () => Get.offAllNamed('/mainmenu'),
            icon: const Icon(Icons.arrow_back_ios_new_sharp),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppColors.debtCardColors,
            ),
          ),
          bottom: TabBar(
            isScrollable: false,
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            labelColor: const Color.fromARGB(255, 0, 233, 241),
            unselectedLabelColor: Colors.white,
            tabs: const [
              Tab(text: 'Total Expenses'),
              Tab(text: 'Add Expense'),
              Tab(text: 'Loan Debt'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const TotalExpense(),
          ExpenseForm(),
          const LoanDebt(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
