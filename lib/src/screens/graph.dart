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

  @override
  void initState() {
    super.initState();
    _loadAllTotals();
  }

  Future<void> _loadAllTotals() async {
    final income = await dbHelper.queryTotalIncome();
    final payment = await dbHelper.queryTotalPayment();
    if (!mounted) return;
    setState(() {
      totalIncome = income;
      totalPayment = payment;
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
            const SizedBox(height: 30),
            const Text('支出'),
            Text(
              '${totalPayment.toString()}円',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
