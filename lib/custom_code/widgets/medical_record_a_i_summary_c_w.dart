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

class MedicalRecordAISummaryCW extends StatefulWidget {
  final DocumentReference recordRef;
  final String fileUrl;
  const MedicalRecordAISummaryCW({
    super.key,
    required this.recordRef,
    required this.fileUrl,
  });

  @override
  State<MedicalRecordAISummaryCW> createState() =>
      _MedicalRecordAISummaryCWState();
}

class _MedicalRecordAISummaryCWState extends State<MedicalRecordAISummaryCW> {
  bool loading = false;
  String summary = "";

  final AI_URL = "https://YOUR_BACKEND_DOMAIN/api/ai/record-summary";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.smart_toy),
          label: const Text("AI Read & Summarize"),
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

    final resp = await http.post(
      Uri.parse(AI_URL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "fileUrl": widget.fileUrl,
        "userId": uid,
      }),
    );

    final j = jsonDecode(resp.body);
    summary = j["summary"] ?? "";

    await widget.recordRef.collection("aiSummary").add({
      "summary": summary,
      "createdAt": FieldValue.serverTimestamp(),
    });

    setState(() => loading = false);
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
