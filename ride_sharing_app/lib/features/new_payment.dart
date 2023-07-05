// import 'package:firebase_auth/firebase_auth.dart';
// // ignore: depend_on_referenced_packages
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:sunflower/models/cart_model.dart';
// import 'package:sunflower/models/product_model.dart';
// import 'package:sunflower/models/user_model.dart';
// import 'package:sunflower/repo/orders.dart';
// import 'package:sunflower/repo/users.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'cart.dart';
// import '../repo/usercart.dart';

// class Checkout extends StatefulWidget {
//   const Checkout({Key? key}) : super(key: key);

//   @override
//   State<Checkout> createState() => _CheckoutState();
// }

// class _CheckoutState extends State<Checkout> {
//   var currentUser = FirebaseAuth.instance.currentUser;
//   UserModel? user;
//   Razorpay _razorpay = Razorpay();
//   List<ProductModel>? products;
//   List<CartModel>? tobuy;

//   void refresh() {
//     setState(() {});
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _initRetrieval();
//   }

//   Future<void> _initRetrieval() async {
//     user = await getUserDetails();

//     // Get Shop and Product details for purchasing products
//     // ignore: use_build_context_synchronously
//     var arg = ModalRoute.of(context)!.settings.arguments as dynamic;
//     tobuy = arg['tobuy'];

//     // Get Product Details
//     products = await productsInCart(tobuy!);
//     setState(() {}); // Notify the widget to rebuild after initializing plist

//     // Razorpay codes
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _razorpay.clear();
//   }

//   // Callback function when payment is successful
//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     String? paymentId = response.paymentId;

//     // Create new Order
//     setState(() {
//       createOrder(
//         payID: paymentId,
//         items: tobuy,
//         total: calculateTotal().toStringAsFixed(2),
//       );
//       for (int i = 0; i < tobuy!.length; i++) {
//         deleteItems(tobuy![i].id);
//       }
//     });

//     // Navigate to cart while refreshing database
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (BuildContext context) => const CartPage()),
//     );

//     // Display success message
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//       content: Text('Order created!'),
//     ));
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//       content: Text('Oops! Something went wrong during the payment process.'),
//     ));
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//       content: Text('There is an external wallet error!'),
//     ));
//   }

//   // Calculate total price
//   double calculateTotal() {
//     double total = 0;
//     if (products != null && tobuy != null) {
//       for (int i = 0; i < products!.length; i++) {
//         total += double.parse(products![i].pprice) * tobuy![i].qtty;
//       }
//     }
//     return total;
//   }

//   @override
//   Widget build(BuildContext context) {
//     var arg = ModalRoute.of(context)!.settings.arguments as dynamic;
//     List<CartModel> tobuy = arg['tobuy'];
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         backgroundColor: const Color(0xFFb38795),
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.of(context, rootNavigator: true).pushNamed("/cart");
//           }, // Make new function and call it here
//           child: const Icon(
//             Icons.close,
//           ),
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
//             child: Text(
//                 'Address: \n\n${user?.name} | ${user?.phone}\n${user?.address}\n'),
//           ),
//           const Divider(
//             color: Colors.black,
//           ),
//           const Padding(
//             padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//             child: Text(
//               'Items',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           const Divider(
//             color: Colors.black,
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: products?.length ?? 0,
//               itemBuilder: (context, index) {
//                 return FutureBuilder<String>(
//                   future: printUrl(index),
//                   builder: (BuildContext context,
//                       AsyncSnapshot<String> urlSnapshot) {
//                     if (urlSnapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     } else if (urlSnapshot.hasData &&
//                         urlSnapshot.data != null) {
//                       return SizedBox(
//                         height: 150,
//                         child: Row(
//                           children: <Widget>[
//                             Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: GestureDetector(
//                                 onTap: () {},
//                                 child: Container(
//                                   width: 100.0,
//                                   height: 100.0,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     image: DecorationImage(
//                                       image: NetworkImage(urlSnapshot.data!),
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     '\n${products![index].pname}\nRM ${products![index].pprice}',
//                                     style: const TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 17.0,
//                                     ),
//                                     textAlign: TextAlign.left,
//                                   ),
//                                   const SizedBox(height: 8.0),
//                                   Text(
//                                     'Quantity : ${tobuy[index].qtty}',
//                                     style: const TextStyle(
//                                       fontSize: 17.0,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     } else {
//                       return const Center(
//                         child: Text('Loading ...'),
//                       );
//                     }
//                   },
//                 );
//               },
//             ),
//           ),
//           Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Total Payment: RM ${(calculateTotal()).toStringAsFixed(2)}',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 17.0,
//                       ),
//                     ),
//                     const SizedBox(width: 85.0),
//                     ElevatedButton(
//                       onPressed: () {
//                         _openRazorpayPayment();
//                       },
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all<Color>(
//                           const Color(0xFFb38795),
//                         ),
//                       ),
//                       child: const Text(
//                         'Pay',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 17.0,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   void _openRazorpayPayment() {
//     final options = {
//       'key': 'rzp_test_L16rikP7q8KIjW',
//       'amount': ((calculateTotal()) * 100).toInt(),
//       'currency': 'MYR',
//       'name': 'MyShopper',
//       'description': 'Payment for products',
//       'prefill': {
//         'contact': user?.phone,
//         'name': user?.name,
//         'email': currentUser?.email ?? ''
//       },
//       'external': {
//         'wallets': ['paytm'] // Optional, to enable wallets like Paytm
//       }
//     };

//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('Error: ${e.toString()}');
//     }
//   }

//   Future<String> printUrl(int index) async {
//     final ref = FirebaseStorage.instance.ref().child(products![index].pimage);
//     String url = await ref.getDownloadURL();
//     return url;
//   }
// }
