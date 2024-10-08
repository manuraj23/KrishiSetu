import 'package:flutter/material.dart';
import 'Contract.dart'; // Import the SecondPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pass Data Between Pages',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Values to pass
    final value1 = "Value 1";
    final value2 = "Value 2";
    final value3 = "Value 3";

    return Scaffold(
      appBar: AppBar(
        title: Text('First Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // On button press, navigate to the second page and pass the values
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SecondPage(
                  value1: value1,
                  value2: value2,
                  value3: value3,
                ),
              ),
            );
          },
          child: Text('Go to Second Page'),
        ),
      ),
    );
  }
}
