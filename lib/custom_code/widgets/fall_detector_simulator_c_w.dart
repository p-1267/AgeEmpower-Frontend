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

class FallDetectorSimulatorCW extends StatelessWidget {
  final double? width;
  final double? height;

  const FallDetectorSimulatorCW({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  Future<void> _simulateFall() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("emergencies")
        .add({
      "type": "fall",
      "message": "Fall detected",
      "severity": "critical",
      "createdAt": FieldValue.serverTimestamp(),
      "status": "open",
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _simulateFall,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
      ),
      child: const Text("Simulate Fall Detection"),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
