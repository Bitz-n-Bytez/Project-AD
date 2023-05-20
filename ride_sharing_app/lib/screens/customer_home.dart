import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ride_sharing_app/screens/gender.dart';
import 'package:ride_sharing_app/screens/user_profile.dart';
import 'email_verify.dart';
import 'login.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/bg.jpg"),
                    opacity: 0.1,
                    fit: BoxFit.cover),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color.fromARGB(255, 4, 4, 4),
                    Color.fromARGB(255, 75, 74, 74),
                    Color.fromARGB(255, 167, 167, 165),
                  ], // Gradient from https://learnui.design/tools/gradient-generator.html
                  tileMode: TileMode.mirror,
                )),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    logoWidget("images/logo.png"),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Text(
                            "Welcome Rider ${FirebaseAuth.instance.currentUser!.displayName!}")),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
                      child: SizedBox(
                          child: CupertinoButton.filled(
                              child: const FittedBox(
                                child: Text(
                                  'User Profile',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const UserProfile()));
                              })),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
                      child: SizedBox(
                          child: CupertinoButton.filled(
                              child: const FittedBox(
                                child: Text(
                                  'Request Ride',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RideRequestScreen()));
                              })),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
                      child: SizedBox(
                          child: CupertinoButton.filled(
                              child: const FittedBox(
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                ),
                              ),
                              onPressed: () async {
                                await GoogleSignIn().signOut();
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()));
                              })),
                    ),
                  ],
                ),
              ),
            )));
  }
}
