import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:krishi_setu/Contract.dart'; // Assuming this is the correct path for Contract

class ChatRoom extends StatefulWidget {
  final String chatRoomId;
  final Map<String, dynamic> userMap;

  ChatRoom({required this.chatRoomId, required this.userMap});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  TextInputType _keyboardType = TextInputType.text;
  bool _isNumpad = false; // Track if numpad is selected
  bool _isDealFinalized = false; // Track if the deal is finalized
  String? _finalizedDeal; // Store the finalized deal value

  @override
  void initState() {
    super.initState();
    _checkDealStatus();
  }

  void _checkDealStatus() async {
    try {
      final querySnapshot = await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .where('finalizedDeal', isGreaterThan: '') // Check if the field exists and is not empty
          .get();

      setState(() {
        _isDealFinalized = querySnapshot.docs.isNotEmpty;
        if (_isDealFinalized) {
          _finalizedDeal = querySnapshot.docs.first.data()['finalizedDeal'];
        }
      });
    } catch (e) {
      print("Error checking deal status: $e");
    }
  }

  void sendMessage() {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sender": currentUser!.email,
        "message": _messageController.text,
        "time": FieldValue.serverTimestamp(),
        "isNumpad": _isNumpad,
        "accepted": null, // Initially, no action on the message
        "finalizedDeal": null, // Store finalized deal info
      };

      _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messages);

      _messageController.clear();
    }
  }

  void switchKeyboard(TextInputType type, bool isNumpad) {
    setState(() {
      _keyboardType = type;
      _isNumpad = isNumpad;
      _focusNode.unfocus();
      Future.delayed(Duration(milliseconds: 100), () {
        _focusNode.requestFocus();
      });
    });
  }

  // Function to handle "Accept" or "Reject" actions
  void handleAction(String docId, bool isAccepted, String dealValue) async {
    try {
      if (isAccepted) {
        // Update Firestore to store the finalized deal
        await _firestore.collection('chatroom').doc(widget.chatRoomId).collection('chats').doc(docId).update({
          'accepted': true,
          'finalizedDeal': dealValue, // Store the finalized deal value
        });

        // Update other messages with the same deal value
        final querySnapshot = await _firestore.collection('chatroom').doc(widget.chatRoomId).collection('chats')
            .where('message', isEqualTo: dealValue)
            .get();

        for (var doc in querySnapshot.docs) {
          if (doc.data()['accepted'] == null) {
            await doc.reference.update({
              'accepted': true,
              'finalizedDeal': dealValue,
            });
          }
        }

        // Mark deal as finalized on both sender and receiver sides
        setState(() {
          _isDealFinalized = true;
          _finalizedDeal = dealValue;
        });
      } else {
        await _firestore.collection('chatroom').doc(widget.chatRoomId).collection('chats').doc(docId).update({
          'accepted': false,
          'finalizedDeal': null, // No deal if rejected
        });
      }
    } catch (e) {
      print("Error updating Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userMap['name']),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('chatroom')
                  .doc(widget.chatRoomId)
                  .collection('chats')
                  .orderBy('time')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> chatMap =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                      String docId = snapshot.data!.docs[index].id;

                      bool isSender = chatMap['sender'] == currentUser!.email;
                      bool isNumpadMessage = chatMap['isNumpad'] ?? false;
                      String? finalizedDeal = chatMap['finalizedDeal']; // Get finalized deal if any

                      return Column(
                        crossAxisAlignment: isSender
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: 250),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 14),
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 8),
                            decoration: BoxDecoration(
                              color: isNumpadMessage
                                  ? Colors.green[200] // Green for numpad messages
                                  : (isSender
                                  ? Colors.blue[100]
                                  : Colors.grey[300]), // Other message colors
                              borderRadius: isNumpadMessage
                                  ? BorderRadius.circular(5)
                                  : BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chatMap['message'],
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                if (finalizedDeal != null)
                                  Text(
                                    "Deal Finalized at Value: $finalizedDeal",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // Only receiver sees the buttons, not the sender
                          if (isNumpadMessage && chatMap['accepted'] == null && !isSender)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () => handleAction(
                                      docId, true, chatMap['message']), // Accept action
                                  child: Text('Accept',
                                      style: TextStyle(color: Colors.green)),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      handleAction(docId, false, ''), // Reject action
                                  child: Text('Reject',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        keyboardType: _keyboardType,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          labelText: 'Type a message',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: sendMessage,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        switchKeyboard(TextInputType.text, false);
                      },
                      child: Text('CHAT'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        switchKeyboard(TextInputType.number, true);
                      },
                      child: Text('NEGOTIATE'),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Show the "Proceed to Contract" button if the deal is finalized
                if (_isDealFinalized)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContractPage(
                            userMap: widget.userMap,
                            dealValue: _finalizedDeal!, // Pass the finalized deal value
                          ),
                        ),
                      );
                    },
                    child: Text('Proceed to Contract'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Define a new page for the contract
class ContractPage extends StatelessWidget {
  final Map<String, dynamic> userMap;
  final String dealValue;

  ContractPage({required this.userMap, required this.dealValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contract Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contract Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Buyer: ${userMap['name']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Negotiated Price: $dealValue',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
