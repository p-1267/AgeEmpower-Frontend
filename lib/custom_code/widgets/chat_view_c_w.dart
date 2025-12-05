// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// FF imports
// DO NOT REMOVE ABOVE

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatViewCW extends StatefulWidget {
  final String peerUid;
  final double? width;
  final double? height;

  const ChatViewCW({
    super.key,
    required this.peerUid,
    this.width,
    this.height,
  });

  @override
  State<ChatViewCW> createState() => _ChatViewCWState();
}

class _ChatViewCWState extends State<ChatViewCW> {
  final TextEditingController _msgCtrl = TextEditingController();
  String? chatId;

  @override
  void initState() {
    super.initState();
    _loadChat();
  }

  Future<void> _loadChat() async {
    final me = FirebaseAuth.instance.currentUser!.uid;

    final snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(me)
        .collection("chats")
        .where("participants", arrayContains: widget.peerUid)
        .get();

    if (snap.docs.isEmpty) {
      // Create chat for both users
      final newChat = {
        "participants": [me, widget.peerUid],
        "lastMessage": "",
        "lastTimestamp": FieldValue.serverTimestamp(),
      };

      final ref1 = await FirebaseFirestore.instance
          .collection("users")
          .doc(me)
          .collection("chats")
          .add(newChat);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.peerUid)
          .collection("chats")
          .doc(ref1.id)
          .set(newChat);

      setState(() => chatId = ref1.id);
    } else {
      setState(() => chatId = snap.docs.first.id);
    }
  }

  Future<void> _sendMessage() async {
    if (_msgCtrl.text.trim().isEmpty || chatId == null) return;

    final me = FirebaseAuth.instance.currentUser!.uid;
    final txt = _msgCtrl.text.trim();

    final msg = {
      "senderId": me,
      "text": txt,
      "type": "text",
      "timestamp": FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection("users")
        .doc(me)
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add(msg);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.peerUid)
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add(msg);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(me)
        .collection("chats")
        .doc(chatId)
        .update({
      "lastMessage": txt,
      "lastTimestamp": FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.peerUid)
        .collection("chats")
        .doc(chatId)
        .update({
      "lastMessage": txt,
      "lastTimestamp": FieldValue.serverTimestamp(),
    });

    _msgCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (chatId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final me = FirebaseAuth.instance.currentUser!.uid;

    final msgStream = FirebaseFirestore.instance
        .collection("users")
        .doc(me)
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp")
        .snapshots();

    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: msgStream,
            builder: (_, snap) {
              if (!snap.hasData) return const CircularProgressIndicator();

              final docs = snap.data!.docs;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: docs.map((d) {
                  final data = d.data() as Map<String, dynamic>;
                  final mine = data["senderId"] == me;

                  return Align(
                    alignment:
                        mine ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: mine ? Colors.blueAccent : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        data["text"] ?? "",
                        style: TextStyle(
                          color: mine ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),

        // Input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _msgCtrl,
                decoration:
                    const InputDecoration(hintText: "Type a message..."),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ],
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
