import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _emailController.text = "";
    super.initState();
  }

  Future passwordReset() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailController.text.trim());
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
                    Color.fromARGB(255, 167, 167, 165),
                  ], // Gradient from https://learnui.design/tools/gradient-generator.html
                  tileMode: TileMode.mirror,
                )),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    logoWidget("images/logo.png"),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: TextField(
                          controller: _emailController,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 254, 252, 252)),
                          decoration: const InputDecoration(
                            labelText: "Enter Your Email",
                            icon: Icon(
                              Icons.email,
                              color: Colors.white,
                            ), //icon at head of input
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 35),
                      child: SizedBox(
                          child: CupertinoButton.filled(
                              child: const FittedBox(
                                child: Text(
                                  'Get Reset Link',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                ),
                              ),
                              onPressed: () {
                                if (!RegExp(
                                        r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                                    .hasMatch(_emailController.text)) {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    text: 'Please write a valid email!',
                                  );
                                } else {
                                  passwordReset();
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.success,
                                    text: 'Link Sent Successfully!',
                                  );
                                }
                              })),
                    ),
                  ],
                ),
              ),
            )));
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
