import 'package:flutter/material.dart';

import 'screens/income.dart';
import 'screens/payment.dart';
import 'screens/calendar.dart';
import 'screens/graph.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static const _screens = [
    IncomePage(title: '収入'),
    PaymentPage(title: '支出'),
    CalenderPage(title: 'カレンダー'),
    GraphPage(title: 'グラフ'),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.create), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.trending_down), label: '支出'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'カレンダー',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'グラフ'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
