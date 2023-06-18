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
  late Stream<DocumentSnapshot> rideRequestStream;
  Timer? timer;
  bool navigateToDetailsPage = false;
  bool navigateToHomePage = false;

  @override
  void initState() {
    super.initState();
    rideRequestStream = FirebaseFirestore.instance
        .collection('rideRequests')
        .doc(widget.requestId)
        .snapshots();
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkRideStatus();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void checkRideStatus() {
    final rideRequestSnapshot =
        rideRequestStream as DocumentSnapshot<Map<String, dynamic>>?;

    if (rideRequestSnapshot != null && rideRequestSnapshot.exists) {
      final data = rideRequestSnapshot.data();

      if (data != null) {
        final status = data['status'] as String?;
        final driverId = data['driverId'] as String?;

        if (status == 'Accepted') {
          timer?.cancel(); // Stop the timer
          // Redirect to connected page
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Ride Request Accepted!',
          );
          setState(() {
            navigateToDetailsPage = true;
          });
        } else if (status == 'Rejected') {
          timer?.cancel(); // Stop the timer
          // Redirect to rider home page
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Sorry, your request has been rejected!',
          );
          setState(() {
            navigateToHomePage = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (navigateToDetailsPage) {
      return RideDetailsPage(requestId: widget.requestId);
    }

    if (navigateToHomePage) {
      return const CustomerHomePage();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Status'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: rideRequestStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>?;

            if (data != null) {
              final status = data['status'] as String?;

              if (status == 'pending') {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Searching for drivers...'),
                      SizedBox(height: 16),
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }
            }
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
