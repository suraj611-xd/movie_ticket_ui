import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() => runApp(const CineBookApp());

class CineBookApp extends StatelessWidget {
  const CineBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineBook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFFE50914),
      ),
      home: const HomeScreen(),
    );
  }
}
