import 'dart:io';
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

  TextEditingController username = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  File _documentFile = File('');
  final picker = ImagePicker();

  Future<void> _pickDocument() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _documentFile = File(pickedFile!.path);
    });
  }

  Future<void> _uploadDocument() async {
    if (_documentFile == null) {
      // show an error message to the user
      return;
    }

    final storage = FirebaseStorage.instance;
    final reference =
        storage.ref().child('documents/${DateTime.now().toString()}');
    final uploadTask = reference.putFile(_documentFile);
    await uploadTask.whenComplete(() => null);

    final url = await reference.getDownloadURL();
    // do something with the download URL (e.g. store it in Firebase Firestore)
  }

  @override
  void initState() {
    username.text = ""; //innitail value of text field
    name.text = "";
    email.text = "";
    password.text = "";
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
                    Color.fromARGB(255, 106, 106, 105),
                  ], // Gradient from https://learnui.design/tools/gradient-generator.html
                  tileMode: TileMode.mirror,
                )),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    if (_documentFile != null)
                      Image.file(
                        _documentFile,
                        height: 200,
                      ),
                    logoWidget("images/logo.png"),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: TextField(
                          controller: username,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 254, 252, 252)),
                          decoration: const InputDecoration(
                            labelText: "Username",
                            icon: Icon(
                              Icons.people,
                              color: Colors.white,
                            ), //icon at head of input
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: TextField(
                          controller: name,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 254, 252, 252)),
                          decoration: const InputDecoration(
                            labelText: "Name",
                            icon: Icon(
                              Icons.account_box_rounded,
                              color: Colors.white,
                            ), //icon at head of input
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: TextField(
                          controller: email,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 254, 252, 252)),
                          decoration: const InputDecoration(
                            labelText: "Email",
                            icon: Icon(
                              Icons.email,
                              color: Colors.white,
                            ), //icon at head of input
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: TextField(
                          controller: password,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 254, 252, 252)),
                          obscureText: _isHidden,
                          decoration: InputDecoration(
                            icon: const Icon(
                              Icons.lock,
                              color: Colors.white,
                            ), //icon at head of input
                            //prefixIcon: Icon(Icons.people), //you can use prefixIcon property too.
                            labelText: "Password",
                            suffix: InkWell(
                              onTap: _togglePasswordView,
                              child: const Icon(
                                Icons.visibility,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: ElevatedButton(
                        onPressed: _pickDocument,
                        child: const Text('Select Document'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: SizedBox(
                          child: CupertinoButton.filled(
                              child: const FittedBox(
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                ),
                              ),
                              onPressed: () async {
                                _uploadDocument;
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: email.text,
                                        password: password.text)
                                    .then((value) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const EmailVerificationPage()));
                                }).onError((error, stackTrace) {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    text: 'Check all the details again!',
                                  );
                                });
                              })),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        child: SignInButton(
                          Buttons.Google,
                          text: "Sign in with Google",
                          onPressed: () async {
                            // ignore: use_build_context_synchronously
                            await GoogleAuth().handleSignIn();
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const EmailVerificationPage()));
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: TextButton(
                          child: const Text(
                            "Already have an account? Login",
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "Dubai",
                                fontSize: 14),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                        )),
                  ],
                ),
              ),
            )));
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
