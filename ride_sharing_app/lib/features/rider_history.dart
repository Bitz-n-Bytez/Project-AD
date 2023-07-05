import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RiderReviewPage extends StatefulWidget {
  final String riderId;

  const RiderReviewPage({required this.riderId});

  @override
  _RiderReviewPageState createState() => _RiderReviewPageState();
}

class _RiderReviewPageState extends State<RiderReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rider Reviews'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('riderReviews')
            .where('riderId', isEqualTo: widget.riderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data?.size == 0) {
            return Center(child: Text('No reviews found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data?.size,
            itemBuilder: (context, index) {
              final review = snapshot.data!.docs[index];
              final comment = review['review'];

              return ListTile(
                title: Text('Review: $comment'),
              );
            },
          );
        },
      ),
    );
  }
}
