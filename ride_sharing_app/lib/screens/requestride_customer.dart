import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ride_sharing_app/screens/car_pool.dart';
import 'package:ride_sharing_app/screens/solo_ride.dart';

class RequestRide extends StatefulWidget {
  const RequestRide({super.key});

  @override
  State<RequestRide> createState() => _RequestRideState();
}

class _RequestRideState extends State<RequestRide> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _locationController.text = "";
    _destinationController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color.fromARGB(255, 78, 95, 45),
                Color.fromARGB(255, 92, 99, 68),
                Color.fromARGB(255, 131, 136, 119),
              ], // Gradient from https://learnui.design/tools/gradient-generator.html
              tileMode: TileMode.mirror,
            )),
            child: Center(
                child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  logoWidget("images/logo.png"),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextField(
                        style: TextStyle(color: Colors.black),
                        controller: _locationController,
                        decoration: const InputDecoration(
                            labelText: "Enter Your Location",
                            labelStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                            ),
                            icon: Icon(
                              Icons.location_history,
                              color: Color.fromARGB(255, 3, 3, 3),
                            ))),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextField(
                        style: TextStyle(color: Colors.black),
                        controller: _destinationController,
                        decoration: const InputDecoration(
                            labelText: "Enter Your Destination Location",
                            labelStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                            ),
                            icon: Icon(
                              Icons.location_city,
                              color: Color.fromARGB(255, 3, 3, 3),
                            ))),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SoloRide()));
                    },
                    color: const Color.fromARGB(255, 179, 236, 209),
                    child: const Text('Request',
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                  ),
                  MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CarPool()));
                      },
                      color: const Color.fromARGB(255, 179, 236, 209),
                      child: const Text('Pool',
                          style:
                              TextStyle(color: Color.fromARGB(255, 0, 0, 0)))),
                ],
              ),
            ))));
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
