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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationHistoryListCW extends StatelessWidget {
  final double? width;
  final double? height;

  const NotificationHistoryListCW({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Center(child: Text("Not logged in"));
    }

    final stream = FirebaseFirestore.instance
        .collection("notifications")
        .where("toUser", isEqualTo: uid)
        .orderBy("timestamp", descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snap.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text("No notifications"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (c, i) {
            final d = docs[i].data() as Map<String, dynamic>? ?? {};
            return _buildCard(d);
          },
        );
      },
    );
  }

  Widget _buildCard(Map<String, dynamic> d) {
    final type = d["type"] ?? "general";
    final ts = d["timestamp"] as Timestamp?;
    final time = ts != null ? ts.toDate().toString() : "Unknown time";

    IconData icon;
    Color color;

    switch (type) {
      case "emergency":
        icon = Icons.warning_rounded;
        color = Colors.red;
        break;
      case "chat_emergency":
        icon = Icons.chat_bubble_outline;
        color = Colors.orange;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$type\n$time",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
