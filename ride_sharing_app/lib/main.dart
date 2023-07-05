import 'package:firebase_core/firebase_core.dart';
import 'package:ride_sharing_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/gender.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTM Go',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('es', ''), // Spanish
        Locale('fr', ''), // French
        Locale('de', ''), // German
        Locale('it', ''), // Italian
        Locale('ja', ''), // Japanese
        Locale('ko', ''), // Korean
      ],
      locale: _getLocale(),
      home: const Login(),
    );
  }
}

// Locale _getLocale() {
//   switch (_selectedLanguage) {
//     case 'English':
//       return const Locale('en', '');
//     case 'Spanish':
//       return const Locale('es', '');
//     case 'French':
//       return const Locale('fr', '');
//     case 'German':
//       return const Locale('de', '');
//     case 'Italian':
//       return const Locale('it', '');
//     case 'Japanese':
//       return const Locale('ja', '');
//     case 'Korean':
//       return const Locale('ko', '');
//     default:
//       return const Locale('en', '');
//   }
// }
