// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart'; // Import the location package

// class OrderTrackingPage extends StatefulWidget {
//   const OrderTrackingPage({Key? key}) : super(key: key);

//   @override
//   State<OrderTrackingPage> createState() => OrderTrackingPageState();
// }

// class OrderTrackingPageState extends State<OrderTrackingPage> {
//   final Completer<GoogleMapController> _controller = Completer();

//   static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
//   static const LatLng destination = LatLng(37.33429383, -122.06600055);
//   static const String google_api_key = "API_KEY";

//   List<LatLng> polylineCoordinates = [];
//   LocationData? currentLocation;

//   BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

//   void getCurrentLocation() async {
//     Location location = Location();

//     location.getLocation().then((location) {
//       currentLocation = location;
//     });

//     GoogleMapController googleMapController = await _controller.future;

//     location.onLocationChanged.listen((newLoc) {
//       currentLocation = newLoc;

//       googleMapController.animateCamera(CameraUpdate.newCameraPosition(
//           CameraPosition(
//               zoom: 13.5,
//               target: LatLng(newLoc.latitude!, newLoc.longitude!))));

//       setState(() {});
//     });
//   }

//   void getPolyPoints() async {
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       google_api_key,
//       PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
//       PointLatLng(destination.latitude, destination.longitude),
//     );

//     if (result.points.isNotEmpty) {
//       for (var point in result.points) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       }
//       setState(() {});
//     }
//   }

//   void setCustomMarkerIcon() {
//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration.empty, "assets/icon_map/Pin_source.png")
//         .then((icon) => {sourceIcon = icon});
//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration.empty, "assets/icon_map/Pin_destination.png")
//         .then((icon) => {destinationIcon = icon});
//     BitmapDescriptor.fromAssetImage(ImageConfiguration.empty,
//             "assets/icon_map/Pin_current_location.png")
//         .then((icon) => {currentLocationIcon = icon});
//   }

//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocation();
//     setCustomMarkerIcon();
//     getPolyPoints();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "Track order",
//             style: TextStyle(color: Colors.black, fontSize: 16),
//           ),
//         ),
//         body: currentLocation == null
//             ? const Center(child: Text('Loading ..'))
//             : GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                     target: LatLng(currentLocation!.latitude!,
//                         currentLocation!.longitude!), // Use ! for null assertion
//                     zoom: 13.5),
//                 polylines: {
//                   Polyline(
//                       polylineId: const PolylineId('route'),
//                       points: polylineCoordinates,
//                       color: const Color(0xFF7B61FF),
//                       width: 6),
//                 },
//                 markers: {
//                   Marker(
//                       markerId: const MarkerId("currentLocation"),
//                       icon: currentLocationIcon,
//                       position: LatLng(currentLocation!.latitude!,
//                           currentLocation!.longitude!)), // Use ! for null assertion
//                   Marker(
//                       markerId: const MarkerId("source"),
//                       icon: sourceIcon,
//                       position: sourceLocation),
//                   Marker(
//                       markerId: const MarkerId("destination"),
//                       icon: destinationIcon,
//                       position: destination),
//                 },
//                 onMapCreated: (mapController) {
//                   _controller.complete(mapController);
//                 },
//               ));
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:location/location.dart';

// class OrderTrackingPage extends StatefulWidget {
//   const OrderTrackingPage({Key? key}) : super(key: key);

//   @override
//   State<OrderTrackingPage> createState() => OrderTrackingPageState();
// }

// class OrderTrackingPageState extends State<OrderTrackingPage> {
//   LocationData? currentLocation;
//   final Location _location = Location();

//   static LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
//   static LatLng destinationLocation = LatLng(37.33429383, -122.06600055);

//   late MapBoxNavigation _directions;
//   late MapBoxOptions _options;

//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocation();
//     _directions = MapBoxNavigation();
//     _options = MapBoxOptions(
//       initialLatitude: sourceLocation.latitude,
//       initialLongitude: sourceLocation.longitude,
//       zoom: 14,
//       enableRefresh: true,
//       voiceInstructionsEnabled: true,
//       bannerInstructionsEnabled: true,
//       mode: MapBoxNavigationMode.drivingWithTraffic,
//       units: VoiceUnits.imperial,
//       language: "en",
//     );
//   }

//   void getCurrentLocation() async {
//     await _location.requestPermission();
//     currentLocation = await _location.getLocation();
//     setState(() {});

//     // Start navigation
//     startNavigation();
//   }

//   void startNavigation() async {
//     List<WayPoint> wayPoints = [
//       WayPoint(
//         name: "Source",
//         latitude: sourceLocation.latitude,
//         longitude: sourceLocation.longitude,
//       ),
//       WayPoint(
//         name: "Destination",
//         latitude: destinationLocation.latitude,
//         longitude: destinationLocation.longitude,
//       ),
//     ];

//     await _directions.startNavigation(
//       wayPoints: wayPoints,
//       options: _options,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Track order",
//           style: TextStyle(color: Colors.black, fontSize: 16),
//         ),
//       ),
//       body: currentLocation == null
//           ? const Center(child: Text('Loading..'))
//           : Center(
//               child: Text(
//                 'Current Location: ${currentLocation!.latitude}, ${currentLocation!.longitude}',
//               ),
//             ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

// class MapView extends StatefulWidget {
//   const MapView({Key? key}) : super(key: key);

//   // const MapView({super.key});

//   @override
//   State<MapView> createState() => _MapViewState();
// }

// class _MapViewState extends State<MapView> {
//   MapBoxNavigationViewController? _controller;
//   String? _instruction;
//   bool _isMultipleStop = false;
//   double? _distanceRemaining, _durationRemaining;
//   bool _routeBuilt = false;
//   bool _isNavigating = false;
//   bool _arrived = false;
//   late MapBoxOptions _navigationOption;

//   Future<void> initialize() async {
//     if (!mounted) return;
//     _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
//     _navigationOption.initialLatitude = 37.7749;
//     _navigationOption.initialLongitude = -122.4194;
//     _navigationOption.mode = MapBoxNavigationMode.driving;
//     MapBoxNavigation.instance.registerRouteEventListener(_onRouteEvent);
//   }

//   @override
//   void initState() {
//     initialize();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       body: Column(
//         children: [
//           SizedBox(
//             height: MediaQuery.of(context).size.height * 1,
//             child: Container(
//               color: Colors.grey[100],
//               child: MapBoxNavigationView(
//                 options: _navigationOption,
//                 onRouteEvent: _onRouteEvent,
//                 onCreated: (MapBoxNavigationViewController controller) async {
//                   _controller = controller;
//                   controller.initialize();
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _onRouteEvent(e) async {

//     _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
//     _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

//     switch (e.eventType) {
//       case MapBoxEvent.progress_change:
//         var progressEvent = e.data as RouteProgressEvent;
//         _arrived = progressEvent.arrived!;
//         if (progressEvent.currentStepInstruction != null) {
//           _instruction = progressEvent.currentStepInstruction;
//         }
//         break;
//       case MapBoxEvent.route_building:
//       case MapBoxEvent.route_built:
//         _routeBuilt = true;
//         break;
//       case MapBoxEvent.route_build_failed:
//         _routeBuilt = false;
//         break;
//       case MapBoxEvent.navigation_running:
//         _isNavigating = true;
//         break;
//       case MapBoxEvent.on_arrival:
//         _arrived = true;
//         if (!_isMultipleStop) {
//           await Future.delayed(const Duration(seconds: 3));
//           await _controller?.finishNavigation();
//         } else {}
//         break;
//       case MapBoxEvent.navigation_finished:
//       case MapBoxEvent.navigation_cancelled:
//         _routeBuilt = false;
//         _isNavigating = false;
//         break;
//       default:
//         break;
//     }
//     //refresh UI
//     setState(() {});
//   }
// }










// import 'package:flutter/material.dart';
// import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:geolocator/geolocator.dart';

// class MapView extends StatefulWidget {
//   const MapView({Key? key}) : super(key: key);

//   @override
//   State<MapView> createState() => _MapViewState();
// }

// class _MapViewState extends State<MapView> {
//   MapBoxNavigationViewController? _controller;
//   String? _instruction;
//   final bool _isMultipleStop = false;
//   double? _distanceRemaining, _durationRemaining;
//   final bool _routeBuilt = false;
//   final bool _isNavigating = false;
//   final bool _arrived = false;
//   late MapBoxOptions _navigationOption;

//   MapboxMapController? mapController;
//   LatLng? currentLocation;
//   LatLng? selectedLocation;
//   List<LatLng> markerLocations = [
//     const LatLng(37.7749, -122.4194), // Sample locations from the database
//     const LatLng(37.7849, -122.4094),
//     const LatLng(37.7949, -122.4294),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       currentLocation = LatLng(position.latitude, position.longitude);
//     });
//   }

//   void _onMapCreated(MapboxMapController controller) {
//     mapController = controller;

//     // Add event listener for symbol taps
//     mapController?.onSymbolTapped.add(_onMarkerTapped);

//     // Add markers to the map
//     _addMarkers();
//   }

//   void _addMarkers() {
//     for (var location in markerLocations) {
//       mapController?.addSymbol(SymbolOptions(
//         geometry: location,
//         iconImage: "marker-15",
//       ));
//     }
//   }

//   void _onMarkerTapped(Symbol symbol) {
//     setState(() {
//       selectedLocation = symbol.options.geometry;
//     });
//     _buildRouteToSelectedLocation();
//   }

//   Future<void> _buildRouteToSelectedLocation() async {
//     if (currentLocation != null && selectedLocation != null) {
//       await MapBoxNavigation.instance.startNavigation(
//         wayPoints: [
//           WayPoint(
//               name: "Current Location",
//               latitude: currentLocation!.latitude,
//               longitude: currentLocation!.longitude),
//           WayPoint(
//               name: "Destination",
//               latitude: selectedLocation!.latitude,
//               longitude: selectedLocation!.longitude),
//         ],
//         options: MapBoxOptions(
//           mode: MapBoxNavigationMode.driving,
//           simulateRoute: false,
//           language: "en",
//           units: VoiceUnits.metric,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Map View')),
//       body: currentLocation == null
//           ? const Center(child: CircularProgressIndicator())
//           : Stack(
//               children: [
//                 MapboxMap(
//                   accessToken:
//                       "YOUR_MAPBOX_ACCESS_TOKEN", // Replace with your Mapbox token
//                   onMapCreated: _onMapCreated,
//                   initialCameraPosition: CameraPosition(
//                     target: currentLocation!,
//                     zoom: 12.0,
//                   ),
//                   onStyleLoadedCallback: _addMarkers,
//                 ),
//                 if (selectedLocation != null)
//                   Positioned(
//                     bottom: 20,
//                     left: 20,
//                     right: 20,
//                     child: ElevatedButton(
//                       onPressed: _buildRouteToSelectedLocation,
//                       child: const Text('Show Route'),
//                     ),
//                   ),
//               ],
//             ),
//     );
//   }
// }
