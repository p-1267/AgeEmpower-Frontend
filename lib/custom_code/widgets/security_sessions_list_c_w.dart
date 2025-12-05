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

// Automatic FF imports
import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';
// DO NOT REMOVE ABOVE

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SecuritySessionsListCW extends StatefulWidget {
  final double? width;
  final double? height;

  const SecuritySessionsListCW({
    super.key,
    this.width,
    this.height,
  });

  @override
  State<SecuritySessionsListCW> createState() => _SecuritySessionsListCWState();
}

class _SecuritySessionsListCWState extends State<SecuritySessionsListCW> {
  String? uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      return const Center(child: Text("Not signed in"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("sessions")
          .orderBy("lastActive", descending: true)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return const CircularProgressIndicator();

        final docs = snap.data!.docs;

        return Container(
          width: widget.width ?? double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Active Sessions",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (docs.isEmpty) const Text("No active sessions."),
              for (var d in docs)
                _sessionCard(d.id, d.data() as Map<String, dynamic>),
            ],
          ),
        );
      },
    );
  }

  Widget _sessionCard(String sessionId, Map<String, dynamic> data) {
    final device = data["device"] ?? "Unknown Device";
    final location = data["location"] ?? "Unknown Location";
    final lastActive = (data["lastActive"] as Timestamp?)?.toDate();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blue.shade200),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.devices, size: 32, color: Colors.blue),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(location),
                if (lastActive != null)
                  Text(
                    "Last active: ${lastActive.toLocal()}",
                    style: const TextStyle(color: Colors.black54),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _logoutSession(sessionId),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  Future<void> _logoutSession(String sessionId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("sessions")
        .doc(sessionId)
        .delete();
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
