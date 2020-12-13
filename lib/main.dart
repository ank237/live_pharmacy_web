import 'package:flutter/material.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
      ),
    );
  }
}
