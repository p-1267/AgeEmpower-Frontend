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

class BillingHistoryCW extends StatelessWidget {
  final double? width;
  final double? height;

  const BillingHistoryCW({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Center(child: Text("Not signed in"));

    final stream = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("billing")
        .orderBy("timestamp", descending: true)
        .snapshots();

    return StreamBuilder(
      stream: stream,
      builder: (context, snap) {
        if (!snap.hasData) return const CircularProgressIndicator();

        final docs = snap.data!.docs;

        return ListView(
          padding: const EdgeInsets.all(20),
          children: docs.map((d) => _card(d.data())).toList(),
        );
      },
    );
  }

  Widget _card(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Invoice: ${data['invoiceId']}",
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text("Amount: \$${data['amount']}"),
          Text("Status: ${data['status']}"),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
