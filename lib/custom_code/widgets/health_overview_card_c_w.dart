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

class HealthOverviewCardCW extends StatelessWidget {
  final String? userId;

  const HealthOverviewCardCW({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blue.shade200),
        boxShadow: const [
          BoxShadow(
              color: Color(0x22000000), blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("health")
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) return const CircularProgressIndicator();

          final health =
              snap.data!.docs.isEmpty ? {} : snap.data!.docs.first.data();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Health Overview",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              _metric("Heart Rate", "${health["heartRate"] ?? "--"} bpm",
                  Icons.favorite),
              _metric("Steps", "${health["steps"] ?? "--"} steps",
                  Icons.directions_walk),
              _metric(
                  "Sleep", "${health["sleepHours"] ?? "--"} hrs", Icons.bed),
            ],
          );
        },
      ),
    );
  }

  Widget _metric(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade700),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
