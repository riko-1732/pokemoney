import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/income.dart';
import 'screens/payment.dart';
import 'screens/saving.dart';
import 'screens/calendar.dart';
import 'screens/graph.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 0, 0, 0),
          onPrimary: Colors.white,
          secondary: Color.fromARGB(255, 224, 224, 224),
          onSecondary: Color.fromARGB(255, 0, 0, 0),
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        primarySwatch: Colors.grey,
        textTheme: GoogleFonts.ibmPlexSansJpTextTheme(
          Theme.of(context).textTheme,
        ),
      ),

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
    SavingPage(title: '貯金'),
    GraphPage(title: 'データ'),
    CalenderPage(title: 'カレンダー'),
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
          BottomNavigationBarItem(icon: Icon(Icons.savings), label: '貯金'),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'データ'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'カレンダー',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
