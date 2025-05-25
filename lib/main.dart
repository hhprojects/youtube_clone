import 'package:flutter/material.dart';
import 'screens/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Music Player',
      theme: ThemeData(
        primaryColor: const Color(0xFF1F1B24),
        scaffoldBackgroundColor: const Color(0xFF1F1B24),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
