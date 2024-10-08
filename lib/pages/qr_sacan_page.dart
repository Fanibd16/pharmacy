// import 'dart:convert'; // For JSON parsing
// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:http/http.dart' as http;
// import 'package:pharmacy/map/map_search_screen.dart';

// class UniversalBarcodeScanner extends StatefulWidget {
//   const UniversalBarcodeScanner({super.key});

//   @override
//   _UniversalBarcodeScannerState createState() =>
//       _UniversalBarcodeScannerState();
// }

// class _UniversalBarcodeScannerState extends State<UniversalBarcodeScanner> {
//   final MobileScannerController _controller = MobileScannerController(
//     formats: [
//       BarcodeFormat.qrCode,
//       BarcodeFormat.code128,
//     ],
//     facing: CameraFacing.back,
//   );
//   bool _scanned = false; // To stop the scanner after the first scan

//   @override
//   void initState() {
//     super.initState();
//     _controller.start();
//   }

//   void _onBarcodeDetect(BarcodeCapture barcodeCapture) {
//     if (_scanned) return; // Stop further scanning

//     for (final barcode in barcodeCapture.barcodes) {
//       if (barcode.rawValue != null) {
//         String originalUrl = barcode.rawValue!;
//         String baseUrl =
//             "http://localhost:3000/pharmacist/dashboard/prescription/";
//         String newBaseUrl =
//             "http://192.168.43.33:5000/api/prescription/mobileQr/";

//         // Check if the scanned URL contains the base URL we want to replace
//         if (originalUrl.startsWith(baseUrl)) {
//           // Stop scanning after first valid QR code
//           _controller.stop();
//           _scanned = true;

//           // Extract the prescription ID and generate the new API URL
//           String prescriptionId =
//               originalUrl.replaceFirst(baseUrl, ""); // Get the prescription ID
//           String apiUrl = "$newBaseUrl$prescriptionId";

//           // Fetch prescription details
//           _fetchPrescriptionDetails(apiUrl);
//         } else {
//           // Stop scanning and show incorrect data in the bottom sheet
//           _controller.stop();
//           _scanned = true;
//           _showBottomSheet({"error": "Incorrect data"});
//         }
//       }
//     }
//   }

//   // Fetch prescription details from the API
//   Future<void> _fetchPrescriptionDetails(String apiUrl) async {
//     try {
//       final response = await http.get(Uri.parse(apiUrl));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         // Display the data in a bottom sheet modal
//         _showBottomSheet(data);
//       } else {
//         debugPrint('Failed to load prescription details');
//       }
//     } catch (e) {
//       debugPrint('Error fetching prescription details: $e');
//     }
//   }

//   // Show bottom sheet modal with the prescription details or error
// void _showBottomSheet(Map<String, dynamic> data) {
//   showModalBottomSheet(
//     context: context,
//     builder: (context) {
//       return WillPopScope(
//         onWillPop: () async {
//           _restartScanner(); // Restart scanner when bottom sheet is closed
//           return true;
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: data.containsKey('error')
//               ? const Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       'Error',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text('Incorrect data'),
//                   ],
//                 )
//               : Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Prescription Details',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                         'Patient Name: ${data['patient']['name']['first']} ${data['patient']['name']['last']}'),
//                     Text('Age: ${data['patient']['age']}'),
//                     Text('Gender: ${data['patient']['gender']}'),
//                     Text('Phone: ${data['patient']['phonenumber']}'),
//                     const SizedBox(height: 10),
//                     const Text(
//                       'Medications:',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     ...?data['medications']?.map<Widget>((medication) => Text(
//                         '• ${medication['medicationName']} - ${medication['dosage']}')),
//                     const SizedBox(height: 10),
//                     Text(
//                         'Prescribed by: Dr. ${data['physician']['name']['first']} ${data['physician']['name']['last']}'),
//                     Text(
//                         'Physician Phone: ${data['physician']['phonenumber']}'),
//                     const SizedBox(height: 20),
//                     Center(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // Extract medicine names to pass to the map screen
//                           List<String> medicineNames = data['medications']
//                               .map<String>((medication) =>
//                                   medication['medicationName'] as String)
//                               .toList();

//                           // Navigate to the map screen with the medicines
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => MapScreen(
//                                 filteredPharmacies: [], // Pass your filtered pharmacies here
//                                 searchedMedicines: medicineNames, // Pass medicine names
//                               ),
//                             ),
//                           );
//                         },
//                         child: const Text('Find Pharmacies'),
//                       ),
//                     ),
//                   ],
//                 ),
//         ),
//       );
//     },
//   ).whenComplete(() {
//     _restartScanner(); // Restart scanner after bottom sheet is closed
//   });
// }

//   void _restartScanner() {
//     setState(() {
//       _scanned = false;
//     });
//     _controller.start();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final scanWindow = Rect.fromCenter(
//       center: MediaQuery.of(context).size.center(Offset.zero),
//       width: 300,
//       height: 300,
//     );

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           MobileScanner(
//             controller: _controller,
//             fit: BoxFit.contain,
//             scanWindow: scanWindow,
//             errorBuilder: (context, error, child) {
//               return Center(
//                 child: Text(
//                   'Error: $error',
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               );
//             },
//             onDetect: _onBarcodeDetect,
//           ),
//           CustomPaint(
//             painter: ScannerOverlay(scanWindow: scanWindow),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

// class ScannerOverlay extends CustomPainter {
//   final Rect scanWindow;
//   final double borderRadius;

//   ScannerOverlay({
//     required this.scanWindow,
//     this.borderRadius = 12.0,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final backgroundPath = Path()..addRect(Rect.largest);
//     final cutoutPath = Path()
//       ..addRRect(
//         RRect.fromRectAndCorners(
//           scanWindow,
//           topLeft: Radius.circular(borderRadius),
//           topRight: Radius.circular(borderRadius),
//           bottomLeft: Radius.circular(borderRadius),
//           bottomRight: Radius.circular(borderRadius),
//         ),
//       );

//     final backgroundPaint = Paint()
//       ..color = Colors.black.withOpacity(0.2)
//       ..style = PaintingStyle.fill
//       ..blendMode = BlendMode.dstOut;

//     final backgroundWithCutout = Path.combine(
//       PathOperation.difference,
//       backgroundPath,
//       cutoutPath,
//     );

//     final borderPaint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 4.0;

//     final borderRect = RRect.fromRectAndCorners(
//       scanWindow,
//       topLeft: Radius.circular(borderRadius),
//       topRight: Radius.circular(borderRadius),
//       bottomLeft: Radius.circular(borderRadius),
//       bottomRight: Radius.circular(borderRadius),
//     );

//     // Draw the background with cutout and the scan window border
//     canvas.drawPath(backgroundWithCutout, backgroundPaint);
//     canvas.drawRRect(borderRect, borderPaint);
//   }

//   @override
//   bool shouldRepaint(ScannerOverlay oldDelegate) {
//     return scanWindow != oldDelegate.scanWindow ||
//         borderRadius != oldDelegate.borderRadius;
//   }
// }

import 'dart:convert'; // For JSON parsing
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacy/map/map_search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UniversalBarcodeScanner extends StatefulWidget {
  const UniversalBarcodeScanner({super.key});

  @override
  _UniversalBarcodeScannerState createState() =>
      _UniversalBarcodeScannerState();
}

class _UniversalBarcodeScannerState extends State<UniversalBarcodeScanner> {
  final MobileScannerController _controller = MobileScannerController(
    formats: [
      BarcodeFormat.qrCode,
      BarcodeFormat.code128,
    ],
    facing: CameraFacing.back,
  );
  bool _scanned = false; // To stop the scanner after the first scan
  List<Map<String, dynamic>> scanHistory = []; // Store scan history

  @override
  void initState() {
    super.initState();
    _controller.start();
    _loadScanHistory(); // Load stored history
  }

  Future<void> _loadScanHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? historyString = prefs.getString('scanHistory');
    if (historyString != null) {
      setState(() {
        scanHistory =
            List<Map<String, dynamic>>.from(jsonDecode(historyString));
      });
    }
  }

  Future<void> _saveScanHistory(Map<String, dynamic> scanData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    scanHistory.add(scanData); // Add new scan to history
    await prefs.setString(
        'scanHistory', jsonEncode(scanHistory)); // Save to SharedPreferences
  }

  void _onBarcodeDetect(BarcodeCapture barcodeCapture) {
    if (_scanned) return; // Stop further scanning

    for (final barcode in barcodeCapture.barcodes) {
      if (barcode.rawValue != null) {
        String originalUrl = barcode.rawValue!;
        String baseUrl =
            "http://localhost:3000/pharmacist/dashboard/prescription/";
        String newBaseUrl =
            "http://192.168.137.5:5000/api/prescription/mobileQr/";

        if (originalUrl.startsWith(baseUrl)) {
          _controller.stop();
          _scanned = true;
          String prescriptionId =
              originalUrl.replaceFirst(baseUrl, ""); // Extract prescription ID
          String apiUrl = "$newBaseUrl$prescriptionId";
          _fetchPrescriptionDetails(apiUrl);
        } else {
          _controller.stop();
          _scanned = true;
          _showBottomSheet({"error": "Incorrect data"});
        }
      }
    }
  }

  Future<void> _fetchPrescriptionDetails(String apiUrl) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Add scan time to data
        Map<String, dynamic> scanData = {
          "dateTime": DateTime.now().toString(), // Store scan date and time
          "data": data
        };
        _showBottomSheet(data); // Show scan details
        _saveScanHistory(scanData); // Save scan details
      } else {
        debugPrint('Failed to load prescription details');
      }
    } catch (e) {
      debugPrint('Error fetching prescription details: $e');
    }
  }

  // Show bottom sheet modal with the prescription details or error
  void _showBottomSheet(Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            _restartScanner(); // Restart scanner when bottom sheet is closed
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: data.containsKey('error')
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Error',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Incorrect data'),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Prescription Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                          'Patient Name: ${data['patient']['name']['first']} ${data['patient']['name']['last']}'),
                      Text('Age: ${data['patient']['age']}'),
                      Text('Gender: ${data['patient']['gender']}'),
                      Text('Phone: ${data['patient']['phonenumber']}'),
                      const SizedBox(height: 10),
                      const Text(
                        'Medications:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...?data['medications']?.map<Widget>((medication) => Text(
                          '• ${medication['medicationName']} - ${medication['dosage']}')),
                      const SizedBox(height: 10),
                      Text(
                          'Prescribed by: Dr. ${data['physician']['name']['first']} ${data['physician']['name']['last']}'),
                      Text(
                          'Physician Phone: ${data['physician']['phonenumber']}'),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Extract medicine names to pass to the map screen
                            List<String> medicineNames = data['medications']
                                .map<String>((medication) =>
                                    medication['medicationName'] as String)
                                .toList();

                            // Navigate to the map screen with the medicines
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapScreen(
                                  filteredPharmacies: const [], // Pass your filtered pharmacies here
                                  searchedMedicines:
                                      medicineNames, // Pass medicine names
                                ),
                              ),
                            );
                          },
                          child: const Text('Find Pharmacies'),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    ).whenComplete(() {
      _restartScanner(); // Restart scanner after bottom sheet is closed
    });
  }

  void _restartScanner() {
    setState(() {
      _scanned = false;
    });
    _controller.start();
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: 300,
      height: 300,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            fit: BoxFit.contain,
            scanWindow: scanWindow,
            errorBuilder: (context, error, child) {
              return Center(
                child: Text(
                  'Error: $error',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
            onDetect: _onBarcodeDetect,
          ),
          CustomPaint(
            painter: ScannerOverlay(scanWindow: scanWindow),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ScannerOverlay extends CustomPainter {
  final Rect scanWindow;
  final double borderRadius;

  ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // Draw the background with cutout and the scan window border
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}
