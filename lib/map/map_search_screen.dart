import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:pharmacy/map/os_api.dart';

class MapScreen extends StatefulWidget {
  final List<Map<String, dynamic>> filteredPharmacies;
  final List<String> searchedMedicines; // List of medicines searched by user

  const MapScreen({
    super.key,
    required this.filteredPharmacies,
    required this.searchedMedicines, // Accept the list of searched medicines
  });

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
      for (var pharmacy in widget.filteredPharmacies) {
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

  // Show a bottom sheet with filtered pharmacy details
  void _showPharmacyDetails(Map<String, dynamic> pharmacy) {
    // Get the medicines in the pharmacy that match the user's search
    List<Map<String, dynamic>> filteredMedicines = pharmacy['medicines']
        .where((medicine) =>
            widget.searchedMedicines.contains(medicine['medicine']))
        .toList();

    // Calculate the total price of filtered medicines
    double totalPrice = filteredMedicines.fold(
      0,
      (previousValue, medicine) =>
          previousValue + double.parse(medicine['price'].split(' ')[0]),
    );

    // Show the bottom sheet with the filtered medicines and total price
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
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
                    filteredMedicines.isNotEmpty
                        ? Column(
                            children: filteredMedicines.map((medicine) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                    '${medicine['medicine']}: ${medicine['price']}'),
                              );
                            }).toList(),
                          )
                        : const Text('No matching medicines found.'),
                    const SizedBox(height: 8),
                    Text('Total Price: $totalPrice USD'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _getRoute(pharmacy['location']);
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
      appBar: AppBar(
        
      ),
      body: currentLocation == null
          ? const Center(child: Text('Loading...'))
          : FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(currentLocation!.latitude!,
                  currentLocation!.longitude!),
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(markers: markers),
              if (routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                        points: routePoints,
                        strokeWidth: 4.0,
                        color: const Color(0xff674ff4)),
                  ],
                ),
            ],
          ),
    );
  }
}
