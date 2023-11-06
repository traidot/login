import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('API Example'),
        ),
        body: Center(
          child: MyApiCallWidget(),
        ),
      ),
    );
  }
}

class MyApiCallWidget extends StatefulWidget {
  @override
  _MyApiCallWidgetState createState() => _MyApiCallWidgetState();
}

class _MyApiCallWidgetState extends State<MyApiCallWidget> {
  String apiUrl =
      'http://localhost:8000/api/auth/email?email=thinhbv@gmail.com'; // Sample API endpoint

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final title = data['title'];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('API Response'),
            content: Text('Title: $title'),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('API Request Failed'),
            content: Text('Status Code: ${response.statusCode}'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: fetchData,
      child: Text('Fetch Data from API'),
    );
  }
}
