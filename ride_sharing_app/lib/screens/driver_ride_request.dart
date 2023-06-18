import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ride_sharing_app/screens/driver_home.dart';
import 'package:location/location.dart';

import '../features/ride_status.dart';

class DriverRideRequest extends StatefulWidget {
  @override
  State<DriverRideRequest> createState() => _DriverRideRequestState();
}

class _DriverRideRequestState extends State<DriverRideRequest> {
  late GoogleMapController _mapController;
  Set<Polyline> _polylines = {};

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  // Function to update the status in Firestore
  void updateRideStatus(String requestId, String newStatus) {
    FirebaseFirestore.instance
        .collection('rideRequests')
        .doc(requestId)
        .update({'status': newStatus}).then((value) {
      // Status updated successfully
      print('Status updated');
    }).catchError((error) {
      // Error occurred while updating status
      print('Failed to update status: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Ride Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rideRequests')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final rideRequests = snapshot.data!.docs;

            return ListView.builder(
              itemCount: rideRequests.length,
              itemBuilder: (context, index) {
                final data = rideRequests[index].data() as Map<String, dynamic>;

                final requestId = rideRequests[index].id; // Get the document ID
                final userId = data['userId'] as String;
                final pickup = data['pickup'] as GeoPoint;
                final destination = data['destination'] as GeoPoint;
                final distance = data['distance'] as double;
                final duration = data['duration'] as double;
                final fare = data['fare'] as double;
                final status = data['status'] as String;

                final pickupLatLng = LatLng(pickup.latitude, pickup.longitude);
                final destinationLatLng =
                    LatLng(destination.latitude, destination.longitude);

                // Define the polyline options
                final polyline = Polyline(
                  polylineId: PolylineId(requestId),
                  color: Colors.blue,
                  width: 4,
                  points: [pickupLatLng, destinationLatLng],
                );

                _polylines.add(polyline); // Add the polyline to the set

                return Column(
                  children: [
                    ListTile(
                      title: Text('User ID: $userId'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Pickup: (${pickup.latitude}, ${pickup.longitude})'),
                          Text(
                              'Destination: (${destination.latitude}, ${destination.longitude})'),
                          Text('Distance: $distance'),
                          Text('Duration: $duration'),
                          Text('Fare: $fare'),
                          Text('Status: $status'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 200, // Adjust the height as needed
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          _mapController.animateCamera(
                            CameraUpdate.scrollBy(
                              -details.delta.dx,
                              -details.delta.dy,
                            ),
                          );
                        },
                        child: GoogleMap(
                          onMapCreated: (controller) {
                            setState(() {
                              _mapController = controller;
                            });
                          },
                          markers: {
                            Marker(
                              markerId: MarkerId('pickup'),
                              position: pickupLatLng,
                              infoWindow: InfoWindow(title: 'Pickup'),
                            ),
                            Marker(
                              markerId: MarkerId('destination'),
                              position: destinationLatLng,
                              infoWindow: InfoWindow(title: 'Destination'),
                            ),
                          },
                          polylines: _polylines, // Set the polylines
                          initialCameraPosition: CameraPosition(
                            target: pickupLatLng,
                            zoom: 15,
                          ),
                        ),
                      ),
                    ),
                    ButtonBar(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            // Accept the ride request
                            updateRideStatus(requestId, 'Accepted');

                            // Connect with the rider
                            // Perform actions to establish the connection
                            // Notify the rider
                            FirebaseFirestore.instance
                                .collection('rideRequests')
                                .doc(requestId)
                                .update({
                              'driverId': FirebaseAuth.instance.currentUser?.uid
                            });

                            await QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              text: 'Ride Request Accepted!',
                            );

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    RideStatusPage(requestId: requestId),
                              ),
                            );
                          },
                          child: Text('Accept'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            updateRideStatus(requestId, 'Rejected');

                            await QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              text: 'Ride Request Rejected!',
                            );

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const DriverHomePage(),
                              ),
                            );
                          },
                          child: Text('Reject'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

// void updateDriverLocation(double latitude, double longitude) {
//   final userId = FirebaseAuth
//       .instance.currentUser?.uid; // Replace with your driver's user ID

//   FirebaseFirestore.instance.collection('drivers').doc(userId).update({
//     'latitude': latitude,
//     'longitude': longitude,
//   }).then((value) {
//     // Location updated successfully
//     print('Driver location updated');
//   }).catchError((error) {
//     // Error occurred while updating location
//     print('Failed to update driver location: $error');
//   });
// }

// // Example usage inside the RideStatusPage widget
// final Location location = Location();

// // Inside a method or lifecycle callback where you want to update the location
// void updateLocation() async {
//   LocationData? currentLocation;

//   try {
//     currentLocation = await location.getLocation();
//   } catch (e) {
//     // Handle location retrieval error
//     print('Error retrieving location: $e');
//     return;
//   }

//   final double latitude = currentLocation.latitude!;
//   final double longitude = currentLocation.longitude!;

//   // Update the driver's location in Firestore
//   updateDriverLocation(latitude, longitude);
// }
