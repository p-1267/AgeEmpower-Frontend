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
import 'package:firebase_auth/firebase_auth.dart';

class SecurityActivityLogCW extends StatelessWidget {
  final double? width;
  final double? height;

  const SecurityActivityLogCW({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Center(child: Text("Not signed in"));
    }

    final stream = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("activityLog")
        .orderBy("timestamp", descending: true)
        .snapshots();

    return StreamBuilder(
      stream: stream,
      builder: (context, snap) {
        if (!snap.hasData) return const CircularProgressIndicator();

        final logs = snap.data!.docs;

        return Container(
          width: width,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text("Activity Log",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              if (logs.isEmpty) const Text("No activity recorded."),
              for (var d in logs) _entry(d.data() as Map<String, dynamic>),
            ],
          ),
        );
      },
    );
  }

  Widget _entry(Map<String, dynamic> log) {
    final type = log["type"] ?? "unknown";
    final desc = log["description"] ?? "";
    final ts = (log["timestamp"] as Timestamp?)?.toDate();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(Icons.security, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type.toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(desc),
                if (ts != null)
                  Text(
                    ts.toLocal().toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
