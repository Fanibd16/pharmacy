import 'package:flutter/material.dart';
import 'package:pharmacy/onboarding/onboarding_screen.dart';
import 'package:pharmacy/pages/indexpage.dart'; // Import your index page
import 'package:pharmacy/utility/localization_lang.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String _languageCode = 'en'; // Default language

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadLanguage();
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

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('languageCode') ?? 'en'; // Default to English
    setState(() {
      _languageCode = langCode; // Load the saved language code
    });
  }

 void _changeLanguage(String langCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', langCode);
    setState(() {
      _languageCode = langCode; // Update the state with the new language
    });
}

  String _translate(String key) {
    return localizedText[_languageCode]?[key] ?? key; // Return the localized text
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pharmacy',
      theme: ThemeData(),
      home: _isLoggedIn
          ? IndexPage(
              token: _token!, // Unwrap the token safely, ensure _isLoggedIn is true
              languageCode: _languageCode, // Pass language code to IndexPage
              onChangeLanguage: _changeLanguage, // Pass language change callback
            )
          : const OnboardingScreen(),
    );
  }
}
