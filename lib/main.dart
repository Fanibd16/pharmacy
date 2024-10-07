import 'package:flutter/material.dart';
import 'package:pharmacy/onboarding/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pharmacy',
      theme: ThemeData(
          // primarySwatch: Colors.blue,
          ),
      home: const OnboardingScreen(),
    );
  }
}
