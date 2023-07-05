import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_sharing_app/screens/driver_home.dart';

class CarPoolPickupPage extends StatefulWidget {
  final String requestId;

  CarPoolPickupPage({required this.requestId});

  @override
  _CarPoolPickupPageState createState() => _CarPoolPickupPageState();
}

class _CarPoolPickupPageState extends State<CarPoolPickupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pickup and Destination'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('carpools')
            .doc(widget.requestId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final pickupPoint = data['pickup_point'];
            final destination = data['destination'];
            final time = data['departure_time'];

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 16.0),
                  Text(
                    'Pickup Point:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    pickupPoint,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Destination:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    destination,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Departure Time:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection('carpools')
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

class RideCompletionPage extends StatelessWidget {
  final String requestId;

  RideCompletionPage({required this.requestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Completion'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DriverHomePage(),
                  ),
                );
              },
              child: Text('Ride Complete'),
            ),
          ],
        ),
      ),
    );
  }
}
