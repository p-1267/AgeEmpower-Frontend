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

class SecurityDataExportCW extends StatelessWidget {
  final double? width;
  final double? height;

  const SecurityDataExportCW({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text("Data Export & Deletion",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _export(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text("Request Data Export"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _delete(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text("Delete Account"),
          ),
        ],
      ),
    );
  }

  Future<void> _export(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("dataExportRequests")
        .add({"uid": uid, "timestamp": FieldValue.serverTimestamp()});

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Export requested")));
  }

  Future<void> _delete(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("deleteRequests")
        .add({"uid": uid, "timestamp": FieldValue.serverTimestamp()});

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Deletion requested")));
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
