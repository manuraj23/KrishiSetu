import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Dummy_sender.dart'; // Import the FirstPage here

class SecondPage extends StatefulWidget {
  final String value1;
  final String value2;
  final String value3;

  SecondPage({required this.value1, required this.value2, required this.value3});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  // State variables for checkboxes
  bool _isChecked1 = false;
  bool _isChecked2 = false;

  Future<void> _finalize() async {
    // Get a reference to Firestore
    final firestore = FirebaseFirestore.instance;

    // Create a document in the 'contracts' collection
    try {
      await firestore.collection('contracts').add({
        'value1': widget.value1,
        'value2': widget.value2,
        'value3': widget.value3,
        'timestamp': FieldValue.serverTimestamp(), // Add a timestamp for reference
      });
      // Navigate back to FirstPage after finalizing
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => FirstPage()),
      );
    } catch (e) {
      // Handle errors, if any
      print('Error adding document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contracts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'asset/images/image.png', // Correct path to your image asset
                  height: 200, // Adjust as needed
                  width: 200,  // Adjust as needed
                ),
              ),
            ),
            Expanded(flex: 1, child: Text('Government of India')),
            Expanded(flex: 1, child: Text('Contract Farming Agreement')),
            Expanded(flex: 1, child: Text('Agreement between Farmer and Contractor')),
            Expanded(
                flex: 2,
                child: Text(
                    'for use when a stipulated price forms the basic payment and to be used only with the general conditions of the contract')),
            Expanded(
                flex: 1,
                child: Text(
                    'By and Between ${widget.value1}, ${widget.value2} at ${widget.value3}')),

            // First row with a checkbox and text
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Checkbox(
                    value: _isChecked1,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isChecked1 = newValue!;
                      });
                    },
                  ),
                  Text(
                    'I have read and understood the terms',
                    style: TextStyle(
                      color: _isChecked1 ? Colors.green : Colors.black, // Text color changes based on checkbox state
                    ),
                  ),
                ],
              ),
            ),

            // Second row with a checkbox and text
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Checkbox(
                    value: _isChecked2,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isChecked2 = newValue!;
                      });
                    },
                  ),
                  Text(
                    'The details I filled are correct. If found wrong,',
                    style: TextStyle(
                      color: _isChecked2 ? Colors.green : Colors.black, // Text color changes based on checkbox state
                    ),
                  ),
                ],
              ),
            ),

            // Finalize Button
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  // Show a confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Finalize'),
                        content: Text('Are you sure you want to finalize?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                              _finalize(); // Call the finalize function
                            },
                            child: Text('Finalize'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Finalize'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
