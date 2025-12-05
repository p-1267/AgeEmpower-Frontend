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

// AUTOMATIC FLUTTERFLOW IMPORTS — DO NOT REMOVE
import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

// CUSTOM IMPORTS
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlertsCenterCW extends StatefulWidget {
  final double? width;
  final double? height;

  const AlertsCenterCW({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<AlertsCenterCW> createState() => _AlertsCenterCWState();
}

class _AlertsCenterCWState extends State<AlertsCenterCW> {
  String _filter = "open"; // open | all | high

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text("Please sign in."));
    }

    final width = widget.width ?? MediaQuery.of(context).size.width;

    final alertsRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("alerts")
        .orderBy("createdAt", descending: true);

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Safety Alerts & Escalations",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            "Medication, interaction, and side-effect alerts.",
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 12),
          _buildFilterChips(),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: alertsRef.snapshots(),
              builder: (ctx, snap) {
                if (!snap.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2));
                }
                final allDocs = snap.data!.docs;

                final docs = allDocs.where((d) {
                  final data = d.data() as Map<String, dynamic>? ?? {};
                  final status = (data["status"] ?? "open").toString();
                  final severity =
                      (data["severity"] ?? "low").toString().toLowerCase();
                  if (_filter == "open" && status != "open") {
                    return false;
                  }
                  if (_filter == "high" &&
                      severity != "high" &&
                      severity != "severe") {
                    return false;
                  }
                  return true;
                }).toList();

                if (docs.isEmpty) {
                  return const Center(child: Text("No alerts."));
                }

                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    return _buildAlertCard(docs[i]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: const Text("Open"),
          selected: _filter == "open",
          onSelected: (_) => setState(() => _filter = "open"),
        ),
        ChoiceChip(
          label: const Text("High severity"),
          selected: _filter == "high",
          onSelected: (_) => setState(() => _filter = "high"),
        ),
        ChoiceChip(
          label: const Text("All"),
          selected: _filter == "all",
          onSelected: (_) => setState(() => _filter = "all"),
        ),
      ],
    );
  }

  Widget _buildAlertCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final type = (data["type"] ?? "general").toString();
    final message = (data["message"] ?? "").toString();
    final severity = (data["severity"] ?? "low").toString().toLowerCase();
    final status = (data["status"] ?? "open").toString();
    final createdAt = (data["createdAt"] as Timestamp?)?.toDate();

    Color color;
    if (severity == "high" || severity == "severe") {
      color = Colors.red;
    } else if (severity == "medium" || severity == "moderate") {
      color = Colors.orange;
    } else {
      color = Colors.green;
    }

    final dateStr = createdAt != null
        ? "${createdAt.year}/${createdAt.month}/${createdAt.day} ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}"
        : "";

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row
            Row(
              children: [
                Expanded(
                  child: Text(
                    _labelForType(type),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _severityBadge(severity, color),
              ],
            ),

            const SizedBox(height: 6),
            Text(
              message,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 6),
            if (dateStr.isNotEmpty)
              Text(
                dateStr,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Status: $status",
                  style: TextStyle(
                    fontSize: 14,
                    color: status == "open"
                        ? Colors.redAccent
                        : Colors.grey.shade700,
                  ),
                ),
                if (status == "open")
                  TextButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text("Mark Resolved"),
                    onPressed: () => _resolveAlert(doc.reference),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _labelForType(String type) {
    switch (type) {
      case "refillCritical":
        return "Refill Critical";
      case "drugInteraction":
        return "Drug Interaction";
      case "sideEffect":
        return "Side Effect Alert";
      default:
        return "Safety Alert";
    }
  }

  Widget _severityBadge(String severity, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color.withOpacity(.15),
        border: Border.all(color: color),
      ),
      child: Text(
        severity.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Future<void> _resolveAlert(DocumentReference ref) async {
    await ref.update({
      "status": "closed",
      "handledBy": FirebaseAuth.instance.currentUser?.uid ?? "",
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Alert marked as resolved.")),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
