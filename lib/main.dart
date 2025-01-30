
import 'package:flutter/material.dart';

import 'view/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agora Video Call',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.amber, // Set the AppBar background color
        ),
      ),
      home: HomePage(), // Set the HomePage as the initial screen
    );
  }
}