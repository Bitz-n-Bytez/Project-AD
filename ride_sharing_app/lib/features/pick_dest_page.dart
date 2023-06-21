import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dri_completed_ride.dart';

class PickupDestinationPage extends StatefulWidget {
  final String requestId;

  PickupDestinationPage({required this.requestId});

  @override
  _PickupDestinationPageState createState() => _PickupDestinationPageState();
}

class _PickupDestinationPageState extends State<PickupDestinationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pickup and Destination'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rideRequests')
            .doc(widget.requestId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final pickupLocation = data['pickup'] as GeoPoint?;
            final destinationLocation = data['destination'] as GeoPoint?;

            final pickupLatLng = pickupLocation != null
                ? LatLng(pickupLocation.latitude, pickupLocation.longitude)
                : null;

            final destinationLatLng = destinationLocation != null
                ? LatLng(
                    destinationLocation.latitude, destinationLocation.longitude)
                : null;

            return Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: pickupLatLng ?? LatLng(0, 0),
                      zoom: 15,
                    ),
                    markers: {
                      if (pickupLatLng != null)
                        Marker(
                          markerId: MarkerId('pickup'),
                          position: pickupLatLng,
                          infoWindow: InfoWindow(title: 'Pickup'),
                        ),
                      if (destinationLatLng != null)
                        Marker(
                          markerId: MarkerId('destination'),
                          position: destinationLatLng,
                          infoWindow: InfoWindow(title: 'Destination'),
                        ),
                      if (pickupLatLng != null && destinationLatLng != null)
                        Marker(
                          markerId: MarkerId('route'),
                          position: LatLng(
                            (pickupLatLng.latitude +
                                    destinationLatLng.latitude) /
                                2,
                            (pickupLatLng.longitude +
                                    destinationLatLng.longitude) /
                                2,
                          ),
                          infoWindow: InfoWindow(title: 'Route'),
                        ),
                    },
                    polylines: {
                      if (pickupLatLng != null && destinationLatLng != null)
                        Polyline(
                          polylineId: PolylineId('route'),
                          color: Colors.blue,
                          width: 3,
                          points: [pickupLatLng, destinationLatLng],
                        ),
                    },
                  ),
                ),
              ],
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection('rideRequests')
              .doc(widget.requestId)
              .update({'status': 'completed'});
          // Navigate to a new page to show pickup and destination points
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RideCompletionPage(
                requestId: widget.requestId,
              ),
            ),
          );
        },
        child: Text('Arrived Destination'),
      ),
    );
  }
}
