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

import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsPreviewCW extends StatelessWidget {
  final String? userId;

  const NotificationsPreviewCW({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("notifications")
          .where("toUser", isEqualTo: userId)
          .orderBy("timestamp", descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return const SizedBox();

        final docs = snap.data!.docs;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Recent Notifications",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              for (var d in docs) _item(d.data()),
            ],
          ),
        );
      },
    );
  }

  Widget _item(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        data["type"] ?? "Notification",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
