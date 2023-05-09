import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_sharing_app/screens/home.dart';
import 'package:ride_sharing_app/screens/login.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    sendEmailVerification();
  }

  // Send email verification to the user's email
  Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser; // Declare user as nullable
    if (user != null && !user.emailVerified) {
      // Check for null and email verification status
      await user.sendEmailVerification();
    }
  }

// Check if the user's email is verified
  bool isEmailVerified() {
    User? user = _auth.currentUser; // Declare user as nullable
    return user?.emailVerified ??
        false; // Use null-aware operator and provide a default value
  }

  @override
  Widget build(BuildContext context) => isEmailVerified()
      ? const HomePage()
      : Scaffold(
          appBar: AppBar(
            title: const Text('Email Verification'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'A verification email has been sent to your email address. Please verify your email before continuing.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: const Text('Login Page'),
                ),
              ],
            ),
          ),
        );
}
