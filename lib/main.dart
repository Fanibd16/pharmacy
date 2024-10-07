// import 'package:flutter/material.dart';
// import 'package:pharmacy/onboarding/onboarding_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Pharmacy',
//       theme: ThemeData(
//           // primarySwatch: Colors.blue,
//           ),
//       home: const OnboardingScreen(),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:pharmacy/onboarding/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pharmacy/pages/login_page.dart'; // Import your login page
import 'package:pharmacy/pages/indexpage.dart'; // Import your index page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  String? _token;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? stayLoggedIn = prefs.getBool('stayLoggedIn');
    String? token = prefs.getString('token');

    setState(() {
      _isLoggedIn = (stayLoggedIn == true && token != null);
      _token = token; // Save the token to the state
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pharmacy',
      theme: ThemeData(),
      // Use the stored token for navigation if the user is logged in
      home: _isLoggedIn ? IndexPage(token: _token!) : const OnboardingScreen(),
    );
  }
}
