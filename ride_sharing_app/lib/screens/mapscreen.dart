// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapScreen extends StatefulWidget {
//   final String driverId;

//   MapScreen({required this.driverId});

//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late GoogleMapController mapController;
//   late StreamSubscription<DocumentSnapshot> locationSubscription;

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   void _updateDriverMarker(LatLng position) {
//     mapController.animateCamera(CameraUpdate.newLatLng(position));
//   }

//   void _listenToDriverLocation() {
//     locationSubscription =
//         _driversCollection.doc(widget.driverId).snapshots().listen((snapshot) {
//       if (snapshot.exists) {
//         final data = snapshot.data() as Map<String, dynamic>;
//         final latitude = data['latitude'] as double;
//         final longitude = data['longitude'] as double;

//         final driverPosition = LatLng(latitude, longitude);
//         _updateDriverMarker(driverPosition);
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _listenToDriverLocation();
//   }

//   @override
//   void dispose() {
//     locationSubscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Driver Location'),
//       ),
//       body: GoogleMap(
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: LatLng(37.7749, -122.4194), // Set initial map center
//           zoom: 12.0, // Set initial map zoom level
//         ),
//       ),
//     );
//   }
// }
