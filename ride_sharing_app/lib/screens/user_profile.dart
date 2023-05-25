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
            ]


////MENU
ListTile(



leading: Container(
width: 40,
height: 40,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(100),
color: tAccentColor.withOpacity(0.1),
),
child: const Icon(LineAwesomeIcons.cog,color:tAccentColor),
),
title: Text(tMenu1,style:Theme.of(context).textTheme.bodyText1),


trailing: Container(
  width: 30,
  height: 30,
  decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(100),
  color: tAccentColor.withOpacity(0.1),
),
  child: const Icon(LineAwesomeIcons.cog,color:tAccentColor),
),



)
          ),
        ),
      ),
    );
  }
}
