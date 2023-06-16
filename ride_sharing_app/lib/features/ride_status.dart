import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RideStatusPage extends StatelessWidget {
  final String requestId;

  RideStatusPage({required this.requestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Status'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rideRequests')
            .doc(requestId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final pickup = data['pickup'] as GeoPoint;
            final destination = data['destination'] as GeoPoint;

            final driverLocation = LatLng(/* Get driver's location */);
            final riderLocation = LatLng(pickup.latitude, pickup.longitude);

            return Column(
              children: [
                SizedBox(
                  height: 200, // Adjust the height as needed
                  child: GoogleMap(
                    markers: {
                      Marker(
                        markerId: MarkerId('driver'),
                        position: driverLocation,
                        infoWindow: InfoWindow(title: 'Driver'),
                      ),
                      Marker(
                        markerId: MarkerId('rider'),
                        position: riderLocation,
                        infoWindow: InfoWindow(title: 'Rider'),
                      ),
                    },
                    initialCameraPosition: CameraPosition(
                      target: driverLocation,
                      zoom: 15,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Driver Location: (${driverLocation.latitude}, ${driverLocation.longitude})',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Rider Location: (${riderLocation.latitude}, ${riderLocation.longitude})',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
