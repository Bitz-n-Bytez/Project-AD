import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_sharing_app/screens/showriderequest.dart';

class DriverRideRequest extends StatefulWidget {
  const DriverRideRequest({super.key});

  @override
  State<DriverRideRequest> createState() => _DriverRideRequestState();
}

class _DriverRideRequestState extends State<DriverRideRequest> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('rideRequest').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _markers.clear();
            final rideOffers = snapshot.data!.docs;
            for (var offer in rideOffers) {
              final data = offer.data() as Map<String, dynamic>;
              final pickupLatLng = data['pickup_lat_lng'] as GeoPoint?;
              final destinationLatLng =
                  data['destination_lat_lng'] as GeoPoint?;

              if (pickupLatLng != null && destinationLatLng != null) {
                _markers.add(
                  Marker(
                    markerId: MarkerId(offer.id),
                    position:
                        LatLng(pickupLatLng.latitude, pickupLatLng.longitude),
                    infoWindow: InfoWindow(
                      title: 'Ride Offer',
                      snippet:
                          'Destination: ${destinationLatLng.latitude}, ${destinationLatLng.longitude}',
                    ),
                  ),
                );
              }
            }

            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(37.7749, -122.4194),
                zoom: 12.0,
              ),
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                });
              },
              markers: _markers,
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Handle accepting or rejecting the ride offer
          final acceptedOfferId =
              _markers.isNotEmpty ? _markers.first.markerId.value : '';
          await FirebaseFirestore.instance
              .collection('rideRequest')
              .doc(acceptedOfferId)
              .update({
            'status': 'accepted',
          });
          // ignore: use_build_context_synchronously
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ShowRideRequest()));
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
