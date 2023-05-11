import 'package:firebase_core/firebase_core.dart';
import 'package:ride_sharing_app/screens/home.dart';
import 'package:ride_sharing_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:ride_sharing_app/screens/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTM Go',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 250, 249, 249)),
          ),
          hintStyle: TextStyle(
              color: Color.fromARGB(255, 250, 248, 248)), //<-- SEE HERE
          labelStyle: TextStyle(
              color: Color.fromARGB(255, 247, 244, 244)), //<-- SEE HERE
        ),
      ),
      home: const UserProfile(),
    );
  }
}
