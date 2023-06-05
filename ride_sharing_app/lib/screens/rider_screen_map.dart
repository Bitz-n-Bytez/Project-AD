import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ride_sharing_app/screens/car_pool.dart';
import 'package:ride_sharing_app/screens/solo_ride.dart';

class RiderScreen extends StatefulWidget {
  @override
  _RiderScreenState createState() => _RiderScreenState();
}

class _RiderScreenState extends State<RiderScreen> {
  late GoogleMapController _mapController;
  LatLng? _pickupPoint;
  LatLng? _destinationPoint;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      if (_pickupPoint == null) {
        _pickupPoint = latLng;
      } else if (_destinationPoint == null) {
        _destinationPoint = latLng;
      } else {
        // Handle additional taps or show an error message
      }
    });
  }

  void _soloRequestRide() async {
    if (_pickupPoint != null && _destinationPoint != null) {
      try {
        // Get the current user's ID
        User? currentUser = FirebaseAuth.instance.currentUser;
        String userId = currentUser!.uid;

        // Store the ride request in the Firestore database
        await FirebaseFirestore.instance.collection('rideRequest').add({
          'userId': userId,
          'pickup': GeoPoint(_pickupPoint!.latitude, _pickupPoint!.longitude),
          'destination': GeoPoint(
              _destinationPoint!.latitude, _destinationPoint!.longitude),
          'status': 'pending',
        });

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const SoloRide()));
      } catch (e) {
        // Show an error message
        // ...
        print(e);
      }
    } else {
      // Show an error message indicating that both pickup and destination points must be selected
      // ...
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text:
            'Error message: both pickup and destination points must be selected',
      );
    }
  }

  void _poolRequestRide() async {
    if (_pickupPoint != null && _destinationPoint != null) {
      try {
        // Get the current user's ID
        User? currentUser = FirebaseAuth.instance.currentUser;
        String userId = currentUser!.uid;

        // Store the ride request in the Firestore database
        await FirebaseFirestore.instance.collection('rideRequest').add({
          'userId': userId,
          'pickup': GeoPoint(_pickupPoint!.latitude, _pickupPoint!.longitude),
          'destination': GeoPoint(
              _destinationPoint!.latitude, _destinationPoint!.longitude),
          'status': 'pending',
        });

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const CarPool()));
      } catch (e) {
        // Show an error message
        // ...
        print(e);
      }
    } else {
      // Show an error message indicating that both pickup and destination points must be selected
      // ...
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text:
            'Error message: both pickup and destination points must be selected',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Ride'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            onMapCreated: _onMapCreated,
            onTap: _onMapTap,
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(37.7749, -122.4194), // Set the initial map position
              zoom: 12.0, // Set the initial zoom level
            ),
            markers: Set<Marker>.from([
              if (_pickupPoint != null)
                Marker(
                  markerId: MarkerId('pickup'),
                  position: _pickupPoint!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                ),
              if (_destinationPoint != null)
                Marker(
                  markerId: MarkerId('destination'),
                  position: _destinationPoint!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ),
            ]),
          ),
          Positioned(
            bottom: 75.0,
            left: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: _soloRequestRide,
              child: Text('Solo Ride'),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: _poolRequestRide,
              child: Text('Pool Ride'),
            ),
          ),
        ],
      ),
    );
  }
}
