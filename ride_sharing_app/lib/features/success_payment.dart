import 'package:flutter/material.dart';
import 'package:ride_sharing_app/screens/customer_home.dart';

class PaymentSuccessPage extends StatelessWidget {
  final double farePrice;
  final String requestId;
  final String paymentMethod;

  PaymentSuccessPage({
    required this.farePrice,
    required this.requestId,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Success'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
            SizedBox(height: 16),
            Text(
              'Payment Successful',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Payment Details:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text('Amount: RM ${farePrice.toStringAsFixed(2)}'),
            Text('Payment Method: $paymentMethod'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Perform any additional actions or navigate to another page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CustomerHomePage()));
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
