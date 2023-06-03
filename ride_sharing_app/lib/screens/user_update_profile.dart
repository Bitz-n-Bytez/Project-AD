import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_profile.dart';

class UserProfileUpdateScreen extends StatefulWidget {
  @override
  _UserProfileUpdateScreenState createState() =>
      _UserProfileUpdateScreenState();
}

class _UserProfileUpdateScreenState extends State<UserProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .update({
          'name': _nameController.text.trim(),
          'username': _usernameController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
    // ignore: use_build_context_synchronously
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserProfile()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextField(
                    controller: _usernameController,
                    style:
                        const TextStyle(color: Color.fromARGB(255, 15, 14, 14)),
                    decoration: const InputDecoration(
                      labelText: "Username",
                      labelStyle: TextStyle(color: Colors.black),
                      icon: Icon(
                        Icons.people,
                        color: Color.fromARGB(255, 22, 22, 22),
                      ), //icon at head of input
                    )),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextField(
                    controller: _nameController,
                    style:
                        const TextStyle(color: Color.fromARGB(255, 12, 12, 12)),
                    decoration: const InputDecoration(
                      labelText: "Name",
                      labelStyle: TextStyle(color: Colors.black),
                      icon: Icon(
                        Icons.account_box_rounded,
                        color: Color.fromARGB(255, 18, 17, 17),
                      ), //icon at head of input
                    )),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: updateProfile,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
