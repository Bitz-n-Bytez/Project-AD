import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DriverOffer extends StatefulWidget {
  const DriverOffer({super.key});

  @override
  State<DriverOffer> createState() => _DriverOfferState();
}

class _DriverOfferState extends State<DriverOffer> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  @override
  void initState() {
    _locationController.text = "";
    _destinationController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                  labelText: "Enter Your Location",
                  icon: Icon(
                    Icons.location_city_outlined,
                    color: Color.fromARGB(255, 3, 3, 3),
                  )))
        ],
      ),
    ));
  }
}
