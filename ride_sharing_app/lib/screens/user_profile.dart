import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'user_update_profile.dart';

class UserProfile extends StatefulWidget {
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  User? _user;
  String? _userName;
  String? _name;
  String? _userEmail;
  String? _profileImageURL; // Added profile image URL variable

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (snapshot.exists) {
        setState(() {
          _user = user;
          _name = snapshot.data()!['name'];
          _userName = snapshot.data()!['username'];
          _userEmail = snapshot.data()!['email'];
          _profileImageURL = snapshot
              .data()!['profileImage']; // Set profile image URL from Firestore
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File profileImage = File(pickedImage.path);

      // Upload the profile image and get the download URL
      String imageURL = await _uploadProfileImage(profileImage);

      // Update the profile image URL in Firestore
      await _firestore
          .collection('users')
          .doc(_user!.uid)
          .update({'profileImage': imageURL});

      setState(() {
        _profileImageURL = imageURL;
      });
    }
  }

  Future<String> _uploadProfileImage(File profileImage) async {
    Reference storageRef =
        _storage.ref().child('profile_images/${_user!.uid}.jpg');

    try {
      await storageRef.putFile(profileImage);
      String imageURL = await storageRef.getDownloadURL();
      return imageURL;
    } catch (e) {
      print('Error uploading profile image: $e');
      return ''; // Return empty string if there's an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_user != null)
              if (_profileImageURL != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      _profileImageURL!), // Display profile image from URL
                )
              else
                CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person),
                ),
            SizedBox(height: 16),
            Text(
              _name ?? 'Loading...',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              _userName ?? 'Loading...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              _userEmail ?? 'Loading...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Change Profile Image'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileUpdateScreen(),
                  ),
                );
              },
              child: const Text('Update Profile Information'),
            ),
          ],
        ),
      ),
    );
  }
}
