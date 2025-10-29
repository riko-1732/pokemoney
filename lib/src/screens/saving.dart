import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokemoney/src/database/database_helper.dart';

class SavingPage extends StatefulWidget {
  const SavingPage({super.key, required this.title});

  final String title;

  @override
  State<SavingPage> createState() => _SavingPageState();
}

class _SavingPageState extends State<SavingPage> {
  final dbHelper = DatabaseHelper();
  int totalIncome = 0;
  int totalPayment = 0;

  @override
  void initState() {
    super.initState();
    _loadAllTotals();
  }

  Future<void> _loadAllTotals() async {
    final income = await dbHelper.queryTotalIncome();
    final expense = await dbHelper.queryTotalExpense();
    setState(() {
      totalIncome = income;
      totalPayment = expense;
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
            const Text('今月の収入'),
            const SizedBox(height: 20),
            Text('${totalIncome.toString()}円'),
            const SizedBox(height: 30),
            const Text('今月の支出'),
            const SizedBox(height: 20),
            Text('${totalPayment.toString()}円'),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
