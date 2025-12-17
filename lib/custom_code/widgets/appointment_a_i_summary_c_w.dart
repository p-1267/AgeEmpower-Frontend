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
import 'dart:convert';
import 'package:http/http.dart' as http;

class AppointmentAISummaryCW extends StatefulWidget {
  final DocumentReference apptRef;
  const AppointmentAISummaryCW({super.key, required this.apptRef});

  @override
  State<AppointmentAISummaryCW> createState() => _AppointmentAISummaryCWState();
}

class _AppointmentAISummaryCWState extends State<AppointmentAISummaryCW> {
  bool loading = false;
  String summary = "";

  final String AI_URL =
      "https://YOUR_BACKEND_DOMAIN/api/ai/appointment-summary";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.smart_toy),
          label: const Text("Generate AI Visit Summary"),
          onPressed: loading ? null : _run,
        ),
        if (loading) const CircularProgressIndicator(),
        if (summary.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(summary),
          ),
      ],
    );
  }

  Future<void> _run() async {
    setState(() => loading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final medsSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("medications")
        .get();
    final vitalsSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("vitals")
        .get();
    final sideSnap = await FirebaseFirestore.instance
        .collection("users")
        .collectionGroup("sideEffects")
        .get();

    final data = {
      "medications": medsSnap.docs.map((d) => d.data()).toList(),
      "vitals": vitalsSnap.docs.map((d) => d.data()).toList(),
      "sideEffects": sideSnap.docs.map((d) => d.data()).toList(),
    };

    final resp = await http.post(
      Uri.parse(AI_URL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    final j = jsonDecode(resp.body);

    summary = j["summary"] ?? "";
    await widget.apptRef.collection("aiSummary").add({
      "summary": summary,
      "createdAt": FieldValue.serverTimestamp(),
    });

    setState(() => loading = false);
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
