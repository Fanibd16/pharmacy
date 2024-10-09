import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';

class Hcard extends StatefulWidget {
  const Hcard({super.key});

  @override
  _HcardState createState() => _HcardState();
}

class _HcardState extends State<Hcard> {
  // API URL (replace with your local API address)
  final String apiUrl = 'http://192.168.137.5:5000/api/pharmacy-manager/all';

  // Fetch data from the local API
  Future<List<dynamic>> fetchPharmacies() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      // Parse the JSON response and return the data
      return json.decode(response.body)['pharmacyManagers'];
    } else {
      throw Exception('Failed to load pharmacies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<dynamic>>(
        future: fetchPharmacies(), // Fetch the data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Loading indicator
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            // When the data is successfully fetched
            final List<dynamic> pharmacies = snapshot.data ?? [];

            return ListView.builder(
              itemCount: pharmacies.length,
              itemBuilder: (context, index) {
                var pharmacy = pharmacies[index];
                return ClickableCard(
                  key: UniqueKey(),
                  title: pharmacy['pharmaName'],
                  subtitle: 'Phone: ${pharmacy['user']['phoneNumber']}',
                  prefixImage: const AssetImage('assets/store.png'),
                  suffixIcon: Icons.arrow_forward_ios,
                  onPressed: () {
                    // You can navigate to detailed view or add action logic here
                    showPharmacyDetails(context, pharmacy);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  // Function to show detailed information about the pharmacy
  void showPharmacyDetails(BuildContext context, dynamic pharmacy) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(pharmacy['pharmaName']),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Manager: ${pharmacy['pmName']}'),
                Text('Email: ${pharmacy['user']['email']}'),
                Text('Phone: ${pharmacy['user']['phoneNumber']}'),
                Text('latitude: ${pharmacy['addressDetails']['latitude']}'),
                Text('Experience: ${pharmacy['experience']} years'),
                if (pharmacy['products'] != null &&
                    pharmacy['products'].isNotEmpty) ...[
                  const SizedBox(height: 10),
                  const Text(
                    'Products:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  for (var product in pharmacy['products']) ...[
                    Text(
                        ' - ${product['medname']} (Qty: ${product['remainQty']})'),
                  ],
                ] else
                  const Text('No products available'),
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

class ClickableCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final ImageProvider prefixImage;
  final IconData suffixIcon;
  final VoidCallback onPressed;

  const ClickableCard({
    required Key key,
    required this.title,
    required this.subtitle,
    required this.prefixImage,
    required this.suffixIcon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: const Color.fromARGB(46, 0, 0, 0),
      color: Colors.black.withOpacity(0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onPressed,
        splashColor: const Color(0xff674fff).withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.0),
        splashFactory: InkRipple.splashFactory,
        child: ListTile(
          leading: Image(
            height: 40,
            image: prefixImage,
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(color: Color(0xff674fff)),
          ),
          trailing: Icon(
            suffixIcon,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
