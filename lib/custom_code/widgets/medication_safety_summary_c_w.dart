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

class MedicationSafetySummaryCW extends StatefulWidget {
  final double? width;
  final double? height;

  const MedicationSafetySummaryCW({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<MedicationSafetySummaryCW> createState() =>
      _MedicationSafetySummaryCWState();
}

class _MedicationSafetySummaryCWState extends State<MedicationSafetySummaryCW> {
  final String _aiUrl =
      "https://YOUR_BACKEND_DOMAIN.com/api/ai/medications/safety-summary";

  bool _loading = false;
  String? _summary;
  int? _riskScore;
  List<dynamic> _recommendations = [];

  @override
  Widget build(BuildContext context) {
    final w = widget.width ?? MediaQuery.of(context).size.width;

    return SizedBox(
      width: w,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "AI Medication Safety Summary",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.smart_toy),
                label: const Text("Generate Safety Summary"),
                onPressed: _runAISummary,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 16),
              if (_loading) const Center(child: CircularProgressIndicator()),
              if (!_loading && _summary != null) _buildAISummary(),
            ],
          ),
        ),
      ),
    );
  }

  // UI for AI output

  Widget _buildAISummary() {
    Color riskColor = Colors.green;
    if ((_riskScore ?? 0) >= 75)
      riskColor = Colors.red;
    else if ((_riskScore ?? 0) >= 50)
      riskColor = Colors.orange;
    else if ((_riskScore ?? 0) >= 25) riskColor = Colors.amber;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: riskColor.withOpacity(.15),
              border: Border.all(color: riskColor),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            "Risk Level: ${_riskScore ?? 0} / 100",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: riskColor),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Summary",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(_summary ?? "", style: const TextStyle(fontSize: 15)),
        const SizedBox(height: 16),
        if (_recommendations.isNotEmpty) _buildRecs(),
      ],
    );
  }

  Widget _buildRecs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recommendations",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        ..._recommendations.map(
          (r) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child:
                      Text(r.toString(), style: const TextStyle(fontSize: 15)),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  // SAFETY SUMMARY LOGIC

  Future<void> _runAISummary() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() {
      _loading = true;
      _summary = null;
      _riskScore = null;
      _recommendations = [];
    });

    // 1. Load all medications
    final medsSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("medications")
        .get();

    final meds = medsSnap.docs
        .map((d) => {
              "id": d.id,
              "name": d.data()["name"] ?? "",
              "dosage": d.data()["dosage"] ?? "",
              "strength": d.data()["strength"] ?? "",
              "schedule": d.data()["schedule"] ?? [],
              "remaining": d.data()["remaining"] ?? 0,
            })
        .toList();

    // 2. Load side-effects for each medication (FlutterFlow-compatible)
    List<Map<String, dynamic>> sideEffects = [];

    for (final med in medsSnap.docs) {
      final seSnap = await med.reference.collection("sideEffects").get();

      for (final se in seSnap.docs) {
        sideEffects.add({
          "medId": med.id,
          "description": se.data()["description"] ?? "",
          "severity": se.data()["severity"] ?? "",
        });
      }
    }

    // 3. Send to AI
    try {
      final resp = await http.post(
        Uri.parse(_aiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "medications": meds,
          "sideEffects": sideEffects,
        }),
      );

      if (!resp.statusCode.toString().startsWith("2")) {
        _show("AI error ${resp.statusCode}");
        setState(() => _loading = false);
        return;
      }

      final json = jsonDecode(resp.body);

      setState(() {
        _summary = json["summary"] ?? "";
        _riskScore = json["riskScore"] ?? 0;
        _recommendations = json["recommendations"] ?? [];
        _loading = false;
      });
    } catch (e) {
      _show("Error: $e");
      setState(() => _loading = false);
    }
  }

  void _show(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
