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

// Automatic FF imports…
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportGeneratorCW extends StatefulWidget {
  final double? width;
  final double? height;

  const ReportGeneratorCW({super.key, this.width, this.height});

  @override
  State<ReportGeneratorCW> createState() => _ReportGeneratorCWState();
}

class _ReportGeneratorCWState extends State<ReportGeneratorCW> {
  bool loading = false;

  Future<void> _generate() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => loading = true);

    final id = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("reports")
        .doc()
        .id;

    /// In production, this is where you'd run:
    /// AI agent → summarize → vitals → medication → risk → compile → save.

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("reports")
        .doc(id)
        .set({
      "reportId": id,
      "type": "AI Health Summary",
      "summary":
          "Your overall health indicators remain stable. No urgent concerns detected. Activity levels and vitals appear consistent.",
      "timestamp": FieldValue.serverTimestamp(),
    });

    setState(() => loading = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Report generated")));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: loading ? null : _generate,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          backgroundColor: Colors.blue.shade700,
        ),
        child: loading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Generate New Report",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
