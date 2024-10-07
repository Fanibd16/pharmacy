// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:flutter/services.dart' show rootBundle;

// class PharmacyLocation extends StatefulWidget {
//   const PharmacyLocation({super.key});

//   @override
//   State<PharmacyLocation> createState() => PharmacyLocationState();
// }

// class PharmacyLocationState extends State<PharmacyLocation> {
//   final Completer<GoogleMapController> _controller = Completer();
//   static const String googleApiKey =
//       "AIzaSyBQ2_hEcsman-Qk3bP16PtkxOQsiBVS9EM"; // Replace with your key

//   List<LatLng> polylineCoordinates = [];
//   LocationData? currentLocation;
//   String? _mapStyle;
//   Location location = Location();

//   BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor pharmacyIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

//   List<Marker> pharmacyMarkers = [];
//   LatLng? selectedPharmacyLocation;
//   String selectedPharmacyName = "";
//   double selectedPharmacyDistance = 0.0;
//   String selectedPharmacyMedicinePrice = "";
//   bool _cameraMoved = false;

//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocation();
//     setCustomMarkerIcons();
//     loadMapStyle();
//     initializePharmacyMarkers();
//   }

//   // Load custom map style if any
//   void loadMapStyle() async {
//     _mapStyle = await rootBundle.loadString('assets/map.json');
//   }

//   // Fetch current location
//   void getCurrentLocation() async {
//     currentLocation = await location.getLocation();
//     setState(() {});

//     GoogleMapController googleMapController = await _controller.future;

//     location.onLocationChanged.listen((newLoc) {
//       currentLocation = newLoc;

//       if (!_cameraMoved) {
//         googleMapController.animateCamera(CameraUpdate.newCameraPosition(
//           CameraPosition(
//             zoom: 16.5,
//             target: LatLng(newLoc.latitude!, newLoc.longitude!),
//           ),
//         ));
//       }
//       setState(() {});
//     });
//   }

//   // Initialize pharmacy markers
//   void initializePharmacyMarkers() {
//     List<Map<String, dynamic>> pharmacies = [
//       {
//         "name": "Pharmacy 1",
//         "location": const LatLng(11.0517, 39.7477),
//         "medicinePrice": "15.99 USD"
//       },
//       {
//         "name": "Pharmacy 2",
//         "location": const LatLng(11.0498, 39.7473),
//         "medicinePrice": "12.50 USD"
//       },
//       {
//         "name": "Pharmacy 3",
//         "location": const LatLng(11.0485, 39.7501),
//         "medicinePrice": "12.50 USD"
//       },
//     ];

//     for (var pharmacy in pharmacies) {
//       pharmacyMarkers.add(
//         Marker(
//           markerId: MarkerId(pharmacy["name"]),
//           icon: pharmacyIcon,
//           position: pharmacy["location"],
//           onTap: () {
//             selectedPharmacyLocation = pharmacy["location"];
//             selectedPharmacyName = pharmacy["name"];
//             selectedPharmacyMedicinePrice = pharmacy["medicinePrice"];
//             selectedPharmacyDistance = _calculateDistance(
//               currentLocation!.latitude!,
//               currentLocation!.longitude!,
//               pharmacy["location"].latitude,
//               pharmacy["location"].longitude,
//             );
//             _showBottomSheet();
//           },
//         ),
//       );
//     }
//   }

//   // Custom marker icon loading
//   void setCustomMarkerIcons() async {
//     pharmacyIcon = await BitmapDescriptor.fromAssetImage(
//       const ImageConfiguration(size: Size(48, 48)),
//       'assets/icon_map/ph_marker.png',
//     );

//     currentLocationIcon = await BitmapDescriptor.fromAssetImage(
//       const ImageConfiguration(size: Size(48, 48)),
//       'assets/icon_map/Pin_current_location.png',
//     );

//     sourceIcon = await BitmapDescriptor.fromAssetImage(
//       const ImageConfiguration(size: Size(48, 48)),
//       'assets/icon_map/Pin_source.png',
//     );

//     setState(() {});
//   }

//   // Calculate distance between two locations
//   double _calculateDistance(
//       double lat1, double lon1, double lat2, double lon2) {
//     const double radiusOfEarthKm = 6371;
//     double dLat = _degreesToRadians(lat2 - lat1);
//     double dLon = _degreesToRadians(lon2 - lon1);
//     double a = (sin(dLat / 2) * sin(dLat / 2)) +
//         cos(_degreesToRadians(lat1)) *
//             cos(_degreesToRadians(lat2)) *
//             (sin(dLon / 2) * sin(dLon / 2));
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return radiusOfEarthKm * c;
//   }

//   double _degreesToRadians(double degrees) {
//     return degrees * pi / 180;
//   }

//   // Show route to selected pharmacy
//   void _showRouteToPharmacy(LatLng pharmacyLocation) async {
//     if (currentLocation == null) return;

//     try {
//       PolylinePoints polylinePoints = PolylinePoints();
//       PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         googleApiKey: googleApiKey,
//         request: PolylineRequest(
//           origin: PointLatLng(
//               currentLocation!.latitude!, currentLocation!.longitude!),
//           destination: PointLatLng(
//               pharmacyLocation.latitude, pharmacyLocation.longitude),
//           mode: TravelMode.driving,
//         ),
//       );

//       if (result.points.isNotEmpty) {
//         polylineCoordinates.clear();
//         for (var point in result.points) {
//           polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//         }
//         setState(() {});
//       } else {
//         print("No polyline points found.");
//       }
//     } catch (error) {
//       print("Error calculating route: $error");
//     }
//   }

//   // Show bottom sheet with pharmacy details
//   void _showBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.4,
//           minChildSize: 0.2,
//           maxChildSize: 0.7,
//           builder: (BuildContext context, scrollSheetController) {
//             return Container(
//               color: Colors.white,
//               padding: const EdgeInsets.all(16),
//               child: ListView(
//                 controller: scrollSheetController,
//                 children: [
//                   const SizedBox(
//                     width: 50,
//                     child: Divider(
//                       thickness: 5,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     selectedPharmacyName,
//                     style: const TextStyle(
//                         fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                       'Distance: ${selectedPharmacyDistance.toStringAsFixed(2)} km'),
//                   const SizedBox(height: 10),
//                   Text('Medicine Price: $selectedPharmacyMedicinePrice'),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       _showRouteToPharmacy(selectedPharmacyLocation!);
//                       Navigator.pop(context); // Close the bottom sheet
//                     },
//                     child: const Text('Show Route'),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Track Order",
//           style: TextStyle(color: Colors.black, fontSize: 16),
//         ),
//       ),
//       body: currentLocation == null
//           ? const Center(child: Text('Loading ..'))
//           : GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(
//                   currentLocation!.latitude!,
//                   currentLocation!.longitude!,
//                 ),
//                 zoom: 16.5,
//               ),
//               markers: {
//                 Marker(
//                   markerId: const MarkerId("currentLocation"),
//                   icon: currentLocationIcon,
//                   position: LatLng(
//                     currentLocation!.latitude!,
//                     currentLocation!.longitude!,
//                   ),
//                 ),
//                 ...pharmacyMarkers,
//               },
//               polylines: {
//                 Polyline(
//                   polylineId: const PolylineId('route'),
//                   points: polylineCoordinates,
//                   color: Colors.blue,
//                   width: 6,
//                 ),
//               },
//               onMapCreated: (mapController) {
//                 _controller.complete(mapController);
//                 if (_mapStyle != null) {
//                   mapController.setMapStyle(_mapStyle);
//                 }
//               },
//               onCameraMove: (position) {
//                 _cameraMoved = true;
//               },
//             ),
//     );
//   }
// }


















// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});

//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late GoogleMapController mapController;
//   double _originLatitude = 6.5212402, _originLongitude = 3.3679965;
//   double _destLatitude = 6.849660, _destLongitude = 3.648190;
//   // double _originLatitude = 26.48424, _originLongitude = 50.04551;
//   // double _destLatitude = 26.46423, _destLongitude = 50.06358;
//   Map<MarkerId, Marker> markers = {};
//   Map<PolylineId, Polyline> polylines = {};
//   List<LatLng> polylineCoordinates = [];
//   PolylinePoints polylinePoints = PolylinePoints();
//   String googleAPiKey = "AIzaSyBQ2_hEcsman-Qk3bP16PtkxOQsiBVS9EM";

//   @override
//   void initState() {
//     super.initState();

//     /// origin marker
//     _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
//         BitmapDescriptor.defaultMarker);

//     /// destination marker
//     _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
//         BitmapDescriptor.defaultMarkerWithHue(90));
//     _getPolyline();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//             target: LatLng(_originLatitude, _originLongitude), zoom: 15),
//         myLocationEnabled: true,
//         tiltGesturesEnabled: true,
//         compassEnabled: true,
//         scrollGesturesEnabled: true,
//         zoomGesturesEnabled: true,
//         onMapCreated: _onMapCreated,
//         markers: Set<Marker>.of(markers.values),
//         polylines: Set<Polyline>.of(polylines.values),
//       )),
//     );
//   }

//   void _onMapCreated(GoogleMapController controller) async {
//     mapController = controller;
//   }

//   _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
//     MarkerId markerId = MarkerId(id);
//     Marker marker =
//         Marker(markerId: markerId, icon: descriptor, position: position);
//     markers[markerId] = marker;
//   }

//   _addPolyLine() {
//     PolylineId id = const PolylineId("poly");
//     Polyline polyline = Polyline(
//         polylineId: id, color: Colors.red, points: polylineCoordinates);
//     polylines[id] = polyline;
//     setState(() {});
//   }

//   _getPolyline() async {
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       googleApiKey: googleAPiKey,
//       request: PolylineRequest(
//         origin: PointLatLng(_originLatitude, _originLongitude),
//         destination: PointLatLng(_destLatitude, _destLongitude),
//         mode: TravelMode.driving,
//         wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
//       ),
//     );
//     if (result.points.isNotEmpty) {
//       for (var point in result.points) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       }
//     }
//     _addPolyLine();
//   }
// }
