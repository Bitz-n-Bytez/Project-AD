import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as poly;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:ride_sharing_app/features/carpool_pick_dest.dart';
import 'package:ride_sharing_app/features/pick_dest_page.dart';
import 'package:ride_sharing_app/screens/rider_carpool_book.dart';

class CarpoolScreen extends StatefulWidget {
  @override
  _CarpoolScreenState createState() => _CarpoolScreenState();
}

class _CarpoolScreenState extends State<CarpoolScreen> {
  TextEditingController _pickupController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  TimeOfDay? _selectedTime;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng? _pickupLatLng;
  LatLng? _destinationLatLng;

  List<LatLng> _polylineCoordinates = [];
  PolylinePoints _polylinePoints = PolylinePoints();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carpool'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                onTap: _handleMapTap,
                initialCameraPosition: CameraPosition(
                  target: LatLng(1.5555, 103.6382), // Initial map position
                  zoom: 15,
                ),
                markers: _markers,
                polylines: _polylines,
              ),
            ),
            TextField(
              controller: _pickupController,
              decoration: InputDecoration(
                labelText: 'Pickup Point',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                labelText: 'Destination Point',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: _selectTime,
              child: Text('Select Departure Time'),
            ),
            SizedBox(height: 16.0),
            _selectedTime != null
                ? Text('Departure Time: ${_formatTime(_selectedTime!)}')
                : SizedBox(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createCarpool,
              child: Text('Start Carpool'),
            ),
          ],
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _handleMapTap(LatLng latLng) async {
    List<geo.Placemark> placemarks =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    String address = placemarks.first.name ?? '';

    setState(() {
      if (_pickupLatLng == null) {
        _pickupLatLng = latLng;
        _pickupController.text = address;
        _markers.add(
          Marker(
            markerId: MarkerId('pickup'),
            position: _pickupLatLng!,
            infoWindow: InfoWindow(title: 'Pickup'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          ),
        );
      } else if (_destinationLatLng == null) {
        _destinationLatLng = latLng;
        _destinationController.text = address;
        _markers.add(
          Marker(
            markerId: MarkerId('destination'),
            position: _destinationLatLng!,
            infoWindow: InfoWindow(title: 'Destination'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );
        _createPolyline();
      }
    });
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

  void _selectTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _selectedTime = selectedTime;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    return time.format(context);
  }

  void _createCarpool() async {
    if (_pickupController.text.isNotEmpty &&
        _destinationController.text.isNotEmpty &&
        _selectedTime != null &&
        _pickupLatLng != null &&
        _destinationLatLng != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference carpoolCollection = firestore.collection('carpools');

      DocumentReference carpoolDoc = await carpoolCollection.add({
        'pickup_point': _pickupController.text,
        'destination': _destinationController.text,
        'departure_time': _formatTime(_selectedTime!),
        'available_seats': 4,
        'riders': [],
      });

      String carpoolId = carpoolDoc.id;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CarPoolPickupPage(requestId: carpoolId),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter all required information.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
