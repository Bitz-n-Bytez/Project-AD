import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ride_sharing_app/screens/customer_home.dart';

class PaymentScreen extends StatefulWidget {
  final double farePrice;
  final String requestId;

  PaymentScreen({required this.farePrice, required this.requestId});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _openCheckout() {
    int amount = (widget.farePrice * 100).toInt(); // Converting to paise

    var options = {
      'key': 'rzp_test_0UWxMM7imvVbXB', // Replace with your Razorpay API key
      'amount': amount,
      'name': 'My Store',
      'description': 'Payment for your order',
      'prefill': {'contact': '', 'email': ''},
      'currency': 'MYR', // Set currency code according to your country
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CustomerHomePage(),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success here
    debugPrint('Payment Success. Payment ID: ${response.paymentId}');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure here
    debugPrint('Payment Error: ${response.code} - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet selection here
    debugPrint('External Wallet: ${response.walletName}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Gateway'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(140, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Amount: ${widget.farePrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _openCheckout,
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
