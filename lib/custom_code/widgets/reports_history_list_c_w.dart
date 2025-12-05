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

class ReportsHistoryListCW extends StatefulWidget {
  final double? width;
  final double? height;

  /// Called when user taps a report → parent can open preview
  final Function(String reportId, Map<String, dynamic> data)? onReportSelected;

  const ReportsHistoryListCW({
    super.key,
    this.width,
    this.height,
    this.onReportSelected,
  });

  @override
  State<ReportsHistoryListCW> createState() => _ReportsHistoryListCWState();
}

class _ReportsHistoryListCWState extends State<ReportsHistoryListCW> {
  String? uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    if (uid == null) return const Center(child: Text("Not signed in"));

    final stream = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("reports")
        .orderBy("timestamp", descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snap) {
        if (!snap.hasData)
          return const Center(child: CircularProgressIndicator());

        final docs = snap.data!.docs;

        return Container(
          width: widget.width,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Reports History",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (docs.isEmpty) const Text("No reports generated yet."),
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final id = docs[i].id;
                    final data = docs[i].data() as Map<String, dynamic>;
                    return _reportCard(id, data);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _reportCard(String id, Map<String, dynamic> data) {
    final type = data["type"] ?? "Unknown";
    final ts = (data["timestamp"] as Timestamp?)?.toDate();
    final summary = data["summary"] ?? "";

    return GestureDetector(
      onTap: () => widget.onReportSelected?.call(id, data),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.blue.shade200),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.description, size: 36, color: Colors.blue.shade700),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  if (ts != null)
                    Text(ts.toLocal().toString(),
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 6),
                  Text(
                    summary.length > 80
                        ? "${summary.substring(0, 80)}..."
                        : summary,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 28),
          ],
        ),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
