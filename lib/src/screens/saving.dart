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

  // 追加①：カテゴリごとの割り当て金額
  Map<String, int> categoryAllocations = {"食費": 0, "お菓子": 0, "貯金": 0};

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

  // 追加②：残り金額を計算
  int get remainingIncome {
    int used = categoryAllocations.values.fold(0, (sum, val) => sum + val);
    return totalIncome - used;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('pokemoney'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              const Text('今月の収入', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text(
                '${totalIncome.toString()}円',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 30),

              // 追加③：カテゴリ入力欄
              for (final entry in categoryAllocations.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 40,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: '${entry.key} の金額',
                      suffixText: '円',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      setState(() {
                        categoryAllocations[entry.key] =
                            int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),

              const SizedBox(height: 20),
              Text(
                '残りの収入：${remainingIncome}円',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _loadAllTotals,
                child: const Text('最新の合計額を更新'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
