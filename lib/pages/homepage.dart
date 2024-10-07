import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:pharmacy/map/flutter_map.dart';
// import 'package:paybirr/utility/horiontal_card.dart';
// import 'package:paybirr/pages/search_page.dart';
import 'package:pharmacy/pages/search_page.dart';
import 'package:pharmacy/utility/horiontal_card.dart';

class HomePage extends StatefulWidget {
  final String firstName; // Changed from email to first name
  const HomePage({super.key, required this.firstName});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isBalanceVisible = true;

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                'Hi, ${widget.firstName}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '22 Jan , 2024',
                                style: TextStyle(color: Colors.white38),
                              ),
                            ],
                          ),
                          Container(
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
                          child: const Row(
                            children: [
                              SizedBox(width: 15),
                              Icon(IconlyLight.search),
                              SizedBox(width: 10),
                              Text('Search'),
                              Spacer(),
                              // Icon(IconlyLight.scan),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(40.0),
                      ),
                    ),
                    height: 600,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TabBar(
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            indicator: BoxDecoration(
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
                                  'Poplar',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  'Map',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
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
