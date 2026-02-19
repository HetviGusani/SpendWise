import 'package:flutter/material.dart';
import 'package:spend/screens/splashscreen.dart';
import 'package:spend/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: lightColorScheme),
      home: splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
