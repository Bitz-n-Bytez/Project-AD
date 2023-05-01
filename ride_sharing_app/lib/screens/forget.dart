// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:quickalert/quickalert.dart';

// class ForgetPass extends StatefulWidget {
//   const ForgetPass({super.key});

//   @override
//   State<ForgetPass> createState() => _ForgetPassState();
// }

// class _ForgetPassState extends State<ForgetPass> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   TextEditingController username = TextEditingController();
//   TextEditingController password = TextEditingController();
//   TextEditingController confirmPassword = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     username.text = ""; //innitail value of text field
//     password.text = "";
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//             decoration: const BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage("images/bg.jpg"),
//                     opacity: 0.1,
//                     fit: BoxFit.cover),
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomCenter,
//                   colors: <Color>[
//                     Color.fromARGB(255, 4, 4, 4),
//                     Color.fromARGB(255, 75, 74, 74),
//                     Color.fromARGB(255, 167, 167, 165),
//                   ], // Gradient from https://learnui.design/tools/gradient-generator.html
//                   tileMode: TileMode.mirror,
//                 )),
//             child: Center(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: <Widget>[
//                     logoWidget("images/logo.png"),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 5),
//                       child: TextField(
//                           controller: username,
//                           style: const TextStyle(
//                               color: Color.fromARGB(255, 254, 252, 252)),
//                           decoration: const InputDecoration(
//                             labelText: "Enter Your Email",
//                             icon: Icon(
//                               Icons.email,
//                               color: Colors.white,
//                             ), //icon at head of input
//                           )),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 35),
//                       child: SizedBox(
//                           child: CupertinoButton.filled(
//                               child: const FittedBox(
//                                 child: Text(
//                                   'Get Reset Link',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w400,
//                                       fontSize: 20),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 QuickAlert.show(
//                                   context: context,
//                                   type: QuickAlertType.success,
//                                   text: 'Link Sent Successfully!',
//                                 );
//                               })),
//                     ),
//                   ],
//                 ),
//               ),
//             )));
//   }
// }

// Image logoWidget(String imageName) {
//   return Image.asset(
//     imageName,
//     fit: BoxFit.fitWidth,
//     width: 200,
//     height: 200,
//   );
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();

  String _email = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Reset user's password
  Future<void> resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _email);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Password Reset Email Sent'),
          content: Text('Please check your email to reset your password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Password Reset Error'),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _email.isEmpty
                  ? null
                  : () {
                      resetPassword();
                    },
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
