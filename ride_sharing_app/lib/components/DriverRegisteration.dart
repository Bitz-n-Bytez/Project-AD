import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ride_sharing_app/screens/gender.dart';
import 'package:ride_sharing_app/screens/showriderequest.dart';
import 'package:ride_sharing_app/screens/user_profile.dart';
import 'email_verify.dart';
import 'Signup.dart';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grab Driver Registration'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Middle Name',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Last Name',
                ),
              ),

              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email Address',
                ),

              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Car Model',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Car Plate Number',
                ),
              ),

              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _pickDocument(),
                child: Text('Upload Identity Proof'),
              ),
               SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _pickDocument(),
                child: Text('Upload UTM Matric Card'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _pickDocument(),
                child: Text('Upload Car Geran'),
              ),

              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _pickDocument(),
                child: Text('Upload Car Insurance'),
              ),

              

              SizedBox(height: 16.0),
              _selectedFile != null
                  ? Text('Selected File: ${_selectedFile.path}')
                  : Container(),

              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Implement registration logic here
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}