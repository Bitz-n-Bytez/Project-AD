import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login.dart';

class RiderFrontPage extends StatefulWidget {
  const RiderFrontPage({super.key});

  @override
  State<RiderFrontPage> createState() => _RiderFrontPageState();
}

class _RiderFrontPageState extends State<RiderFrontPage> {
  final CollectionReference _ridesCollection =
      FirebaseFirestore.instance.collection('rides');

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rider Front Page'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.42796133580664, -122.1419443969116),
              zoom: 15,
            ),
            markers: markers,
          ),
          const Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Pickup Point',
              ),
            ),
          ),
          const Positioned(
            top: 150,
            left: 20,
            right: 20,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Destination',
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                // Request a ride

                // Get the pickup point and destination from the text fields.
                final pickupPoint =
                    LatLng(37.42796133580664, -122.1419443969116);
                final destination =
                    LatLng(37.77518134938377, -122.41834081074722);

                // Create a ride request.
                Map<String, dynamic> rideRequest = {
                  'pickupPoint': pickupPoint,
                  'destination': destination,
                };

                // Add the ride request to the database.
                _ridesCollection.add(rideRequest);
              },
              child: const Text('Request Ride'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
            child: SizedBox(
                child: CupertinoButton.filled(
                    child: const FittedBox(
                      child: Text(
                        'Logout',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 20),
                      ),
                    ),
                    onPressed: () async {
                      await GoogleSignIn().signOut();
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    })),
          ),
        ],
      ),
    );
  }
}
