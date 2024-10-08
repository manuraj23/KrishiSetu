import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_setu/pages/login_page.dart';
import 'package:krishi_setu/utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


void main() async{
  await setup();
  runApp(const MyApp());
}

Future<void> setup() async{
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirbase();
  await registerServices();

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home:NewLoginPage(),
    );
  }
}

