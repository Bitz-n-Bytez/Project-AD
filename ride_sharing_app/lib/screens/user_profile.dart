import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ride_sharing_app/screens/google_auth.dart';
import 'login.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              logoWidget("images/tprofileImage.jpg"),
              SizedBox(
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 10),
              Text(FirebaseAuth.instance.currentUser!.displayName!,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20),
              SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Edit Profile",
                          style: TextStyle(color: Colors.black)))),
<<<<<<< HEAD
=======

>>>>>>> 0ef6e23228f86924630363bc903198cfbb173f98
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
                child: SizedBox(
                    child: CupertinoButton.filled(
                        child: const FittedBox(
                          child: Text(
                            'Logout',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 20),
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
      ),
    );
  }
}
