import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ride_sharing_app/screens/signup.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'email_verify.dart';
import 'google_auth.dart';
import 'forget.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isHidden = true;
  String _selectedLanguage = 'English'; // Default language selection

  List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Japanese',
    'Korean',
  ];

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    email.text = ''; // Initial value of text field
    password.text = '';
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: DropdownButton<String>(
                    value: _selectedLanguage,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLanguage = newValue!;
                      });
                    },
                    icon: Icon(Icons.language, color: Colors.white),
                    dropdownColor: Colors.grey[800],
                    items: _languages
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                logoWidget("images/logo.png"),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: TextField(
                    controller: email,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 254, 252, 252)),
                    decoration: const InputDecoration(
                      labelText: "Email",
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
                    controller: password,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 254, 252, 252)),
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
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
                  child: SizedBox(
                    child: CupertinoButton.filled(
                      child: const FittedBox(
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 20),
                        ),
                      ),
                      onPressed: () {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: email.text.trim(),
                          password: password.text.trim(),
                        )
                            .then((value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const EmailVerificationPage(),
                            ),
                          );
                        }).onError((error, stackTrace) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            text: 'Check all the details again!',
                          );
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextButton(
                    child: const Text(
                      "Forget Password",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Dubai",
                          fontSize: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgetPass(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: TextButton(
                    child: const Text(
                      "New User? Sign Up now!",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Dubai",
                          fontSize: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpDriver(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: SignInButton(
                    Buttons.Google,
                    text: "Sign in with Google",
                    onPressed: () async {
                      await GoogleAuth().handleSignIn();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const EmailVerificationPage(),
                      ));
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
