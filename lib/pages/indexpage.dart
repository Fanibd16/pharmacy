import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:iconly/iconly.dart';
// import 'package:pharmacy/map/flutter_map.dart';
// import 'package:pharmacy_app/map/flutter_map.dart';
// import 'package:pharmacy_app/map/map.dart';
// import 'package:pharmacy/pages/bookmark.dart';
import 'package:pharmacy/pages/homepage.dart';
// import 'package:pharmacy/pages/map.dart';
import 'package:pharmacy/pages/profile.dart';
// import 'package:pharmacy/pages/map.dart';
// import 'package:pharmacy/pages/map.dart';
import 'package:pharmacy/pages/qr_sacan_page.dart';

enum _SelectedTab { home, add, favorite, person }

class IndexPage extends StatefulWidget {
  final String token;
  const IndexPage({super.key, required this.token});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  _SelectedTab _selectedTab = _SelectedTab.home;

  // Extract first name from JWT token
  String _getFirstNameFromToken(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    // String fullName = decodedToken['name'] ; // Assuming 'name' field contains the full name
    String fullName = decodedToken['name'] ??
        "User"; // Assuming 'name' field contains the full name
    return fullName.split(' ')[0]; // Get the first name
  }

  void _handleIndexChanged(int index) {
    setState(() {
      _selectedTab = _SelectedTab.values[index];
    });
  }

  Widget _getPageForTab(_SelectedTab tab) {
    String firstName = _getFirstNameFromToken(widget.token);
    switch (tab) {
      case _SelectedTab.home:
        return HomePage(firstName: firstName);
      case _SelectedTab.add:
        return const UniversalBarcodeScanner();
      case _SelectedTab.favorite:
        return const SettingsPage();
      case _SelectedTab.person:
        return const SettingsPage();
      // return MapScreen();
      // return const MapScreen();
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
            icon: const Icon(IconlyLight.bookmark),
            title: const Text('Bookmark'),
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

// class QRViewExample extends StatelessWidget {
//   const QRViewExample({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
