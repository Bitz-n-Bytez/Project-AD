import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ride_sharing_app/screens/customer_home.dart';
import 'package:ride_sharing_app/screens/driver_home.dart';
import 'new_payment.dart';

class RiderRideComplete extends StatefulWidget {
  final String requestId;

  RiderRideComplete({required this.requestId});

  @override
  State<RiderRideComplete> createState() => _RiderRideCompleteState();
}

class _RiderRideCompleteState extends State<RiderRideComplete> {
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Completion'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rideRequests')
            .doc(widget.requestId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final farePrice = data['fare'] as double?;
            final driverId = data['driverId'] as String?;

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fare Price: RM ${farePrice?.toStringAsFixed(2) ?? 'N/A'}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Review the driver:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      hintText: 'Enter your review',
                      hintStyle: TextStyle(
                          color: Colors.black), // Set hint text color to black
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      String review = _reviewController.text;
                      submitReview(driverId, review);

                      await QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text: 'Review Submitted Successfully!',
                      );

                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            farePrice: farePrice ?? 0.0,
                            requestId: widget.requestId,
                          ),
                        ),
                      );
                    },
                    child: Text('Pay Fare'),
                  ),
                ],
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void submitReview(String? driverId, String review) {
    if (driverId == null) {
      return;
    }

    FirebaseFirestore.instance.collection('driverReviews').add({
      'driverId': driverId,
      'review': review,
      'timestamp': DateTime.now(),
    }).then((value) {
      print('Review submitted successfully');
    }).catchError((error) {
      print('Failed to submit review: $error');
    });
  }
}
