import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SavingPage extends StatefulWidget {
  const SavingPage({super.key, required this.title});

  final String title;

  @override
  State<SavingPage> createState() => _SavingPageState();
}

class _SavingPageState extends State<SavingPage> {
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
          children: <Widget>[const Text('今月の収入')],
        ),
      ),
    );
  }
}
