import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:iconly/iconly.dart';
import 'package:pharmacy/pages/history_page.dart';
import 'package:pharmacy/pages/homepage.dart';
import 'package:pharmacy/pages/profile.dart';
import 'package:pharmacy/pages/qr_sacan_page.dart';
// import 'package:pharmacy/pages/settings_page.dart';
import 'package:pharmacy/utility/localization_lang.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _SelectedTab { home, add, favorite, person }

class IndexPage extends StatefulWidget {
  final String token;
final Function(String) onChangeLanguage; 
  const IndexPage({
    super.key,
    required this.token, required String languageCode, required this.onChangeLanguage,
  });

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  _SelectedTab _selectedTab = _SelectedTab.home;
  String firstName = '';
  String fullName = '';
  String language = 'en'; // Default to English; initialize directly here

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference(); // Fetch the language preference
    _getFirstNameFromToken(widget.token); // Fetch the first name on init
  }

  Future<void> _getFirstNameFromToken(String token) async {
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String fullName = decodedToken['fullName'] ?? "User";
      List<String> nameParts = fullName.split(' ');
      String firstName = nameParts.isNotEmpty ? nameParts[0] : "User";

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', firstName); // Save first name
      await prefs.setString('fullName', fullName); // Save full name

      setState(() {
        this.firstName = firstName;
        this.fullName = fullName;
      });
    } catch (e) {
      print('Error decoding token or saving preferences: $e');
    }
  }

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      language = prefs.getString('languageCode') ?? language; // Use the initialized value or fallback
    });
  }

  Future<void> _changeLanguage(String langCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', langCode);
    setState(() {
      language = langCode;
    });
  }

  String _translate(String key) {
    String langCode = language == 'en' ? 'en' : 'am';
    return localizedText[langCode]?[key] ?? key;
  }

  void _handleIndexChanged(int index) {
    setState(() {
      _selectedTab = _SelectedTab.values[index];
    });
  }

  Widget _getPageForTab(_SelectedTab tab) {
    switch (tab) {
      case _SelectedTab.home:
        return HomePage(firstName: firstName, languageCode: language); // Pass the language code
      case _SelectedTab.add:
        return const UniversalBarcodeScanner();
      case _SelectedTab.favorite:
        return const HistoryScreen();
      case _SelectedTab.person:
        return SettingsPage(
          fullName: fullName,
          onChangeLanguage: _changeLanguage, // Pass the language change callback
        );
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
            title: Text(_translate('home')), // Localized title
          ),
          FlashyTabBarItem(
            icon: const Icon(IconlyLight.scan),
            title: Text(_translate('scan')), // Localized title
          ),
          FlashyTabBarItem(
            icon: const Icon(IconlyLight.activity),
            title: Text(_translate('history')), // Localized title
          ),
          FlashyTabBarItem(
            icon: const Icon(IconlyLight.profile),
            title: Text(_translate('profile')), // Localized title
          ),
        ],
      ),
    );
  }
}
