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

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class MedicationAIWarningSystemCW extends StatefulWidget {
  const MedicationAIWarningSystemCW({super.key});

  @override
  State<MedicationAIWarningSystemCW> createState() =>
      _MedicationAIWarningSystemCWState();
}

class _MedicationAIWarningSystemCWState
    extends State<MedicationAIWarningSystemCW> {
  String? userId;
  bool loading = true;
  bool analyzing = false;
  bool error = false;

  List<Map<String, dynamic>> medications = [];
  Map<String, dynamic>? aiReport;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    _loadMedications();
  }

  // ------------------------------------------------------------------
  // LOAD MEDICATIONS
  // ------------------------------------------------------------------
  Future<void> _loadMedications() async {
    if (userId == null) return;

    try {
      final snap = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("medications")
          .get();

      medications =
          snap.docs.map((d) => d.data() as Map<String, dynamic>).toList();

      // Load last AI report (if exists)
      final riskSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("medSafety")
          .doc("aiRiskReport")
          .get();

      if (riskSnap.exists) {
        aiReport = riskSnap.data();
      }

      setState(() => loading = false);
    } catch (_) {
      setState(() {
        loading = false;
        error = true;
      });
    }
  }

  // ------------------------------------------------------------------
  // RUN AI ANALYSIS (stub endpoint)
  // ------------------------------------------------------------------
  Future<void> _runAIAnalysis() async {
    if (medications.isEmpty) return;

    setState(() => analyzing = true);

    final payload = {
      "userId": userId,
      "timestamp": DateTime.now().toIso8601String(),
      "medications": medications,
    };

    // ---------------------------------------------------------------
    // STUB AI ENDPOINT — returns simulated results
    // This does NOT call external servers.
    // ---------------------------------------------------------------
    final simulatedResponse = {
      "riskScore": 72,
      "highRiskMeds": ["Diazepam", "Amlodipine"],
      "interactionWarnings": [
        "Amlodipine + Diazepam may increase dizziness and fall risk."
      ],
      "fallRisk": "Elevated",
      "cognitiveRisk": "Moderate",
      "heartRisk": "Low",
      "systemSummary":
          "The current medication combination suggests elevated fall risk and moderate cognitive impairment potential. Close monitoring advised.",
      "caregiverGuidance":
          "Check for dizziness, confusion, or instability. Ensure hydration and monitor blood pressure.",
      "seniorFriendlySummary":
          "Your medications may cause dizziness. Stand up slowly and use support if needed.",
    };

    aiReport = simulatedResponse;

    // SAVE TO FIRESTORE
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("medSafety")
        .doc("aiRiskReport")
        .set(simulatedResponse);

    setState(() => analyzing = false);
  }

  // ------------------------------------------------------------------
  // UI BUILDING
  // ------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error) {
      return const Center(child: Text("Unable to load medication data."));
    }

    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 12),
        _buildMedicationList(),
        const SizedBox(height: 12),
        _buildAISection(),
      ],
    );
  }

  // ------------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------------
  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.medication, size: 32),
        const SizedBox(width: 10),
        const Text(
          "Medication AI Safety Check",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: analyzing ? null : _runAIAnalysis,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
          ),
          child: analyzing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : const Text("Analyze"),
        ),
      ],
    );
  }

  // ------------------------------------------------------------------
  // MEDICATION LIST
  // ------------------------------------------------------------------
  Widget _buildMedicationList() {
    if (medications.isEmpty) {
      return const Text(
        "No medications found.",
        style: TextStyle(fontSize: 18),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: medications.map((m) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.medication_liquid, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    m["name"] ?? "Unnamed medication",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Text(
                  m["dosage"] ?? "",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ------------------------------------------------------------------
  // AI SUMMARY SECTION
  // ------------------------------------------------------------------
  Widget _buildAISection() {
    if (aiReport == null) {
      return const Text(
        "No AI analysis available. Click Analyze to begin.",
        style: TextStyle(fontSize: 16),
      );
    }

    final score = aiReport!["riskScore"] ?? 0;
    final color = score >= 70
        ? Colors.red.shade300
        : score >= 40
            ? Colors.orange.shade300
            : Colors.green.shade300;

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // RISK SCORE CARD
            Container(
              padding: const EdgeInsets.all(14),
              width: double.infinity,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "AI Risk Score: $score / 100",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            // INTERACTION WARNINGS
            _buildCard(
              title: "Medication Interactions",
              content: (aiReport!["interactionWarnings"] as List).join("\n - "),
              icon: Icons.warning_amber_rounded,
              color: Colors.orange.shade100,
            ),

            // SYSTEM SUMMARY
            _buildCard(
              title: "System Summary",
              content: aiReport!["systemSummary"] ?? "",
              icon: Icons.info_rounded,
              color: Colors.blue.shade100,
            ),

            // CAREGIVER
            _buildCard(
              title: "Caregiver Guidance",
              content: aiReport!["caregiverGuidance"] ?? "",
              icon: Icons.support_agent,
              color: Colors.green.shade100,
            ),

            // SENIOR-FRIENDLY
            _buildCard(
              title: "Senior Summary",
              content: aiReport!["seniorFriendlySummary"] ?? "",
              icon: Icons.elderly_rounded,
              color: Colors.purple.shade100,
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // GENERIC CARD
  // ------------------------------------------------------------------
  Widget _buildCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 30),
              const SizedBox(width: 10),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(content, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
