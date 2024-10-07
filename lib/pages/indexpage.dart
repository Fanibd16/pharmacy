import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:iconly/iconly.dart';
import 'package:pharmacy/pages/history_page.dart';
import 'package:pharmacy/pages/homepage.dart';
import 'package:pharmacy/pages/profile.dart';
import 'package:pharmacy/pages/qr_sacan_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _SelectedTab { home, add, favorite, person }

class IndexPage extends StatefulWidget {
  final String token;
  const IndexPage({super.key, required this.token});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  _SelectedTab _selectedTab = _SelectedTab.home;
  String firstName = '';
  String fullName = '';

  @override
  void initState() {
    super.initState();
    _getFirstNameFromToken(widget.token); // Fetch the first name on init
  }

Future<void> _getFirstNameFromToken(String token) async {
  try {
    // Decode the JWT token
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    // Get the full name from the decoded token, defaulting to "User" if not found
    String fullName = decodedToken['fullName'] ?? "User";

    // Split the full name by spaces
    List<String> nameParts = fullName.split(' ');

    // Extract the first name (if it exists)
    String firstName = nameParts.isNotEmpty ? nameParts[0] : "User";

    // Save the first name to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstName); // Save first name
    await prefs.setString('fullName', fullName); // Save full name

    // Update the state with the fetched first name and full name
    setState(() {
      this.firstName = firstName;
      this.fullName = fullName;
    });
  } catch (e) {
    // Handle any exceptions that occur during token decoding or preferences saving
    print('Error decoding token or saving preferences: $e');
  }
}


  void _handleIndexChanged(int index) {
    setState(() {
      _selectedTab = _SelectedTab.values[index];
    });
  }

  Widget _getPageForTab(_SelectedTab tab) {
    switch (tab) {
      case _SelectedTab.home:
        return HomePage(firstName: firstName);
      case _SelectedTab.add:
        return const UniversalBarcodeScanner();
      case _SelectedTab.favorite:
        return const HistoryScreen();
      case _SelectedTab.person:
        return SettingsPage(fullName: fullName);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPageForTab(_selectedTab),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _SelectedTab.values.indexOf(_selectedTab),
        iconSize: 28,
        showElevation: false,
        onItemSelected: _handleIndexChanged,
        items: [
          FlashyTabBarItem(
            icon: const Icon(IconlyLight.home),
            title: const Text('Home'),
          ),
          FlashyTabBarItem(
            icon: const Icon(IconlyLight.scan),
            title: const Text('Scan'),
          ),
          FlashyTabBarItem(
            icon: const Icon(IconlyLight.activity),
            title: const Text('History'),
          ),
          FlashyTabBarItem(
            icon: const Icon(IconlyLight.profile),
            title: const Text('Profile'),
          ),
        ],
      ),
    );
  }
}
