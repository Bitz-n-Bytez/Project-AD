import 'package:flutter/material.dart';

import 'success_payment.dart';

class PaymentPage extends StatefulWidget {
  final double farePrice;
  final String requestId;

  PaymentPage({required this.farePrice, required this.requestId});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedPaymentMethod = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Amount: RM ${widget.farePrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Select Payment Method:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            RadioListTile(
              title: Text('Touch \'n Go'),
              value: 'Touch \'n Go',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value.toString();
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedPaymentMethod.isNotEmpty) {
                  // Perform payment processing
                  processPayment();
                } else {
                  // Show an alert or message indicating no payment method is selected
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Payment Method'),
                        content: Text('Please select a payment method.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }

  void processPayment() {
    // Implement your payment processing logic here

    // Simulating a successful payment for demonstration purposes
    // You can replace this with your actual payment processing code

    // Start the payment processing
    showLoadingDialog();

    // Simulating a payment delay
    Future.delayed(Duration(seconds: 2), () {
      // Complete the payment
      completePayment();
    });
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Processing Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Please wait while we process your payment...'),
            ],
          ),
        );
      },
    );
  }

  void completePayment() {
    Navigator.pop(context); // Close the loading dialog

    // TODO: Implement actual payment completion code for Touch 'n Go
    // This is a placeholder code that needs to be replaced with your integration code

    // Simulating a successful payment completion
    bool paymentSuccess = true; // Replace with actual payment completion logic

    if (paymentSuccess) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Payment Successful'),
            content: Text('Your payment has been processed successfully.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  // Navigate to the payment success page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentSuccessPage(
                        farePrice: widget.farePrice,
                        requestId: widget.requestId,
                        paymentMethod: selectedPaymentMethod,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Payment Failed'),
            content: Text('Sorry, your payment could not be processed.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
