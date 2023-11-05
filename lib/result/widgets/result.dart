import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String myVariable1;
  final String myVariable2;

  const ResultPage(this.myVariable1, this.myVariable2, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Result'),
        ),
        body: Center(
          child: Column(
            children: [
              Center(
                child: Text(
                  myVariable1,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              Text(
                myVariable2,
                style: const TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
