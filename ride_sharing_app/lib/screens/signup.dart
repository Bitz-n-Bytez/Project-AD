import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ride_sharing_app/screens/login.dart';

class SignUpDriver extends StatefulWidget {
  const SignUpDriver({super.key});

  @override
  State<SignUpDriver> createState() => _SignUpDriverState();
}

class _SignUpDriverState extends State<SignUpDriver> {
  bool _isHidden = true;

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  void initState() {
    username.text = ""; //innitail value of text field
    password.text = "";
    confirmPassword.text = "";
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
                      child: TextField(
                          controller: confirmPassword,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 254, 252, 252)),
                          obscureText: _isHidden,
                          decoration: InputDecoration(
                            icon: const Icon(
                              Icons.lock,
                              color: Colors.white,
                            ), //icon at head of input
                            //prefixIcon: Icon(Icons.people), //you can use prefixIcon property too.
                            labelText: "Confirm Password",
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
                          horizontal: 20, vertical: 35),
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
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()));
                              })),
                    ),
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
