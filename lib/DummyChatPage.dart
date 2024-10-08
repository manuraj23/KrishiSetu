import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ChatRoom.dart'; // Import ChatRoom widget

class DummyChatPage extends StatefulWidget {
  @override
  _DummyChatPageState createState() => _DummyChatPageState();
}

class _DummyChatPageState extends State<DummyChatPage> {
  bool isLoading = false;
  String? userEmail;
  final TextEditingController _searchController = TextEditingController();
  List<String> allUserEmails = [];
  bool isAllUsersLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
  }

  void _fetchAllUsers() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

      List<String> emails = querySnapshot.docs
          .map((doc) => doc['email'] as String)
          .where((email) => email != currentUserEmail) // Exclude current user
          .toList();

      setState(() {
        allUserEmails = emails;
        isAllUsersLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() {
        isAllUsersLoading = false;
      });
    }
  }

  void onSearch() async {
    final searchTerm = _searchController.text.trim();

    if (searchTerm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an email address')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: searchTerm)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userEmail = querySnapshot.docs[0]['email'] as String?;
        });
      } else {
        setState(() {
          userEmail = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String getChatRoomId(String user1, String user2) {
    if (user1.compareTo(user2) > 0) {
      return "$user1\_$user2";
    } else {
      return "$user2\_$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search User'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter user email',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: onSearch,
            child: Text('Search'),
          ),
          userEmail != null
              ? ListTile(
            title: Text(userEmail!),
            onTap: () {
              String currentUserEmail =
              FirebaseAuth.instance.currentUser!.email!;
              String chatRoomId =
              getChatRoomId(userEmail!, currentUserEmail);

              Map<String, dynamic> userMap = {
                'email': userEmail!,
                'name': userEmail!.split('@')[0],
                'uid': 'some_user_id',
              };

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoom(
                    chatRoomId: chatRoomId,
                    userMap: userMap,
                  ),
                ),
              );
            },
          )
              : Container(),
          Expanded(
            child: isAllUsersLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: allUserEmails.length,
              itemBuilder: (context, index) {
                final userEmail = allUserEmails[index];
                return ListTile(
                  title: Text(userEmail),
                  onTap: () {
                    String currentUserEmail =
                    FirebaseAuth.instance.currentUser!.email!;
                    String chatRoomId =
                    getChatRoomId(userEmail, currentUserEmail);

                    Map<String, dynamic> userMap = {
                      'email': userEmail,
                      'name': userEmail.split('@')[0],
                      'uid': 'some_user_id',
                    };

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoom(
                          chatRoomId: chatRoomId,
                          userMap: userMap,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
