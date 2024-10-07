import 'package:flutter/material.dart';
import 'package:pharmacy/map/flutter_map.dart';
import 'package:pharmacy/pages/indexpage.dart';
import 'package:pharmacy/pages/login_page.dart';
import 'package:pharmacy/pages/map.dart';
import 'package:pharmacy/pages/profile.dart';
import 'package:pharmacy/pages/qr_sacan_page.dart';
import 'package:pharmacy/pages/registration_page.dart';
import 'package:pharmacy/pages/search_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xff674fff),
          Color(0xff9775dc),
        ])),
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.only(top: 200.0),
            child: Image(image: AssetImage('assets/logo.png'), height: 70.0),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            'Welcome',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            child: Container(
              height: 53,
              width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: const Center(
                child: Text(
                  'SIGN IN',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignUpScreen()));
            },
            child: Container(
              height: 53,
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: const Center(
                child: Text(
                  'SIGN UP',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'Login with Social Media',
            style: TextStyle(fontSize: 17, color: Colors.white),
          ), //
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  // MaterialPageRoute(builder: (context) =>  const SettingsPage()));
                  MaterialPageRoute(
                      builder: (context) => const UniversalBarcodeScanner()));
              // MaterialPageRoute(builder: (context) =>  const MapScreen()));
            },
            child: const Image(
              image: AssetImage('assets/social.png'),
              height: 70.0,
            ),
          )
        ]),
      ),
    );
  }
}
