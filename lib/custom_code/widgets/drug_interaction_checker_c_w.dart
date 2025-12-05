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

class DrugInteractionCheckerCW extends StatefulWidget {
  final double? width;
  final double? height;

  const DrugInteractionCheckerCW({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<DrugInteractionCheckerCW> createState() =>
      _DrugInteractionCheckerCWState();
}

class _DrugInteractionCheckerCWState extends State<DrugInteractionCheckerCW> {
  final _aiEndpoint =
      "https://YOUR_BACKEND_DOMAIN.com/api/ai/medications/interactions";

  bool _loading = false;
  List<dynamic> _interactions = [];
  String? _aiSummary;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Center(child: Text("Please sign in."));
    }

    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            _buildCheckButton(uid),
            const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
            if (_aiSummary != null) _buildAISummary(),
            if (_interactions.isNotEmpty) _buildInteractionList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      "Drug Interaction Checker",
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildCheckButton(String uid) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.health_and_safety),
      label: const Text("Run Safety Check"),
      onPressed: () => _runInteractionCheck(uid),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }

  Future<void> _runInteractionCheck(String uid) async {
    setState(() {
      _loading = true;
      _interactions.clear();
      _aiSummary = null;
    });

    // Load medications
    final medsSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("medications")
        .get();

    if (medsSnap.docs.isEmpty) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No medications to analyze.")),
      );
      return;
    }

    final meds = medsSnap.docs
        .map((d) => {
              "name": d.data()["name"] ?? "",
              "dosage": d.data()["dosage"] ?? "",
            })
        .toList();

    try {
      final uri = Uri.parse(_aiEndpoint);
      final resp = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"medications": meds}),
      );

      if (resp.statusCode != 200) {
        setState(() => _loading = false);
        _showToast("AI Error ${resp.statusCode}");
        return;
      }

      final json = jsonDecode(resp.body);

      setState(() {
        _interactions = json["interactions"] ?? [];
        _aiSummary = json["summary"] ?? "";
        _loading = false;
      });

      // Write safety alerts for major interactions
      for (var i in _interactions) {
        if ((i["severity"] ?? "").toString().toLowerCase() == "major" ||
            (i["severity"] ?? "").toString().toLowerCase() ==
                "contraindicated") {
          await _createSafetyAlert(
            uid: uid,
            message:
                "⚠ Major interaction: ${i["drugA"]} + ${i["drugB"]} — ${i["description"]}",
          );
        }
      }
    } catch (e) {
      setState(() => _loading = false);
      _showToast("Error: $e");
    }
  }

  Future<void> _createSafetyAlert({
    required String uid,
    required String message,
  }) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("alerts")
        .add({
      "type": "drugInteraction",
      "severity": "high",
      "message": message,
      "createdAt": FieldValue.serverTimestamp(),
      "status": "open",
    });
  }

  Widget _buildAISummary() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _aiSummary ?? "",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildInteractionList() {
    return Expanded(
      child: ListView.separated(
        itemCount: _interactions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final d = _interactions[i];
          return _buildInteractionCard(d);
        },
      ),
    );
  }

  Widget _buildInteractionCard(dynamic d) {
    final severity = (d["severity"] ?? "minor").toLowerCase();

    Color color;
    if (severity == "major" || severity == "contraindicated") {
      color = Colors.red;
    } else if (severity == "moderate") {
      color = Colors.orange;
    } else {
      color = Colors.green;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${d["drugA"]} + ${d["drugB"]}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(.15),
                    border: Border.all(color: color),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    severity.toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              d["description"] ?? "",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            if (d["alternatives"] != null)
              Text(
                "Safer alternatives: ${d["alternatives"].join(", ")}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showToast(String msg) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
