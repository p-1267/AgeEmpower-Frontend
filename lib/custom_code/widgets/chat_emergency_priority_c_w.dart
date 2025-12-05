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

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatEmergencyPriorityCW extends StatefulWidget {
  const ChatEmergencyPriorityCW({
    super.key,
    required this.messageText,
    required this.chatPartnerId,
  });

  /// Text of the incoming or outgoing message
  final String messageText;

  /// The UID of the person you're chatting with
  final String chatPartnerId;

  @override
  State<ChatEmergencyPriorityCW> createState() =>
      _ChatEmergencyPriorityCWState();
}

class _ChatEmergencyPriorityCWState extends State<ChatEmergencyPriorityCW> {
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    _processMessage();
  }

  // ------------------------------------------------------------------
  // Emergency keywords
  // ------------------------------------------------------------------
  static const emergencyWords = [
    "help",
    "emergency",
    "911",
    "please help",
    "fell",
    "falling",
    "i fell",
    "cant breathe",
    "can't breathe",
    "bleeding",
    "lost",
    "pain",
    "hurt",
    "broken",
  ];

  // ------------------------------------------------------------------
  // MAIN LOGIC: Detect emergency inside chat message
  // ------------------------------------------------------------------
  Future<void> _processMessage() async {
    final msg = widget.messageText.toLowerCase().trim();

    final bool containsEmergencyKeyword = emergencyWords.any(
      (w) => msg.contains(w),
    );

    if (!containsEmergencyKeyword) return;

    // Step 2: AI classification (stub)
    final aiResult = _stubAIClassification(msg);

    if (aiResult == "not_emergency") {
      return;
    }

    // Step 3: Trigger emergency
    await _generateEmergency(aiResult);
  }

  // ------------------------------------------------------------------
  // STUB AI CLASSIFIER
  // ------------------------------------------------------------------
  String _stubAIClassification(String msg) {
    if (msg.contains("help") ||
        msg.contains("fell") ||
        msg.contains("can't breathe") ||
        msg.contains("pain")) {
      return "likely_emergency";
    }

    if (msg.contains("maybe") || msg.contains("not sure")) {
      return "uncertain";
    }

    return "not_emergency";
  }

  // ------------------------------------------------------------------
  // CREATE EMERGENCY EVENT IN FIRESTORE
  // ------------------------------------------------------------------
  Future<void> _generateEmergency(String severity) async {
    if (userId == null) return;

    final id = FirebaseFirestore.instance.collection("emergencies").doc().id;

    await FirebaseFirestore.instance.collection("emergencies").doc(id).set({
      "eventId": id,
      "userId": userId,
      "triggeredBy": "chat",
      "severity": severity,
      "message": widget.messageText,
      "timestamp": FieldValue.serverTimestamp(),
      "type": "chat_detected",
      "resolved": false,
    });

    // Step 4: Notify caregivers
    await _notifyCareNetwork(id);
  }

  // ------------------------------------------------------------------
  // NOTIFY CARE NETWORK
  // ------------------------------------------------------------------
  Future<void> _notifyCareNetwork(String eventId) async {
    final userSnap =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();

    final data = userSnap.data();
    if (data == null) return;

    final caregivers = (data["caregivers"] ?? []) as List;
    final family = (data["family"] ?? []) as List;
    final agency = data["agency"];

    final allRecipients = [
      ...caregivers,
      ...family,
      if (agency != null) agency,
    ];

    for (var uid in allRecipients) {
      await FirebaseFirestore.instance.collection("notifications").add({
        "toUser": uid,
        "eventId": eventId,
        "type": "chat_emergency",
        "timestamp": FieldValue.serverTimestamp(),
      });
    }
  }

  // ------------------------------------------------------------------
  // UI (Small indicator shown in chat bubble)
  // ------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final msg = widget.messageText.toLowerCase();

    final bool emergency = emergencyWords.any((w) => msg.contains(w));

    if (!emergency) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        children: const [
          Icon(Icons.warning_rounded, color: Colors.red, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "Emergency keywords detected — alert sent!",
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
