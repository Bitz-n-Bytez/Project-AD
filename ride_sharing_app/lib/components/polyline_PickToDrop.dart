import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart'
    as Poly;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LocationData? _currentLocation;

  // Define pickup and destination coordinates
  final LatLng pickupLocation = LatLng(37.7749, -122.4194);
  final LatLng destinationLocation = LatLng(37.3352, -122.0498);

  // Define polyline options
  final Set<Polyline> _polylines = {};
  final PolylineId _polylineId = PolylineId('polyline');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;

          // Draw the polyline
          _drawPolyline();
        },
        initialCameraPosition: CameraPosition(
          target: pickupLocation,
          zoom: 12.0,
        ),
        polylines: _polylines,
      ),
    );
  }

  void _drawPolyline() {
    List<LatLng> polylineCoordinates = [
      pickupLocation,
      destinationLocation,
    ];

    Polyline polyline = Polyline(
      polylineId: _polylineId,
      color: Color.fromARGB(255, 161, 25, 5),
      points: polylineCoordinates,
    );

    setState(() {
      _polylines.add(polyline);
    });

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: pickupLocation,
          northeast: destinationLocation,
        ),
        100.0,
      ),
    );
  }
}
