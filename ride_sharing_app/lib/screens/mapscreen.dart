import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  TextEditingController _pickupController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  LatLng? _pickupLatLng;
  LatLng? _destinationLatLng;
  double _estimatedDistance = 0;
  double _estimatedDuration = 0;
  double _estimatedFare = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Integration'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(37.7749, -122.4194),
                zoom: 12.0,
              ),
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                });
              },
              onTap: (LatLng latLng) {
                _handleMapTap(latLng);
              },
              markers: _buildMarkers(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _pickupController,
                  decoration: InputDecoration(
                    labelText: 'Pickup Point',
                  ),
                ),
                TextField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    labelText: 'Destination Point',
                  ),
                ),
                ElevatedButton(
                  onPressed: _handleRideBooking,
                  child: Text('Book Ride'),
                ),
                Text('Estimated Distance: $_estimatedDistance km'),
                Text('Estimated Duration: $_estimatedDuration mins'),
                Text('Estimated Fare: \$$_estimatedFare'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    Set<Marker> markers = {};

    if (_pickupLatLng != null) {
      markers.add(
        Marker(
          markerId: MarkerId('pickup'),
          position: _pickupLatLng!,
          infoWindow: InfoWindow(title: 'Pickup'),
        ),
      );
    }

    if (_destinationLatLng != null) {
      markers.add(
        Marker(
          markerId: MarkerId('destination'),
          position: _destinationLatLng!,
          infoWindow: InfoWindow(title: 'Destination'),
        ),
      );
    }

    return markers;
  }

  void _handleMapTap(LatLng latLng) {
    if (_pickupLatLng == null) {
      setState(() {
        _pickupLatLng = latLng;
        _pickupController.text = latLng.toString();
      });
    } else if (_destinationLatLng == null) {
      setState(() {
        _destinationLatLng = latLng;
        _destinationController.text = latLng.toString();
        _calculateEstimation();
      });
    }
  }

  void _calculateEstimation() async {
    if (_pickupLatLng != null && _destinationLatLng != null) {
      double distance = await _calculateDistance(
        _pickupLatLng!,
        _destinationLatLng!,
      );

      double duration = _calculateDuration(distance);
      double fare = _calculateFare(distance);

      setState(() {
        _estimatedDistance = distance;
        _estimatedDuration = duration;
        _estimatedFare = fare;
      });
    }
  }

  Future<double> _calculateDistance(
    LatLng startLatLng,
    LatLng endLatLng,
  ) async {
    List<Location> startLocations = await locationFromAddress(
      _getAddressFromLatLng(startLatLng),
    );
    List<Location> endLocations = await locationFromAddress(
      _getAddressFromLatLng(endLatLng),
    );

    LatLng startLocation = LatLng(0, 0); // Dummy initial value
    LatLng endLocation = LatLng(0, 0); // Dummy initial value

    if (startLocations.isNotEmpty) {
      startLocation = LatLng(
        startLocations.first.latitude,
        startLocations.first.longitude,
      );
    }

    if (endLocations.isNotEmpty) {
      endLocation = LatLng(
        endLocations.first.latitude,
        endLocations.first.longitude,
      );
    }

    double distance = await Geolocator.distanceBetween(
      startLocation.latitude,
      startLocation.longitude,
      endLocation.latitude,
      endLocation.longitude,
    );

    return distance / 1000; // Convert to kilometers
  }

  String _getAddressFromLatLng(LatLng latLng) {
    return '${latLng.latitude},${latLng.longitude}';
  }

  double _calculateDuration(double distance) {
    double averageSpeed = 30; // km/h
    double duration = distance / averageSpeed * 60; // minutes
    return duration;
  }

  double _calculateFare(double distance) {
    double ratePerKm = 1.5;
    double fare = distance * ratePerKm;
    return fare;
  }

  void _handleRideBooking() async {
    if (_pickupLatLng != null && _destinationLatLng != null) {
      // Save the booking details to Firestore or trigger any relevant actions
      // You can use Firebase Firestore or any other backend service for data storage and retrieval
      // In this example, we'll save the booking details to Firestore

      String pickupAddress = await _getAddressFromLatLng(_pickupLatLng!);
      String destinationAddress =
          await _getAddressFromLatLng(_destinationLatLng!);

      CollectionReference rideOffersRef =
          FirebaseFirestore.instance.collection('rideRequest');

      await rideOffersRef.add({
        'pickup': pickupAddress,
        'destination': destinationAddress,
        'status': 'pending',
        'userId': FirebaseAuth.instance.currentUser!.uid,
      });

      // Print the booking details
      print('Ride booked from $_pickupLatLng to $_destinationLatLng');
      print('Pickup Address: $pickupAddress');
      print('Destination Address: $destinationAddress');
      print('Estimated Distance: $_estimatedDistance km');
      print('Estimated Duration: $_estimatedDuration mins');
      print('Estimated Fare: \$$_estimatedFare');
    }
  }
}
