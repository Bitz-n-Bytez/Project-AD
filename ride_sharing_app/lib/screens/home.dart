// import 'package:flutter/cupertino.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:quickalert/quickalert.dart';
// import 'package:ride_sharing_app/screens/gender.dart';
// import 'package:ride_sharing_app/screens/user_profile.dart';
// import 'email_verify.dart';
// import 'login.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//             decoration: const BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage("images/bg.jpg"),
//                     opacity: 0.1,
//                     fit: BoxFit.cover),
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomCenter,
//                   colors: <Color>[
//                     Color.fromARGB(255, 4, 4, 4),
//                     Color.fromARGB(255, 75, 74, 74),
//                     Color.fromARGB(255, 167, 167, 165),
//                   ], // Gradient from https://learnui.design/tools/gradient-generator.html
//                   tileMode: TileMode.mirror,
//                 )),
//             child: Center(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: <Widget>[
//                     logoWidget("images/logo.png"),
//                     Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 5),
//                         child: Text(
//                             "Welcome ${FirebaseAuth.instance.currentUser!.displayName!}")),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
//                       child: SizedBox(
//                           child: CupertinoButton.filled(
//                               child: const FittedBox(
//                                 child: Text(
//                                   'User Profile',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400,
//                                       fontSize: 20),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             const UserProfile()));
//                               })),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
//                       child: SizedBox(
//                           child: CupertinoButton.filled(
//                               child: const FittedBox(
//                                 child: Text(
//                                   'Request Ride',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400,
//                                       fontSize: 20),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             const RideRequestScreen()));
//                               })),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
//                       child: SizedBox(
//                           child: CupertinoButton.filled(
//                               child: const FittedBox(
//                                 child: Text(
//                                   'Logout',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400,
//                                       fontSize: 20),
//                                 ),
//                               ),
//                               onPressed: () async {
//                                 await GoogleSignIn().signOut();
//                                 // ignore: use_build_context_synchronously
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => const Login()));
//                               })),
//                     ),
//                   ],
//                 ),
//               ),
//             )));
//   }
// }

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
