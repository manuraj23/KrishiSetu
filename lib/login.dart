import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// The main LoginPage widget that takes 'user' as a parameter
class LoginPage extends StatefulWidget {
  final int user;

  // Constructor requires the 'user' parameter
  LoginPage({required this.user});

  @override
  State<StatefulWidget> createState() => LoginPageState(user);
}

// State class for the LoginPage
class LoginPageState extends State<LoginPage> {
  // Boolean to differentiate between two types of users
  bool user = true;

  // Constructor that sets the user type
  LoginPageState(int user) {
    if (user == 2) this.user = false;
  }

  // Controllers for handling text input in text fields
  var userController = TextEditingController();
  var passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scrollable page content
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top container with AppBar and user avatar
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffB9E591), Colors.white],
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // Transparent AppBar
                  AppBar(
                    backgroundColor: Colors.transparent,
                  ),
                  // Circular avatar with image based on user type
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xffA5A5A5),
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 65,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xffDFDFDF)),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 60,
                          // Display different images for different user types
                          child: user
                              ? Image.asset("asset/images/kisan.png")
                              : Image.asset("asset/images/contractor.png"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Welcome text
            Text(
              "Welcome back! Glad",
              style: TextStyle(
                color: Color(0xff266116),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "to see you, Again!",
              style: TextStyle(
                color: Color(0xff266116),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 50),

            // Email or phone number input field
            Container(
              width: 324,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 21),
                      Text(
                        "Email or phone number",
                        style: TextStyle(
                          color: Color(0xff4A4A4A),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 64,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                        controller: userController,
                        decoration: InputDecoration(
                          hintText: "Type here...",
                          prefixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 10),
                              Icon(Icons.email_outlined),
                              SizedBox(width: 10),
                              Text(
                                "|",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Password input field
            Container(
              width: 324,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 21),
                      Text(
                        "Password",
                        style: TextStyle(
                          color: Color(0xff4A4A4A),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 64,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                        controller: passController,
                        decoration: InputDecoration(
                          hintText: "Type here...",
                          prefixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 10),
                              Icon(Icons.keyboard_alt_outlined),
                              SizedBox(width: 10),
                              Text(
                                "|",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Forgot password link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text("Forgot Password?"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Login button
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "LOGIN",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff1A6158),
                minimumSize: Size(320, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),

            SizedBox(height: 10),

            // Social login option
            Text("or login with"),
            SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {},
              child: FaIcon(FontAwesomeIcons.google),
            ),

            // Sign-up option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {},
                  child: Text("Sign Up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
