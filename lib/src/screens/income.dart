import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key, required this.title});

  final String title;

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final TextEditingController _moneyController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  int selectValue = 0;
  String result = "";
  String _getCategoryText(int value) {
    switch (value) {
      case 1:
        return "おこづかい";
      case 2:
        return "バイト代";
      case 3:
        return "その他";
      default:
        return "未選択";
    }
  }

  void _confirmIncome() {
    // 入力値を取得
    final String moneyText = _moneyController.text;
    final String categoryText = _getCategoryText(selectValue);
    final String dateText =
        '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}';

    setState(() {
      if (moneyText.isNotEmpty && selectValue != 0) {
        result = '収入を記録しました: ${dateText}に${categoryText}で${moneyText}円';
      } else if (moneyText.isEmpty) {
        result = '金額を入力してください';
      } else {
        result = 'カテゴリを選択してください';
      }

      // 入力値のリセット
      _moneyController.clear(); // 金額をリセット
      selectValue = 0; // カテゴリをリセット
      selectedDate = DateTime.now();
    });
  }

  @override
  void dispose() {
    _moneyController.dispose();
    super.dispose();
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
            const Text('収入を入力'),
            TextField(
              controller: _moneyController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            Wrap(
              spacing: 10,
              children: [
                ChoiceChip(
                  label: Text("おこづかい"),
                  selected: selectValue == 1,
                  onSelected: (bool isSelected) {
                    setState(() {
                      selectValue = isSelected ? 1 : 0;
                      result = selectValue.toString();
                    });
                  },
                ),
                ChoiceChip(
                  label: Text("バイト代"),
                  selected: selectValue == 2,
                  onSelected: (bool isSelected) {
                    setState(() {
                      selectValue = isSelected ? 2 : 0;
                      result = selectValue.toString();
                    });
                  },
                ),
                ChoiceChip(
                  label: Text("その他"),
                  selected: selectValue == 3,
                  onSelected: (bool isSelected) {
                    setState(() {
                      selectValue = isSelected ? 3 : 0;
                      result = selectValue.toString();
                    });
                  },
                ),
              ],
            ),

            Text(
              '日付: ${selectedDate.year}/${selectedDate.month}/${selectedDate.day}',
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('日付選択'),
            ),
            ElevatedButton(onPressed: _confirmIncome, child: Text('確定')),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                result.isEmpty ? '入力待ち...' : result,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: result.startsWith('⚠️') ? Colors.red : Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
