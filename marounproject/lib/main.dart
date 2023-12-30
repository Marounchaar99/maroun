import 'package:flutter/material.dart';
import 'package:marounproject/Pages/Home.dart';
import 'package:marounproject/Pages/Login.dart';
import 'package:marounproject/Pages/Register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
    );
  }
}