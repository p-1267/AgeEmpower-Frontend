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
// DO NOT REMOVE ABOVE

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicationDashboardSummaryCW extends StatelessWidget {
  final double? width;
  final double? height;

  const MedicationDashboardSummaryCW({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return const Text("Sign in required.");

    final medsRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("medications");

    return StreamBuilder<QuerySnapshot>(
      stream: medsRef.snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snap.data!.docs;
        int total = docs.length;
        int active = docs.where((d) => d["active"] == true).length;
        int low = docs
            .where((d) => (d["remaining"] ?? 0) <= (d["lowThreshold"] ?? 5))
            .length;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x11000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _pill("Total", total.toString(), Colors.blue),
              _pill("Active", active.toString(), Colors.green),
              _pill("Low", low.toString(), Colors.red),
            ],
          ),
        );
      },
    );
  }

  Widget _pill(String label, String value, Color color) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14, color: color, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
