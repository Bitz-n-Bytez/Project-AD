import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_sharing_app/screens/customer_home.dart';

class RiderBookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book a Seat'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: CarpoolsList(),
      ),
    );
  }
}

class CarpoolsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('carpools').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final carpools = snapshot.data!.docs;

          if (carpools.isEmpty) {
            return Center(
              child: Text('No carpools available.'),
            );
          }

          return ListView.builder(
            itemCount: carpools.length,
            itemBuilder: (context, index) {
              final carpool = carpools[index];
              final carpoolId = carpool.id;
              final data = carpool.data() as Map<String, dynamic>;
              final pickupPoint = data['pickup_point'];
              final destination = data['destination'];
              final departureTime = data['departure_time'];

              return ListTile(
                title: Text('Carpool ID: $carpoolId'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pickup Point: $pickupPoint'),
                    Text('Destination: $destination'),
                    Text('Departure Time: $departureTime'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () => _bookSeat(context, carpoolId),
                  child: Text('Book Seat'),
                ),
              );
            },
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _bookSeat(BuildContext context, String carpoolId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference carpoolCollection = firestore.collection('carpools');

    DocumentSnapshot carpoolDoc = await carpoolCollection.doc(carpoolId).get();

    if (carpoolDoc.exists) {
      List<dynamic>? riders = (carpoolDoc.data()
          as Map<String, dynamic>)['riders'] as List<dynamic>?;

      if (riders != null) {
        String riderId = 'rider1'; // Generate a unique rider ID
        riders.add(riderId);

        carpoolCollection.doc(carpoolId).update({
          'riders': riders,
        });
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RideCompletionPage(requestId: carpoolId)));
      }
    }
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
                    builder: (context) => const CustomerHomePage(),
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
