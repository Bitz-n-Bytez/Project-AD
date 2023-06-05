import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  final String? senderId;
  final String? receiverId;

  ChatPage({required this.senderId, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('senderId', isEqualTo: widget.senderId)
                  .where('receiverId', isEqualTo: widget.receiverId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return ListView(
                  reverse: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> message =
                        document.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(message['message']),
                      subtitle: Text(message['timestamp']),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: "Write a message...",
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _sendMessage();
                  },
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      FirebaseFirestore.instance.collection('chats').add({
        'senderId': widget.senderId,
        'receiverId': widget.receiverId,
        'message': messageText,
        'timestamp': DateTime.now().toString(),
      });

      FirebaseFirestore.instance.collection('chats').add({
        'senderId': widget.receiverId,
        'receiverId': widget.senderId,
        'message': messageText,
        'timestamp': DateTime.now().toString(),
      });

      _messageController.clear();
    }
  }
}
