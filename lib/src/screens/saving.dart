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

  Map<String, int> categoryAllocations = {
    "食費": 0,
    "お菓子": 0,
    "ライブ代": 0,
    "交通費": 0,
  };

  // TextEditingControllerをカテゴリごとに保持
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initControllers();
    _loadAllTotals();
    _loadCategoryAllocations();
  }

  void _initControllers() {
    for (var key in categoryAllocations.keys) {
      _controllers[key] = TextEditingController(text: '');
    }
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

  Future<void> _loadCategoryAllocations() async {
    final data = await dbHelper.getAllCategoryAllocations();
    if (!mounted) return;
    setState(() {
      for (var key in categoryAllocations.keys) {
        categoryAllocations[key] = data[key] ?? 0;
        _controllers[key]?.text = (data[key] ?? 0).toString();
      }
    });
  }

  // データをDBに保存
  Future<void> _saveCategory(String name, int amount) async {
    await dbHelper.upsertCategoryAllocation(name, amount);
  }

  // 残り金額を計算
  int get remainingIncome {
    int used = categoryAllocations.values.fold(0, (sum, val) => sum + val);
    return totalIncome - used;
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              const Text('今月の収入', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text(
                '${totalIncome.toString()}円',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 30),

              // カテゴリ入力欄
              for (final entry in categoryAllocations.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 40,
                  ),
                  child: TextField(
                    controller: _controllers[entry.key],
                    decoration: InputDecoration(
                      labelText: '${entry.key} の金額',
                      suffixText: '円',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) async {
                      final newVal = int.tryParse(value) ?? 0;
                      setState(() {
                        categoryAllocations[entry.key] = newVal;
                      });
                      await _saveCategory(entry.key, newVal); // 入力のたびに保存
                    },
                  ),
                ),

              const SizedBox(height: 20),
              Text(
                '貯金額：${remainingIncome}円',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
