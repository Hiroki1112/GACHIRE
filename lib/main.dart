import 'package:flutter/material.dart';
import './HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "GACHIRE",
      home: HomeScreen(),
    );
  }
}
