import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.title});

  final String title;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  DateTime selectedDate = DateTime.now();
  int selectValue = 0;
  String result = "";

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
            const Text('支出を入力'),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            Wrap(
              spacing: 10,
              children: [
                ChoiceChip(
                  label: Text("食事"),
                  selected: selectValue == 1,
                  onSelected: (bool isSelected) {
                    setState(() {
                      selectValue = isSelected ? 1 : 0;
                      result = selectValue.toString();
                    });
                  },
                ),
                ChoiceChip(
                  label: Text("お菓子"),
                  selected: selectValue == 2,
                  onSelected: (bool isSelected) {
                    setState(() {
                      selectValue = isSelected ? 2 : 0;
                      result = selectValue.toString();
                    });
                  },
                ),
                ChoiceChip(
                  label: Text("ライブ代"),
                  selected: selectValue == 3,
                  onSelected: (bool isSelected) {
                    setState(() {
                      selectValue = isSelected ? 3 : 0;
                      result = selectValue.toString();
                    });
                  },
                ),
                ChoiceChip(
                  label: Text("交通費"),
                  selected: selectValue == 4,
                  onSelected: (bool isSelected) {
                    setState(() {
                      selectValue = isSelected ? 4 : 0;
                      result = selectValue.toString();
                    });
                  },
                ),
                ChoiceChip(
                  label: Text("その他"),
                  selected: selectValue == 5,
                  onSelected: (bool isSelected) {
                    setState(() {
                      selectValue = isSelected ? 5 : 0;
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
