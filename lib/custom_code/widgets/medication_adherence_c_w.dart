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
import 'dart:convert';
import 'package:http/http.dart' as http;

class MedicationAdherenceCW extends StatefulWidget {
  final double? width;
  final double? height;

  final String medId;

  const MedicationAdherenceCW({
    Key? key,
    this.width,
    this.height,
    required this.medId,
  }) : super(key: key);

  @override
  State<MedicationAdherenceCW> createState() => _MedicationAdherenceCWState();
}

class _MedicationAdherenceCWState extends State<MedicationAdherenceCW> {
  final String _aiUrl =
      "https://YOUR_BACKEND_DOMAIN.com/api/ai/medications/adherence-insights";

  bool _loading = false;
  String? _insight;
  int _taken = 0;
  int _missed = 0;
  double _score = 0; // 0–100

  @override
  Widget build(BuildContext context) {
    final w = widget.width ?? MediaQuery.of(context).size.width;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Text("Please sign in.");
    }

    return SizedBox(
      width: w,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Adherence Summary",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              _buildStats(uid),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.analytics),
                label: const Text("Generate AI Insights"),
                onPressed: () => _runAI(uid),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 16),
              if (_loading) const Center(child: CircularProgressIndicator()),
              if (!_loading && _insight != null) _buildAI(),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // 1. Load adherence stats
  // ----------------------------------------------------------

  Widget _buildStats(String uid) {
    final ref = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("medications")
        .doc(widget.medId)
        .collection("adherence")
        .orderBy("timestamp", descending: true)
        .limit(50);

    return StreamBuilder<QuerySnapshot>(
      stream: ref.snapshots(),
      builder: (ctx, snap) {
        if (!snap.hasData) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final docs = snap.data!.docs;

        if (docs.isEmpty) {
          _score = 0;
          return const Text("No doses logged yet.");
        }

        _taken = docs.where((d) => d["status"] == "taken").length;
        _missed = docs.where((d) => d["status"] == "missed").length;

        final total = _taken + _missed;
        _score = total == 0 ? 0 : (_taken / total) * 100;

        Color scoreColor = Colors.green;
        if (_score < 50)
          scoreColor = Colors.red;
        else if (_score < 75) scoreColor = Colors.orange;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Past 50 doses:",
              style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statBox("Taken", _taken.toString(), Colors.green),
                _statBox("Missed", _missed.toString(), Colors.red),
                _statBox("Score", "${_score.toInt()}%", scoreColor),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _statBox(String label, String value, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: color, fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // 2. AI Insights
  // ----------------------------------------------------------

  Widget _buildAI() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        _insight ?? "",
        style: const TextStyle(fontSize: 15),
      ),
    );
  }

  Future<void> _runAI(String uid) async {
    setState(() {
      _loading = true;
      _insight = null;
    });

    // GET last 30 adherence entries
    final snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("medications")
        .doc(widget.medId)
        .collection("adherence")
        .orderBy("timestamp", descending: true)
        .limit(30)
        .get();

    final entries = snap.docs
        .map((d) => {
              "status": d["status"],
              "doseTime": d["doseTime"],
            })
        .toList();

    try {
      final resp = await http.post(
        Uri.parse(_aiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "adherence": entries,
        }),
      );

      if (resp.statusCode != 200) {
        _showToast("AI error ${resp.statusCode}");
        setState(() => _loading = false);
        return;
      }

      final json = jsonDecode(resp.body);

      setState(() {
        _insight = json["insight"] ?? "";
        _loading = false;
      });
    } catch (e) {
      _showToast("Error: $e");
      setState(() => _loading = false);
    }
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
