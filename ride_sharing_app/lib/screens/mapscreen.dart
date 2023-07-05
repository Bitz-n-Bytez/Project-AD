import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ride_sharing_app/screens/customer_home.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as poly;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../features/rider_ride_status.dart';

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
  final places =
      GoogleMapsPlaces(apiKey: 'AIzaSyD-veSMr3-awR3JWG3uPDpQWc5HjvA03X0');
  List<LatLng> _polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  PolylinePoints _polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();
    _setInitialCameraPosition();
  }

  void _setInitialCameraPosition() {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: LatLng(
              1.5555, 103.6382), // Universiti Teknologi Malaysia, Johor Bahru
          zoom: 15.0,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Integration'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(
                    1.5555, 103.6382), // KLG Campus Residence, Johor, Malaysia
                zoom: 15.0,
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
              polylines: _polylines,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _pickupController,
                  decoration: const InputDecoration(
                    labelText: 'Pickup Point',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  onTap: () async {
                    Prediction? prediction = await PlacesAutocomplete.show(
                      context: context,
                      apiKey: 'AIzaSyD-veSMr3-awR3JWG3uPDpQWc5HjvA03X0',
                      mode: Mode.overlay,
                      language: 'en',
                    );
                    if (prediction != null) {
                      PlacesDetailsResponse details =
                          await places.getDetailsByPlaceId(prediction.placeId!);
                      final lat = details.result.geometry!.location.lat;
                      final lng = details.result.geometry!.location.lng;
                      setState(() {
                        _pickupLatLng = LatLng(lat, lng);
                        _pickupController.text =
                            details.result.formattedAddress!;
                      });
                    }
                  },
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _destinationController,
                  decoration: const InputDecoration(
                    labelText: 'Destination',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  onTap: () async {
                    Prediction? prediction = await PlacesAutocomplete.show(
                      context: context,
                      apiKey: 'AIzaSyD-veSMr3-awR3JWG3uPDpQWc5HjvA03X0',
                      mode: Mode.overlay,
                      language: 'en',
                    );
                    if (prediction != null) {
                      PlacesDetailsResponse details =
                          await places.getDetailsByPlaceId(prediction.placeId!);
                      final lat = details.result.geometry!.location.lat;
                      final lng = details.result.geometry!.location.lng;
                      setState(() {
                        _destinationLatLng = LatLng(lat, lng);
                        _destinationController.text =
                            details.result.formattedAddress!;
                        _calculateEstimation();
                        _createPolyline();
                      });
                    }
                  },
                ),
                const SizedBox(height: 8.0),
                Text('Estimated Distance: $_estimatedDistance km'),
                const SizedBox(height: 8.0),
                Text('Estimated Duration: $_estimatedDuration mins'),
                const SizedBox(height: 8.0),
                Text(
                    'Estimated Fare: ${NumberFormat.currency(locale: 'en_MY', symbol: 'MYR').format(_estimatedFare)}'),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: _requestRide,
                  child: const Text('Request Ride'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
        _createPolyline();
      });
    }
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};
    if (_pickupLatLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: _pickupLatLng!,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }
    if (_destinationLatLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: _destinationLatLng!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
    return markers;
  }

  Future<Map<String, dynamic>> _fetchRouteDetails(
      LatLng origin, LatLng destination) async {
    final apiKey = 'AIzaSyD-veSMr3-awR3JWG3uPDpQWc5HjvA03X0';
    final apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final route = data['routes'][0];
        final leg = route['legs'][0];
        final distance = leg['distance']['value']; // in meters
        final duration = leg['duration']['value']; // in seconds

        return {
          'distance': distance,
          'duration': duration,
        };
      }
    }

    return {
      'distance': 0,
      'duration': 0,
    };
  }

  void _calculateEstimation() async {
    if (_pickupLatLng != null && _destinationLatLng != null) {
      final routeDetails =
          await _fetchRouteDetails(_pickupLatLng!, _destinationLatLng!);
      final distance = routeDetails['distance'] / 1000; // Convert to kilometers
      final duration = routeDetails['duration'] / 60; // Convert to minutes
      final fare = distance * 1.75; // Assuming fare of MYR 1.5 per kilometer

      setState(() {
        _estimatedDistance = distance;
        _estimatedDuration = duration;
        _estimatedFare = fare;
      });
    }
  }

  void _createPolyline() async {
    if (_pickupLatLng != null && _destinationLatLng != null) {
      _polylines.clear();
      _polylineCoordinates.clear();
      PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyD-veSMr3-awR3JWG3uPDpQWc5HjvA03X0',
        PointLatLng(_pickupLatLng!.latitude, _pickupLatLng!.longitude),
        PointLatLng(
            _destinationLatLng!.latitude, _destinationLatLng!.longitude),
        travelMode: poly.TravelMode.driving,
      );
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });

        setState(() {
          Polyline polyline = Polyline(
            polylineId: const PolylineId('polyline'),
            color: Colors.blue,
            points: _polylineCoordinates,
            width: 3,
          );
          _polylines.add(polyline);
        });
      }
    }
  }

  void _requestRide() async {
    if (_pickupLatLng != null && _destinationLatLng != null) {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        DocumentReference rideRequestRef =
            await FirebaseFirestore.instance.collection('rideRequests').add({
          'userId': userId,
          'email': user.email,
          'name': user.displayName,
          'pickup': GeoPoint(_pickupLatLng!.latitude, _pickupLatLng!.longitude),
          'destination': GeoPoint(
              _destinationLatLng!.latitude, _destinationLatLng!.longitude),
          'distance': _estimatedDistance,
          'duration': _estimatedDuration,
          'fare': _estimatedFare,
          'status': 'pending',
        });

        String requestId = rideRequestRef.id; // Get the generated document ID

        // ignore: use_build_context_synchronously
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Request Sent Successfully!',
        );

        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
          MaterialPageRoute(
            // builder: (context) => RiderRideStatusPage(requestId: requestId),
            builder: (context) => RiderRideStatusPage(requestId: requestId),
          ),
        );
      }
    }
  }
}
