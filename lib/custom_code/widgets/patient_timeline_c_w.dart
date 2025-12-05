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

class PatientTimelineCW extends StatelessWidget {
  final double? width;
  final double? height;

  const PatientTimelineCW({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Text("Sign in required");

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("alerts")
          .orderBy("createdAt", descending: true)
          .limit(50)
          .snapshots(),
      builder: (c, snap) {
        if (!snap.hasData) return const CircularProgressIndicator();
        final docs = snap.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (c, i) {
            final d = docs[i].data() as Map<String, dynamic>;
            return ListTile(
              leading: const Icon(Icons.timeline),
              title: Text(d["message"] ?? ""),
              subtitle: Text(
                  (d["createdAt"] as Timestamp?)?.toDate().toString() ?? ""),
            );
          },
        );
      },
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
