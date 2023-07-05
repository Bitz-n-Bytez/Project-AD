import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_app/features/ride_complete.dart';
import 'chat_page.dart';

class RideDetailsPage extends StatefulWidget {
  final String requestId;

  RideDetailsPage({required this.requestId});

  @override
  _RideDetailsPageState createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends State<RideDetailsPage> {
  String? acceptedDriverId;
  String? rideStatus;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _retrieveAcceptedDriverId();
    startTimer();
  }

  void _retrieveAcceptedDriverId() {
    FirebaseFirestore.instance
        .collection('rideRequests')
        .doc(widget.requestId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final acceptedDriverId = data['driverId'] as String?;
        final status = data['status'] as String?;
        setState(() {
          this.acceptedDriverId = acceptedDriverId;
          this.rideStatus = status;
        });
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      _checkRideStatus();
    });
  }

  void _checkRideStatus() {
    FirebaseFirestore.instance
        .collection('rideRequests')
        .doc(widget.requestId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final status = data['status'] as String?;
        if (status == 'completed') {
          timer?.cancel(); // Stop the timer
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RiderRideComplete(
                requestId: widget.requestId,
              ),
            ),
          );
        } else {
          setState(() {
            this.rideStatus = status;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rideRequests')
            .doc(widget.requestId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final pickup = data['pickup'] as GeoPoint?;
            final destination = data['destination'] as GeoPoint?;

            if (pickup != null && destination != null) {
              final pickupLatLng = LatLng(pickup.latitude, pickup.longitude);
              final destinationLatLng =
                  LatLng(destination.latitude, destination.longitude);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Pickup Point: (${pickup.latitude}, ${pickup.longitude})',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Destination Point: (${destination.latitude}, ${destination.longitude})',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: GoogleMap(
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
                      initialCameraPosition: CameraPosition(
                        target: pickupLatLng,
                        zoom: 15,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  if (acceptedDriverId != null)
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(acceptedDriverId)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.hasData) {
                            final data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            final driverName = data['name'] as String?;
                            final driverEmail = data['email'] as String?;
                            final carNumber = data['carNumber'] as String?;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Driver Details',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text('Name: $driverName'),
                                Text('Email: $driverEmail'),
                                Text('Car Number: $carNumber'),
                              ],
                            );
                          }

                          return Text('Driver details not found.');
                        },
                      ),
                    ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Perform actions to chat with the driver
                        if (rideStatus == 'Accepted') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                senderId:
                                    FirebaseAuth.instance.currentUser?.uid,
                                receiverId: acceptedDriverId,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text('Chat with Driver'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Redirect to driver's past history page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DriverHistoryPage(driverId: acceptedDriverId),
                          ),
                        );
                      },
                      child: Text('Driver History'),
                    ),
                  ),
                ],
              );
            }
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class DriverHistoryPage extends StatelessWidget {
  final String? driverId;

  DriverHistoryPage({required this.driverId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('driverReviews')
            .where('driverId', isEqualTo: driverId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final driverReviews = snapshot.data!.docs;

            return ListView.builder(
              itemCount: driverReviews.length,
              itemBuilder: (context, index) {
                final data =
                    driverReviews[index].data() as Map<String, dynamic>;

                return ListTile(
                  title: Text(data['review']),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
