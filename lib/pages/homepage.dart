import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:pharmacy/map/flutter_map.dart';
import 'package:pharmacy/pages/search_page.dart';
import 'package:pharmacy/utility/horiontal_card.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:pharmacy/utility/localization_lang.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For accessing preferences

class HomePage extends StatefulWidget {
  final String firstName; // Changed from email to first name
  final String languageCode; // Add language code parameter

  const HomePage(
      {super.key, required this.firstName, required this.languageCode});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isBalanceVisible = true;
  String language = 'en'; // Default language code

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference(); // Fetch language preference on init
  }

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      language = prefs.getString('languageCode') ??
          widget
              .languageCode; // Load from shared preferences or default to passed value
    });
  }

  String _translate(String key) {
    String langCode = language == 'en'
        ? 'en'
        : 'am'; // Use language code to get the right translation
    return localizedText[langCode]?[key] ?? key;
  }

  Future<void> showNoNotificationDialog(BuildContext context) async {
    await showOkAlertDialog(
      context: context,
      title: _translate('notification'), // Localized title
      message: _translate('no_notification'), // Localized message
      okLabel: 'OK',
    );
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current date
    String currentDate = DateFormat('dd MMM, yyyy').format(DateTime.now());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xff674fff),
              Color(0xff9775dc),
            ]),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_translate('greeting')}, ${widget.firstName}', // Localized greeting
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentDate, // Display current date
                                style: const TextStyle(color: Colors.white38),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              showNoNotificationDialog(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                IconlyBold.notification,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MedicineSelector(),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 15),
                              const Icon(IconlyLight.search),
                              const SizedBox(width: 10),
                              Text(_translate(
                                  'search')), // Localized search text
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40.0),
                      ),
                    ),
                    height: 600,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TabBar(
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            indicator: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xff674fff),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            tabs: [
                              Tab(
                                child: Text(
                                  _translate(
                                      'popular'), // Localized text for 'Popular'
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  _translate('map'), // Localized text for 'Map'
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Expanded(
                            child: TabBarView(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Hcard(),
                                ),
                                MapScreen(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
