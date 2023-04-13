import 'package:ride_sharing_app/screens/forget.dart';
import 'package:ride_sharing_app/screens/signup.dart';
import 'package:ride_sharing_app/screens/login.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
      
      home: const Login(),
    );
  }
}
