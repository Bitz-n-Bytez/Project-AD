import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'chat_page.dart';
import 'pick_dest_page.dart';

class RideStatusPage extends StatefulWidget {
  final String requestId;

  RideStatusPage({required this.requestId});

  @override
  State<RideStatusPage> createState() => _RideStatusPageState();
}

class _RideStatusPageState extends State<RideStatusPage> {
  late StreamSubscription<DocumentSnapshot> _subscription;
  Set<Marker> _markers = {};
  String? acceptedRiderId;

  @override
  void initState() {
    super.initState();
    // Subscribe to the driver's location changes and retrieve the accepted rider's ID
    _subscribeToDriverLocation();
    _retrieveAcceptedRiderId();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _subscribeToDriverLocation() {
    _subscription = FirebaseFirestore.instance
        .collection('rideRequests')
        .doc(widget.requestId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final driverLocation = data['driverLocation'] as GeoPoint?;

        if (driverLocation != null) {
          setState(() {
            // Update the marker with the new driver's location
            _markers = {
              Marker(
                markerId: MarkerId('driver'),
                position:
                    LatLng(driverLocation.latitude, driverLocation.longitude),
                infoWindow: InfoWindow(title: 'Driver'),
              ),
            };
          });
        }
      }
    });
  }

  void _retrieveAcceptedRiderId() {
    FirebaseFirestore.instance
        .collection('rideRequests')
        .doc(widget.requestId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final acceptedRiderId = data['userId'] as String?;
        setState(() {
          this.acceptedRiderId = acceptedRiderId;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Status'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rideRequests')
            .doc(widget.requestId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final riderLocation = data['pickup'] as GeoPoint?;
            final farePrice = data['fare'] as double?;

            final riderLatLng = riderLocation != null
                ? LatLng(riderLocation.latitude, riderLocation.longitude)
                : null;

            return Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: riderLatLng ?? LatLng(0, 0),
                      zoom: 15,
                    ),
                    markers: {
                      if (riderLatLng != null)
                        Marker(
                          markerId: MarkerId('rider'),
                          position: riderLatLng,
                          infoWindow: InfoWindow(title: 'Rider'),
                        ),
                      ..._markers,
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                      'Fare Price: RM ${farePrice?.toStringAsFixed(2) ?? 'N/A'}'),
                ),
              ],
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (acceptedRiderId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  senderId: FirebaseAuth.instance.currentUser?.uid,
                  receiverId: acceptedRiderId,
                ),
              ),
            );
          }
        },
        child: Icon(Icons.chat),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          // Navigate to a new page to show pickup and destination points
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PickupDestinationPage(
                requestId: widget.requestId,
              ),
            ),
          );
        },
        child: Text('Ride Started'),
      ),
    );
  }
}
