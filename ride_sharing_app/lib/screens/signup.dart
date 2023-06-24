import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/cupertino.dart';
import 'package:ride_sharing_app/screens/email_verify.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:ride_sharing_app/screens/login.dart';
import 'google_auth.dart';

class SignUpDriver extends StatefulWidget {
  const SignUpDriver({super.key});

  @override
  State<SignUpDriver> createState() => _SignUpDriverState();
}

class _SignUpDriverState extends State<SignUpDriver> {
  bool _isHidden = true;
  String _userType = 'driver';
  String? categoryValue;

  TextEditingController username = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController carNumber = TextEditingController();

  @override
  void initState() {
    username.text = ""; //innitail value of text field
    name.text = "";
    email.text = "";
    password.text = "";
    carNumber.text = "";
    super.initState();
  }

  File? _document;

  Future<void> _uploadDocument() async {
    if (_document == null) return;

    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('documents').child('my_document.pdf');

    final task = ref.putFile(_document!);

    try {
      await task;
      print('Document uploaded successfully');
    } on FirebaseException catch (e) {
      print('Error uploading document: $e');
    }
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      setState(() {
        _document = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg.jpg"),
            opacity: 0.1,
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color.fromARGB(255, 4, 4, 4),
              Color.fromARGB(255, 75, 74, 74),
              Color.fromARGB(255, 106, 106, 105),
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                logoWidget("images/logo.png"),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: TextField(
                    controller: username,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 254, 252, 252),
                    ),
                    decoration: const InputDecoration(
                      labelText: "Username",
                      icon: Icon(
                        Icons.people,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: TextField(
                    controller: name,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 254, 252, 252),
                    ),
                    decoration: const InputDecoration(
                      labelText: "Name",
                      icon: Icon(
                        Icons.account_box_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: TextField(
                    controller: email,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 254, 252, 252),
                    ),
                    decoration: const InputDecoration(
                      labelText: "Email",
                      icon: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: TextField(
                    controller: password,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 254, 252, 252),
                    ),
                    obscureText: _isHidden,
                    decoration: InputDecoration(
                      icon: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      labelText: "Password",
                      suffix: InkWell(
                        onTap: _togglePasswordView,
                        child: const Icon(
                          Icons.visibility,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: DropdownButton(
                    style: const TextStyle(color: Colors.white),
                    dropdownColor: Colors.lightGreen,
                    iconSize: 40,
                    iconEnabledColor: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                        .copyWith(topLeft: Radius.circular(0)),
                    hint: const Text(
                      'Select your category',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: categoryValue,
                    onChanged: (val) {
                      setState(() {
                        categoryValue = val.toString();
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        child: Text("Driver"),
                        value: "driver",
                      ),
                      DropdownMenuItem(
                        child: Text("Rider"),
                        value: "rider",
                      ),
                    ],
                  ),
                ),
                if (categoryValue == 'driver')
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextField(
                      controller: carNumber,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 254, 252, 252),
                      ),
                      decoration: const InputDecoration(
                        labelText: "Car Number",
                        icon: Icon(
                          Icons.directions_car,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: ElevatedButton(
                    onPressed: _pickDocument,
                    child: const Text('Upload your driving license'),
                  ),
                ),
                ElevatedButton(
                  onPressed: _uploadDocument,
                  child: const Text('Submit'),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: SizedBox(
                    child: CupertinoButton.filled(
                      child: const FittedBox(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        final User? user = (await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                          email: email.text.trim(),
                          password: password.text.trim(),
                        )
                                .catchError((errMsg) {
                          Navigator.pop(context);
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            text: 'Error message: $errMsg',
                          );
                          print("Our Error message: $errMsg");
                        }))
                            .user;
                        if (user != null) {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(user.uid)
                              .set({
                                "username": username.text.trim(),
                                "name": name.text.trim(),
                                "email": email.text.trim(),
                                "type": categoryValue,
                                "carNumber": carNumber.text.trim(),
                              })
                              .then((value) => null)
                              .catchError((onError) {});
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const EmailVerificationPage(),
                            ),
                          );
                          print("User created successfully");
                        } else {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            text: 'User account creation failed',
                          );
                          print("User account creation failed");
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: TextButton(
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Dubai",
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 200,
    height: 200,
  );
}
