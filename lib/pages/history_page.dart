

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ScanHistoryScreen extends StatefulWidget {
//   const ScanHistoryScreen({Key? key}) : super(key: key);

//   @override
//   _ScanHistoryScreenState createState() => _ScanHistoryScreenState();
// }

// class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
//   List<Map<String, dynamic>> scanHistory = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadScanHistory(); // Load the scan history when the screen initializes
//   }

//   Future<void> _loadScanHistory() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? historyString = prefs.getString('scanHistory');
//     if (historyString != null) {
//       setState(() {
//         scanHistory = List<Map<String, dynamic>>.from(jsonDecode(historyString));
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scan History'),
//         backgroundColor: const Color(0xff674fff),
//       ),
//       body: scanHistory.isEmpty
//           ? const Center(child: Text('No scan history available'))
//           : ListView.builder(
//               itemCount: scanHistory.length,
//               itemBuilder: (context, index) {
//                 var scanData = scanHistory[index];
//                 return ScanHistoryCard(
//                   scanData: scanData,
//                   onPressed: () {
//                     _showScanDetails(scanData);
//                   },
//                 );
//               },
//             ),
//     );
//   }

//   // Function to show scan details
//   void _showScanDetails(Map<String, dynamic> scanData) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Scan Details'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('Scanned on: ${scanData['dateTime']}'),
//                 if (scanData['data'] != null)
//                   ...[
//                     Text('Patient Name: ${scanData['data']['patient']['name']['first']} ${scanData['data']['patient']['name']['last']}'),
//                     Text('Age: ${scanData['data']['patient']['age']}'),
//                     Text('Medications:'),
//                     for (var med in scanData['data']['medications'])
//                       Text('• ${med['medicationName']} - ${med['dosage']}'),
//                   ]
//                 else
//                   const Text('Error: No valid scan data found.'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Close'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class ScanHistoryCard extends StatelessWidget {
//   final Map<String, dynamic> scanData;
//   final VoidCallback onPressed;

//   const ScanHistoryCard({
//     required this.scanData,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       child: ListTile(
//         title: Text('Scan from ${scanData['dateTime']}'),
//         subtitle: Text('Prescription ID: ${scanData['data']['prescriptionId'] ?? 'N/A'}'),
//         trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
//         onTap: onPressed,
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  _ScanHistoryScreenState createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  List<Map<String, dynamic>> scanHistory = [];

  @override
  void initState() {
    super.initState();
    _loadScanHistory(); // Load the scan history when the screen initializes
  }

  Future<void> _loadScanHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? historyString = prefs.getString('scanHistory');
    if (historyString != null) {
      setState(() {
        scanHistory = List<Map<String, dynamic>>.from(jsonDecode(historyString));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // This allows the screen to adjust when the keyboard is on
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xff674fff),
                Color(0xff9775dc),
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'History',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 120.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: scanHistory.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text('No scan history available',
                            style: TextStyle(fontSize: 18)),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: SingleChildScrollView(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: scanHistory.length,
                          itemBuilder: (context, index) {
                            var scanData = scanHistory[index];
                            return ScanHistoryCard(
                              scanData: scanData,
                              onPressed: () {
                                _showScanDetails(scanData);
                              },
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to show scan details
  void _showScanDetails(Map<String, dynamic> scanData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Scan Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Scanned on: ${scanData['dateTime']}'),
                if (scanData['data'] != null) ...[
                  Text(
                      'Patient Name: ${scanData['data']['patient']['name']['first']} ${scanData['data']['patient']['name']['last']}'),
                  Text('Age: ${scanData['data']['patient']['age']}'),
                  const Text('Medications:'),
                  for (var med in scanData['data']['medications'])
                    Text('• ${med['medicationName']} - ${med['dosage']}'),
                ] else
                  const Text('Error: No valid scan data found.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ScanHistoryCard extends StatelessWidget {
  final Map<String, dynamic> scanData;
  final VoidCallback onPressed;

  const ScanHistoryCard({
    required this.scanData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text('Scan from ${scanData['dateTime']}'),
        subtitle: Text(
            'Prescription ID: ${scanData['data']['prescriptionId'] ?? 'N/A'}'),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: onPressed,
      ),
    );
  }
}
