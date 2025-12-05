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

import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';
// DO NOT REMOVE ABOVE

// Additional imports
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// ---------------------------------------------------------------------------
/// CHAT THREAD (Full Modern Chat UI)
/// ---------------------------------------------------------------------------
/// Firestore structure:
///   /conversations/{conversationId}
///   /conversations/{conversationId}/messages/{msgId}
///
/// Features:
///   - Beautiful message bubbles
///   - Group + individual chats
///   - Auto-scroll
///   - AI reply surface integration
///   - Typing indicator placeholder
///   - Readable senior-friendly layout
/// ---------------------------------------------------------------------------

class ChatThreadCW extends StatefulWidget {
  final String conversationId;
  final double? width;
  final double? height;

  /// Optional: container for AI replies
  final Widget? aiSuggestions;

  const ChatThreadCW({
    super.key,
    required this.conversationId,
    this.width,
    this.height,
    this.aiSuggestions,
  });

  @override
  State<ChatThreadCW> createState() => _ChatThreadCWState();
}

class _ChatThreadCWState extends State<ChatThreadCW> {
  String? uid;
  final ScrollController _scroll = ScrollController();
  final TextEditingController _textCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
  }

  // ---------------------------------------------------------------------------
  // Send message
  // ---------------------------------------------------------------------------
  Future<void> _sendMessage() async {
    if (_textCtrl.text.trim().isEmpty || uid == null) return;

    final msgText = _textCtrl.text.trim();
    _textCtrl.clear();

    final msgRef = FirebaseFirestore.instance
        .collection("conversations")
        .doc(widget.conversationId)
        .collection("messages")
        .doc();

    await msgRef.set({
      "messageId": msgRef.id,
      "senderId": uid,
      "text": msgText,
      "timestamp": FieldValue.serverTimestamp(),
    });

    // Update last message in conversation root
    await FirebaseFirestore.instance
        .collection("conversations")
        .doc(widget.conversationId)
        .update({
      "lastMessage": msgText,
      "lastTimestamp": FieldValue.serverTimestamp(),
      "lastSenderId": uid,
    });

    // Auto scroll
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Build UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Expanded(child: _buildMessageList()),
          if (widget.aiSuggestions != null) widget.aiSuggestions!,
          _buildInputBar(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Message List
  // ---------------------------------------------------------------------------
  Widget _buildMessageList() {
    final msgStream = FirebaseFirestore.instance
        .collection("conversations")
        .doc(widget.conversationId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: msgStream,
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snap.data!.docs;

        // Auto-scroll when new messages appear
        Future.delayed(const Duration(milliseconds: 200), () {
          if (_scroll.hasClients) {
            _scroll.jumpTo(_scroll.position.maxScrollExtent);
          }
        });

        return ListView.builder(
          controller: _scroll,
          padding: const EdgeInsets.all(14),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            final bool mine = data["senderId"] == uid;
            return _buildMessageBubble(data, mine);
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Message Bubble UI (AgeEmpower Style)
  // ---------------------------------------------------------------------------
  Widget _buildMessageBubble(Map<String, dynamic> msg, bool mine) {
    final text = msg["text"] ?? "";
    final ts = msg["timestamp"] as Timestamp?;
    final time = ts != null
        ? "${ts.toDate().hour.toString().padLeft(2, '0')}:${ts.toDate().minute.toString().padLeft(2, '0')}"
        : "";

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: mine ? Colors.blue.shade700 : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
          border: Border.all(
            color: mine ? Colors.blue.shade900 : Colors.grey.shade300,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: mine ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: mine ? Colors.white70 : Colors.black45,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Input Bar (Text field + send button)
  // ---------------------------------------------------------------------------
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textCtrl,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                hintText: "Type a message…",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // SEND button
          GestureDetector(
            onTap: _sendMessage,
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue.shade700,
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
