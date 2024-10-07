import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pharmacy/map/os_api.dart'; // Assuming you have the OpenRouteService API here

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();
  LocationData? currentLocation;
  List<LatLng> routePoints = [];
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadPharmacyMarkers();
  }

  // Simulated pharmacy data from the database
  final List<Map<String, dynamic>> pharmacyData = [
    {
      'name': 'Pharmacy A',
      'location': const LatLng(11.0497, 39.7473), // Example LatLng for pharmacy
      'medicines': [
        {'medicine': 'Painkiller', 'price': '10 USD'},
        {'medicine': 'Antibiotic', 'price': '20 USD'},
        {'medicine': 'Vitamins', 'price': '5 USD'},
      ],
      'totalPrice': '35 USD'
    },
    {
      'name': 'Pharmacy B',
      'location': const LatLng(11.0477, 39.7489),
      'medicines': [
        {'medicine': 'Paracetamol', 'price': '12 USD'},
        {'medicine': 'Cough Syrup', 'price': '18 USD'},
        {'medicine': 'Antibiotic', 'price': '15 USD'},
      ],
      'totalPrice': '45 USD'
    },
    {
      'name': 'Pharmacy C',
      'location': const LatLng(11.0518, 39.7496),
      'medicines': [
        {'medicine': 'Vitamins', 'price': '8 USD'},
        {'medicine': 'Cough Syrup', 'price': '15 USD'},
      ],
      'totalPrice': '23 USD'
    }
  ];

  Future<void> _getCurrentLocation() async {
    var location = Location();

    try {
      var userLocation = await location.getLocation();
      setState(() {
        currentLocation = userLocation;
        markers.add(
          Marker(
            width: 30.0,
            height: 30.0,
            point: LatLng(userLocation.latitude!, userLocation.longitude!),
            child: Image.asset(
              'assets/icon_map/Pin_current_location.png',
              width: 10.0,
              height: 10.0,
            ),
          ),
        );
      });
    } on Exception {
      currentLocation = null;
    }

    location.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        currentLocation = newLocation;
      });
    });
  }

  // Add pharmacy markers to the map
  void _loadPharmacyMarkers() {
    setState(() {
      for (var pharmacy in pharmacyData) {
        markers.add(
          Marker(
            width: 30.0,
            height: 30.0,
            point: pharmacy['location'],
            child: GestureDetector(
              onTap: () => _showPharmacyDetails(pharmacy),
              child: Image.asset(
                'assets/icon_map/ph_marker.png',
                width: 10.0,
                height: 10.0,
              ),
            ),
          ),
        );
      }
    });
  }

  // Show a bottom sheet with pharmacy details
  void _showPharmacyDetails(Map<String, dynamic> pharmacy) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows full-screen drag
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4, // Initial height of the sheet
          minChildSize: 0.3, // Minimum height when collapsed
          maxChildSize: 0.9, // Maximum height when fully expanded
          expand:
              false, // Set to true if you want it to take full screen when expanded
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController, // Makes the content scrollable
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(116.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Loop through the medicines list
                    for (var medicine in pharmacy['medicines'])
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                            '${medicine['medicine']}: ${medicine['price']}'),
                      ),
                    const SizedBox(height: 8),
                    Text('Total Price: ${pharmacy['totalPrice']}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                        _getRoute(
                            pharmacy['location']); // Show route to pharmacy
                      },
                      child: const Text('Show Route'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Get the route to the destination pharmacy
  Future<void> _getRoute(LatLng destination) async {
    if (currentLocation == null) return;

    final start =
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
    final response = await http.get(
      Uri.parse(
          'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${destination.longitude},${destination.latitude}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coords =
          data['features'][0]['geometry']['coordinates'];
      setState(() {
        routePoints =
            coords.map((coord) => LatLng(coord[1], coord[0])).toList();
      });
    } else {
      print('Failed to fetch route');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Pharmacy Finder'),
      // ),
      body: currentLocation == null
          ? const Center(child: Text('Loading...'))
          : FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                initialZoom: 16.0,
                // onTap: (tapPosition, point) => _addDestinationMarker(point),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: markers,
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      strokeWidth: 4.0,
                      color: const Color(0xff674ff4),
                    ),
                  ],
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentLocation != null) {
            mapController.move(
              LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
              15.0,
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
