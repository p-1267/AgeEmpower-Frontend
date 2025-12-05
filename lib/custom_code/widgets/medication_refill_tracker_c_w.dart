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

// BEGIN CUSTOM IMPORTS
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// END CUSTOM IMPORTS

//------------------------------------------------------------
// FULL MedicationRefillTrackerCW — CLEAN, VALID, PARSEABLE
//------------------------------------------------------------

class MedicationRefillTrackerCW extends StatefulWidget {
  final double? width;
  final double? height;

  const MedicationRefillTrackerCW({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<MedicationRefillTrackerCW> createState() =>
      _MedicationRefillTrackerCWState();
}

class _MedicationRefillTrackerCWState extends State<MedicationRefillTrackerCW> {
  final _aiBaseUrl = "https://YOUR_BACKEND_DOMAIN.com";

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text("Please sign in."));
    }

    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("medications")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (ctx, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final meds = snap.data!.docs;

          if (meds.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Text("No medications found."),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: meds.map((doc) {
              final data = doc.data() as Map<String, dynamic>? ?? {};

              final name = data["name"]?.toString() ?? "";
              final dosage = data["dosage"]?.toString() ?? "";
              final schedule = List<String>.from(data["schedule"] ?? []);
              final remaining =
                  (data["remaining"] is num) ? data["remaining"] as num : 0;
              final lowThreshold = (data["lowThreshold"] is num)
                  ? data["lowThreshold"] as num
                  : 5;

              final isLow = remaining <= lowThreshold;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildMedicationCard(
                  context: context,
                  docId: doc.id,
                  name: name,
                  dosage: dosage,
                  schedule: schedule,
                  remaining: remaining,
                  lowThreshold: lowThreshold,
                  isLow: isLow,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  // ----------------------------------------------------------
  // CARD UI
  // ----------------------------------------------------------
  Widget _buildMedicationCard({
    required BuildContext context,
    required String docId,
    required String name,
    required String dosage,
    required List<String> schedule,
    required num remaining,
    required num lowThreshold,
    required bool isLow,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (isLow)
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 26),
              ],
            ),

            const SizedBox(height: 6),
            Text(
              dosage,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 12),

            Text("Daily Schedule",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800)),
            const SizedBox(height: 6),

            Wrap(
              spacing: 10,
              children: schedule.map((t) {
                return Chip(
                  label: Text(t),
                  backgroundColor: Colors.blue.shade50,
                  side: BorderSide(color: Colors.blue.shade200),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(Icons.medical_services_outlined, size: 20),
                const SizedBox(width: 6),
                Text("Remaining: $remaining",
                    style: const TextStyle(fontSize: 16)),
              ],
            ),

            if (isLow)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8)),
                child: const Text("Refill needed",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w700)),
              ),

            const SizedBox(height: 16),

            // BUTTON ROW
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text("Log Dose"),
                    onPressed: () => _openAdherenceSheet(docId),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text("AI Refill"),
                    onPressed: () => _runAIRefill(docId),
                  ),
                ),
              ],
            ),

            refillBar(docId, isLow),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // ADHERENCE SHEET
  // ----------------------------------------------------------
  Future<void> _openAdherenceSheet(String medId) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _AdherenceSheet(medId: medId);
      },
    );
  }

  Future<void> _showToast(String text) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  // ----------------------------------------------------------
  // AI REFILL ENGINE
  // ----------------------------------------------------------
  Future<void> _runAIRefill(String medId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final medRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("medications")
        .doc(medId);

    final snap = await medRef.get();
    final data = snap.data() ?? {};

    try {
      final uri = Uri.parse("$_aiBaseUrl/api/ai/medications/refill-predict");
      final resp = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "remaining": data["remaining"] ?? 0,
          "timesPerDay": (data["schedule"] is List)
              ? (data["schedule"] as List).length
              : 1,
          "name": data["name"] ?? "",
          "dosage": data["dosage"] ?? "",
        }),
      );

      if (resp.statusCode != 200) {
        _showToast("AI error ${resp.statusCode}");
        return;
      }

      final json = jsonDecode(resp.body);
      final daysLeft = json["daysLeft"] ?? 0;

      await medRef.update({
        "aiDaysLeft": daysLeft,
        "aiMessage": json["message"] ?? "",
        "updatedAt": FieldValue.serverTimestamp(),
      });

      // Safety alert
      if (daysLeft <= 2) {
        await _createSafetyAlert(
          uid: uid,
          medId: medId,
          message:
              "Medication '${data["name"]}' will run out soon (AI prediction)",
        );
      }

      _showToast("AI refill prediction updated.");
    } catch (e) {
      _showToast("AI error: $e");
    }
  }

  Future<void> _createSafetyAlert({
    required String uid,
    required String medId,
    required String message,
  }) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("alerts")
        .add({
      "medId": medId,
      "type": "refillCritical",
      "severity": "high",
      "message": message,
      "createdAt": FieldValue.serverTimestamp(),
      "status": "open",
      "handledBy": "",
    });
  }

  // ----------------------------------------------------------
  // REFILL REQUEST WORKFLOW
  // ----------------------------------------------------------
  Future<void> _requestRefill(String medId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("refillRequests")
        .add({
      "medId": medId,
      "requestedAt": FieldValue.serverTimestamp(),
      "status": "pending",
      "handledBy": "",
      "notes": "",
    });

    _showToast("Refill request sent.");
  }

  // ----------------------------------------------------------
  // REFILL BUTTON UI (INSIDE CLASS)
  // ----------------------------------------------------------
  Widget refillBar(String medId, bool isLow) {
    if (!isLow) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.local_pharmacy),
        label: const Text("Request Refill"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        onPressed: () => _requestRefill(medId),
      ),
    );
  }
}

// ----------------------------------------------------------
// DOSE LOGGING SHEET (SEPARATE CLASS — VALID STRUCTURE)
// ----------------------------------------------------------
class _AdherenceSheet extends StatefulWidget {
  final String medId;

  const _AdherenceSheet({Key? key, required this.medId}) : super(key: key);

  @override
  State<_AdherenceSheet> createState() => _AdherenceSheetState();
}

class _AdherenceSheetState extends State<_AdherenceSheet> {
  String? _selectedTime;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text("Please sign in."));
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("medications")
          .doc(widget.medId)
          .get(),
      builder: (ctx, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snap.data!.data() as Map<String, dynamic>? ?? {};
        final schedule = List<String>.from(data["schedule"] ?? []);
        final remaining = (data["remaining"] ?? 0) as num;

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Log Dose",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select scheduled time",
                  style: TextStyle(color: Colors.grey.shade900, fontSize: 15),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: schedule.map((t) {
                  final selected = _selectedTime == t;
                  return ChoiceChip(
                    label: Text(t),
                    selected: selected,
                    selectedColor: Colors.blue.shade300,
                    onSelected: (_) {
                      setState(() => _selectedTime = t);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              if (_saving)
                const CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Mark as Taken"),
                  onPressed: () => _logDose(
                      scheduledTime: _selectedTime, remaining: remaining),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50)),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _logDose({
    required String? scheduledTime,
    required num remaining,
  }) async {
    if (scheduledTime == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Select a time first.")));
      return;
    }

    setState(() => _saving = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final medRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("medications")
        .doc(widget.medId);

    try {
      await medRef.collection("adherence").add({
        "doseTime": scheduledTime,
        "status": "taken",
        "timestamp": FieldValue.serverTimestamp(),
      });

      final newRemaining = (remaining - 1).clamp(0, remaining);
      await medRef.update({
        "remaining": newRemaining,
        "updatedAt": FieldValue.serverTimestamp(),
      });

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => _saving = false);
  }
}
