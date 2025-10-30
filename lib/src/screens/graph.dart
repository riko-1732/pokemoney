import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import 'saving.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key, required this.title});

  final String title;

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  final dbHelper = DatabaseHelper();

  int totalIncome = 0;
  int totalPayment = 0;

  Map<int, int> categoryIncomeTotals = {};
  Map<int, int> categoryPaymentTotals = {};

  @override
  void initState() {
    super.initState();
    _loadAllTotals();
  }

  Future<void> _loadAllTotals() async {
    final income = await dbHelper.queryTotalIncome();
    final payment = await dbHelper.queryTotalPayment();

    final firstIncomeTotal = await dbHelper.queryTotalIncomeByCategory(1);
    final secondIncomeTotal = await dbHelper.queryTotalIncomeByCategory(2);
    final thirdIncomeTotal = await dbHelper.queryTotalIncomeByCategory(3);

    final firstPaymentTotal = await dbHelper.queryTotalPaymentByCategory(1);
    final secondPaymentTotal = await dbHelper.queryTotalPaymentByCategory(2);
    final thirdPaymentTotal = await dbHelper.queryTotalPaymentByCategory(3);
    final fourthPaymentTotal = await dbHelper.queryTotalPaymentByCategory(4);
    final fifthPaymentTotal = await dbHelper.queryTotalPaymentByCategory(5);

    setState(() {
      totalIncome = income;
      categoryIncomeTotals = {
        1: firstIncomeTotal,
        2: secondIncomeTotal,
        3: thirdIncomeTotal,
      };
      totalPayment = payment;
      categoryPaymentTotals = {
        1: firstPaymentTotal,
        2: secondPaymentTotal,
        3: thirdPaymentTotal,
        4: fourthPaymentTotal,
        5: fifthPaymentTotal,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('pokemoney'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('収入'),
            const SizedBox(height: 10),
            Text(
              '${totalIncome.toString()}円',
              style: const TextStyle(fontSize: 24),
            ),
            _buildCategoryTotal('おこづかい', categoryIncomeTotals[1] ?? 0),
            _buildCategoryTotal('バイト代', categoryIncomeTotals[2] ?? 0),
            _buildCategoryTotal('その他', categoryIncomeTotals[3] ?? 0),
            const SizedBox(height: 30),
            const Text('支出'),
            Text(
              '${totalPayment.toString()}円',
              style: const TextStyle(fontSize: 24),
            ),
            _buildCategoryTotal('食費', categoryPaymentTotals[1] ?? 0),
            _buildCategoryTotal('お菓子', categoryPaymentTotals[2] ?? 0),
            _buildCategoryTotal('ライブ代', categoryPaymentTotals[3] ?? 0),
            _buildCategoryTotal('交通費', categoryPaymentTotals[4] ?? 0),
            _buildCategoryTotal('貯金', categoryPaymentTotals[5] ?? 0),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

Widget _buildCategoryTotal(String label, int amount) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Text(
      '$label: ${amount.toString()} 円',
      style: const TextStyle(fontSize: 16),
    ),
  );
}
