import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RideTypeSelector extends StatefulWidget {
  @override
  _RideTypeSelectorState createState() => _RideTypeSelectorState();
}

class _RideTypeSelectorState extends State<RideTypeSelector> {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  String _rideType = 'Solo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Type Selector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Select the type of ride you want to accept'),
            DropdownButton(
              value: _rideType,
              onChanged: (value) {
                setState(() {
                  _rideType = value!;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 'Solo',
                  child: Text('Solo Ride'),
                ),
                DropdownMenuItem(
                  value: 'Carpool',
                  child: Text('Carpool Ride'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Save the ride type to the user's profile
                _usersCollection
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .update({'rideType': _rideType});

                // Navigate to the driver's dashboard
                Navigator.pushNamed(context, '/driver-dashboard');
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
