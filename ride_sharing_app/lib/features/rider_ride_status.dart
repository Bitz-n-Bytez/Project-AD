import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ride_sharing_app/screens/customer_home.dart';
import 'ride_details.dart';

class RiderRideStatusPage extends StatefulWidget {
  final String requestId;

  RiderRideStatusPage({required this.requestId});

  @override
  _RiderRideStatusPageState createState() => _RiderRideStatusPageState();
}

class _RiderRideStatusPageState extends State<RiderRideStatusPage> {
  late StreamSubscription<DocumentSnapshot> rideRequestSubscription;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    rideRequestSubscription = FirebaseFirestore.instance
        .collection('rideRequests')
        .doc(widget.requestId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();

        if (data != null) {
          final status = data['status'] as String?;

          if (status == 'Accepted') {
            timer?.cancel(); // Stop the timer
            // Redirect to ride details page
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Ride Request Accepted!',
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => RideDetailsPage(requestId: widget.requestId),
              ),
            );
          } else if (status == 'Rejected') {
            timer?.cancel(); // Stop the timer
            // Redirect to customer home page
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Sorry, your request has been rejected!',
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => CustomerHomePage(),
              ),
            );
          }
        }
      }
    });

    timer = Timer.periodic(Duration(seconds: 1), (_) {
      checkRideStatus();
    });
  }

  @override
  void dispose() {
    rideRequestSubscription.cancel();
    timer?.cancel();
    super.dispose();
  }

  void checkRideStatus() async {
    final rideRequestSnapshot = await FirebaseFirestore.instance
        .collection('rideRequests')
        .doc(widget.requestId)
        .get();

    if (rideRequestSnapshot.exists) {
      final data = rideRequestSnapshot.data();

      if (data != null) {
        final status = data['status'] as String?;

        if (status == 'pending') {
          // Show "Searching for drivers" UI
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Status'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Searching for drivers...'),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
