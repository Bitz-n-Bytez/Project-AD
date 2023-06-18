import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ride_sharing_app/screens/driver_home.dart';

class RideCompletionPage extends StatefulWidget {
  final String requestId;

  RideCompletionPage({required this.requestId});

  @override
  _RideCompletionPageState createState() => _RideCompletionPageState();
}

class _RideCompletionPageState extends State<RideCompletionPage> {
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
            final riderName = data['name'] as String?;
            final riderId = data['userId'] as String?;

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
                    'Rider: ${riderName ?? 'Unknown'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Review the rider:',
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
                      submitReview(riderId, review);

                      await QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text: 'Review Submitted Successfully!',
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const DriverHomePage()), // Replace DriverHomePage() with the desired page to navigate to
                      );
                    },
                    child: Text('Submit'),
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

  void submitReview(String? riderId, String review) {
    if (riderId == null) {
      return;
    }

    FirebaseFirestore.instance.collection('riderReviews').add({
      'riderId': riderId,
      'review': review,
      'timestamp': DateTime.now(),
    }).then((value) {
      print('Review submitted successfully');
    }).catchError((error) {
      print('Failed to submit review: $error');
    });
  }
}
