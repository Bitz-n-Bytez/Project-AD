// import 'dart:async';
// import 'package:geolocator/geolocator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// final CollectionReference _driversCollection = _firestore.collection('drivers');

// Future<void> updateDriverLocation(
//     String driverId, double latitude, double longitude) async {
//   await _driversCollection.doc(driverId).update({
//     'latitude': latitude,
//     'longitude': longitude,
//   });
// }

// Future<Position> getCurrentPosition() async {
//   return await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high);
// }

// void startLocationTracking(String driverId) {
//   StreamSubscription<Position> positionStream;

//   positionStream = Geolocator.getPositionStream().listen((position) {
//     updateDriverLocation(driverId, position.latitude, position.longitude);
//   });
// }

// void stopLocationTracking() {
//   positionStre
// }
