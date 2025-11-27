import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import 'saving.dart';

const Map<int, String> paymentCategoryNames = {
  1: '食費',
  2: 'お菓子',
  3: 'ライブ代',
  4: '交通費',
  5: 'その他',
  6: '貯金',
};

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

  Map<String, int> categoryAllocations = {};

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

    final allocations = await dbHelper.getAllCategoryAllocations();

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

      categoryAllocations = allocations;
    });
  }

  Widget _buildIncomeCategoryTotal(String label, int amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '$label: ${amount.toString()} 円',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildCategoryDetail(int categoryId, String label, int currentAmount) {
    final allocationAmount = categoryAllocations[label] ?? 0;

    if (allocationAmount > 0) {
      final remainingAmount = allocationAmount - currentAmount;

      final String remainingText;
      final Color textColor;

      if (remainingAmount >= 0) {
        remainingText = '残り ${remainingAmount.toString()} 円';
        textColor = Colors.green;
      } else {
        remainingText = '超過 ${remainingAmount.abs().toString()} 円';
        textColor = Colors.deepOrange;
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              child: Text(
                '$label:',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 10),

            Text(
              '${currentAmount.toString()} 円 /',
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(width: 5),

            Text(
              remainingText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      );
    } else {
      return _buildIncomeCategoryTotal(label, currentAmount);
    }
  }

  int get diffirenceMoney {
    final diffirence = totalIncome - totalPayment;
    return diffirence;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('pokemoney'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                '収入',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '${totalIncome.toString()}円',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildIncomeCategoryTotal('おこづかい', categoryIncomeTotals[1] ?? 0),
              _buildIncomeCategoryTotal('バイト代', categoryIncomeTotals[2] ?? 0),
              _buildIncomeCategoryTotal('その他', categoryIncomeTotals[3] ?? 0),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 30),

              const Text(
                '支出',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                '${totalPayment.toString()}円',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              _buildCategoryDetail(
                1,
                paymentCategoryNames[1]!,
                categoryPaymentTotals[1] ?? 0,
              ),
              _buildCategoryDetail(
                2,
                paymentCategoryNames[2]!,
                categoryPaymentTotals[2] ?? 0,
              ),
              _buildCategoryDetail(
                3,
                paymentCategoryNames[3]!,
                categoryPaymentTotals[3] ?? 0,
              ),
              _buildCategoryDetail(
                4,
                paymentCategoryNames[4]!,
                categoryPaymentTotals[4] ?? 0,
              ),
              _buildCategoryDetail(
                5,
                paymentCategoryNames[5]!,
                categoryPaymentTotals[5] ?? 0,
              ),
              SizedBox(height: 20),
              Text('あまり: ${diffirenceMoney}円', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
