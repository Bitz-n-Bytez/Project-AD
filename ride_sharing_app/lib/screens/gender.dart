import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ride_sharing_app/screens/select_place_rider.dart';

class RideRequestScreen extends StatefulWidget {
  const RideRequestScreen({super.key});

  @override
  State<RideRequestScreen> createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  String _gender = 'Any';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _sourceController,
              decoration: InputDecoration(labelText: 'Source'),
            ),
            TextFormField(
              controller: _destinationController,
              decoration: InputDecoration(labelText: 'Destination'),
            ),
            DropdownButton(
              value: _gender,
              items: [
                DropdownMenuItem(
                  value: 'Any',
                  child: Text('Any'),
                ),
                DropdownMenuItem(
                  value: 'Male',
                  child: Text('Male'),
                ),
                DropdownMenuItem(
                  value: 'Female',
                  child: Text('Female'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Add ride request to Firestore
                FirebaseFirestore.instance.collection('rideRequests').add({
                  'source': _sourceController.text,
                  'destination': _destinationController.text,
                  'gender': _gender,
                });

                // Navigate back to the home screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RiderFrontPage()));
              },
              child: const Text('Request Ride'),
            ),
          ],
        ),
      ),
    );
  }
}
