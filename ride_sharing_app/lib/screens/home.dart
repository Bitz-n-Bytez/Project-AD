import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ride_sharing_app/screens/login.dart';

import 'customer_home.dart';
import 'driver_home.dart';

class HomePage extends StatelessWidget {
  const HomePage({key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'images/bg.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/logo.png',
                    width: 180,
                    height: 180,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Welcome to UTMGo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0, // Add letter spacing
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        DocumentSnapshot userDocument = await FirebaseFirestore
                            .instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .get();

                        // Go to the appropriate home page based on the user's type.
                        if (userDocument['type'] != null) {
                          if (userDocument['type'] == 'driver') {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DriverHomePage(),
                              ),
                            );
                          } else {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CustomerHomePage(),
                              ),
                            );
                          }
                        } else {
                          // ignore: use_build_context_synchronously
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            text: 'User account creation failed',
                          );
                        }
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(16.0),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 198, 64,
                              255), // Set desired button background color
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // Set desired button border radius
                          ),
                        ),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Set desired button text color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
