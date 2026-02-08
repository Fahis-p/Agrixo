import 'dart:io';
import 'package:flutter/material.dart';

import '../widgets/add_expense_dialog.dart';
import '../widgets/add_income_dialog.dart';
import '../screens/configuration_page.dart';
import '../widgets/market_notification_dialog.dart';
import '../screens/analysis/analytics_page.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../services/category_service.dart';
import '../services/transaction_service.dart';
import '../services/expense_type_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> expenseCategories = [];
  List<CategoryModel> incomeCategories = [];
  List<TransactionModel> recentTransactions = [];
  Map<String, String> transactionTypeEmojis = {};

  double todayExpense = 0;
  double todayIncome = 0;
  double balance = 0;

  @override
  void initState() {
    super.initState();
    _loadExpCategories();
    _loadIncCategories();
    _loadDashboardData();
    _loadTransactionTypeEmojis();
  }

  // ================= LOAD CATEGORIES =================
  Future<void> _loadExpCategories() async {
    expenseCategories = await CategoryService.getLastCategories(
      type: 'expense',
      limit: 50,
    );
    setState(() {});
  }

  Future<void> _loadIncCategories() async {
    incomeCategories = await CategoryService.getLastCategories(
      type: 'income',
      limit: 50,
    );
    setState(() {});
  }

  // ================= LOAD DASHBOARD =================
  Future<void> _loadDashboardData() async {
    final today = DateTime.now().toIso8601String().split('T').first;
    final transactions = await TransactionService.getTransactionsByDate(today);

    double expense = 0;
    double income = 0;

    for (final t in transactions) {
      if (t.type == 'expense') {
        expense += t.amount;
      } else {
        income += t.amount;
      }
    }

    setState(() {
      todayExpense = expense;
      todayIncome = income;
      balance = income - expense;
      recentTransactions = transactions.take(5).toList();
    });
  }

  // ================= LOAD EMOJIS =================
  Future<void> _loadTransactionTypeEmojis() async {
    final map = <String, String>{};

    final expenseTypes = await ExpenseTypeService.getExpenseTypes(
      type: 'expense',
    );
    final incomeTypes = await ExpenseTypeService.getExpenseTypes(
      type: 'income',
    );

    for (final t in [...expenseTypes, ...incomeTypes]) {
      if (t.emoji.isNotEmpty) {
        map[t.name] = t.emoji;
      }
    }

    setState(() => transactionTypeEmojis = map);
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Agrixo',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4E7D5B),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const MarketNotificationDialog(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.analytics_sharp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AnalyticsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ConfigurationPage()),
              );
              _loadDashboardData();
              _loadExpCategories();
              _loadIncCategories();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Farm Transactions',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            /// SUMMARY CARD
            _summaryCard(),

            const SizedBox(height: 16),

            /// ACTION BUTTONS
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    text: 'Add Expense',
                    icon: Icons.remove_circle_outline,
                    bgColor: const Color(0xFFD32F2F),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const AddExpenseDialog(),
                      );
                      _loadDashboardData();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionButton(
                    text: 'Add Income',
                    icon: Icons.add_circle_outline,
                    bgColor: const Color(0xFF2E7D32),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const AddIncomeDialog(),
                      );
                      _loadDashboardData();
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            const Text(
              'Expense details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            expenseCategories.isEmpty
                ? const Text(
                    'Please add a expence category from configuration to see here',
                  )
                : _categoryRow(expenseCategories),

            const SizedBox(height: 20),

            const Text(
              'Income details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            incomeCategories.isEmpty
                ? const Text(
                    'Please add a income category from configuration to see here',
                  )
                : _categoryRow(incomeCategories),

            const SizedBox(height: 24),

            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            recentTransactions.isEmpty
                ? const Text('No transactions today')
                : Column(
                    children: recentTransactions.map((t) {
                      final isExpense = t.type == 'expense';
                      final emoji = transactionTypeEmojis[t.subType];

                      return ListTile(
                        leading: emoji != null
                            ? Text(emoji, style: const TextStyle(fontSize: 22))
                            : Icon(
                                isExpense
                                    ? Icons.remove_circle
                                    : Icons.add_circle,
                                color: isExpense ? Colors.red : Colors.green,
                              ),
                        title: Text(t.subType),
                        trailing: Text(
                          '${isExpense ? '-' : '+'} ₹${t.amount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isExpense ? Colors.red : Colors.green,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  // ================= SUMMARY CARD =================
  Widget _summaryCard() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: balance),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 170),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            image: const DecorationImage(
              image: AssetImage('assets/images/summary_bg.png'), // ✅ FIXED
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Color(0xFFBFE8C6),
                BlendMode.softLight,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),

          child: Column(
            children: [
              const SizedBox(height: 6),

              /// BALANCE
              Text(
                '₹${value.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4E7D5B),
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                "Today's Balance",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 18),

              /// EXPENSE / INCOME CARDS
              Row(
                children: [
                  Expanded(
                    child: _summaryMiniCard(
                      icon: Icons.arrow_downward_rounded,
                      label: 'Expense',
                      amount: todayExpense,
                      color: const Color(0xFFE53935),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _summaryMiniCard(
                      icon: Icons.arrow_upward_rounded,
                      label: 'Income',
                      amount: todayIncome,
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= SUMMARY MINI CARD =================
  Widget _summaryMiniCard({
    required IconData icon,
    required String label,
    required double amount,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '₹${amount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryPill({
    required IconData icon,
    required String label,
    required double value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              Text(
                '₹${value.toStringAsFixed(0)}',
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= ACTION BUTTON =================
  Widget _actionButton({
    required String text,
    required IconData icon,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: bgColor.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CATEGORY ROW =================
  Widget _categoryRow(List<CategoryModel> categories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3EA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cat.iconPath != null
                      ? Image.file(File(cat.iconPath!), width: 40, height: 40)
                      : const Icon(Icons.category, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    cat.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
