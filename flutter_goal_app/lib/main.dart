import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() => runApp(const GoalApp());

class GoalApp extends StatelessWidget {
  const GoalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Goal Tracker',
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomePage(),
    );
  }
}
