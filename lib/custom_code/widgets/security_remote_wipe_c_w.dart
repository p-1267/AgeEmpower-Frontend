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

class SecurityRemoteWipeCW extends StatelessWidget {
  final double? width;
  final double? height;

  const SecurityRemoteWipeCW({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text("Remote Device Wipe",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text(
            "This will remotely wipe your data from selected device(s). "
            "Use only if you lost your phone or suspect unauthorized access.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _triggerWipe(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text(
              "Wipe Device",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _triggerWipe(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({"remoteWipeRequested": true});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Remote wipe initiated")),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
