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
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

// DO NOT REMOVE ABOVE

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SideEffectLoggerCW extends StatefulWidget {
  final double? width;
  final double? height;
  final DocumentReference? medDocRef;

  const SideEffectLoggerCW({
    Key? key,
    this.width,
    this.height,
    required this.medDocRef,
  }) : super(key: key);

  @override
  State<SideEffectLoggerCW> createState() => _SideEffectLoggerCWState();
}

class _SideEffectLoggerCWState extends State<SideEffectLoggerCW> {
  final TextEditingController _textCtrl = TextEditingController();
  String severity = "mild";
  bool saving = false;

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || widget.medDocRef == null) return;

    if (_textCtrl.text.trim().isEmpty) return;

    setState(() => saving = true);

    try {
      await widget.medDocRef!.collection("sideEffects").add({
        "description": _textCtrl.text.trim(),
        "severity": severity,
        "timestamp": FieldValue.serverTimestamp(),
      });

      // Add alert for caregivers
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("alerts")
          .add({
        "type": "sideEffect",
        "severity": severity == "severe" ? "high" : "medium",
        "medId": widget.medDocRef!.id,
        "message":
            "Side effect reported: ${_textCtrl.text.trim()} (Severity: $severity)",
        "createdAt": FieldValue.serverTimestamp(),
        "status": "open",
      });

      _textCtrl.clear();
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ref = widget.medDocRef?.collection("sideEffects");

    return SizedBox(
      width: widget.width ?? double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Log Side Effects",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextField(
            controller: _textCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Describe the side effect...",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Severity: "),
              DropdownButton<String>(
                value: severity,
                items: const [
                  DropdownMenuItem(value: "mild", child: Text("Mild")),
                  DropdownMenuItem(value: "moderate", child: Text("Moderate")),
                  DropdownMenuItem(value: "severe", child: Text("Severe")),
                ],
                onChanged: (v) => setState(() => severity = v ?? "mild"),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: saving ? null : _save,
                child: saving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text("Save"),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text("Recent Side Effects",
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          StreamBuilder<QuerySnapshot>(
            stream: ref
                ?.orderBy("timestamp", descending: true)
                .limit(10)
                .snapshots(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snap.data!.docs;

              if (docs.isEmpty) {
                return const Text("No side effects logged.");
              }

              return Column(
                children: docs.map((d) {
                  final data = d.data() as Map<String, dynamic>? ?? {};
                  return ListTile(
                    title: Text(data["description"] ?? ""),
                    subtitle: Text("Severity: ${data["severity"]}"),
                    trailing: Text(
                      (data["timestamp"] as Timestamp?)
                              ?.toDate()
                              .toLocal()
                              .toString()
                              .split(".")
                              .first ??
                          "",
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
