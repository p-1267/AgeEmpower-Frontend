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

class BehaviorPatternAIWatcherCW extends StatefulWidget {
  const BehaviorPatternAIWatcherCW({super.key});

  @override
  State<BehaviorPatternAIWatcherCW> createState() =>
      _BehaviorPatternAIWatcherCWState();
}

class _BehaviorPatternAIWatcherCWState
    extends State<BehaviorPatternAIWatcherCW> {
  String? userId;

  bool loading = true;
  bool analyzing = false;

  Map<String, dynamic>? aiResult;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    _runBehaviorAnalysis();
  }

  // --------------------------------------------------------------------
  // Load all relevant data and run AI behavior analysis
  // --------------------------------------------------------------------
  Future<void> _runBehaviorAnalysis() async {
    if (userId == null) return;

    setState(() => analyzing = true);

    // Load vitals (last 14 days)
    final vitals = await _loadVitals(days: 14);

    // Load medication adherence (placeholder count)
    final meds = await _loadMedications();

    // Load emergency events (last 90 days)
    final emergencies = await _loadEmergencies(days: 90);

    // Load wandering alerts
    final wandering = await _loadWandering();

    // Load chat activity timestamps
    final chat = await _loadChatMetadata();

    // ------------------------------------------------------------------
    // AI STUB ANALYSIS (replaces real backend)
    // ------------------------------------------------------------------
    aiResult = _stubAIBehaviorAnalysis(
      vitals: vitals,
      meds: meds,
      emergencies: emergencies,
      wandering: wandering,
      chat: chat,
    );

    // Save result to Firestore
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("behaviorAI")
        .doc("watcher")
        .set(aiResult!);

    setState(() {
      analyzing = false;
      loading = false;
    });
  }

  // --------------------------------------------------------------------
  // LOADERS
  // --------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> _loadVitals({required int days}) async {
    final since = Timestamp.fromDate(
      DateTime.now().subtract(Duration(days: days)),
    );

    final snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("vitals")
        .where("timestamp", isGreaterThan: since)
        .get();

    return snap.docs.map((d) => d.data()).toList();
  }

  Future<List<Map<String, dynamic>>> _loadMedications() async {
    final snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("medications")
        .get();

    return snap.docs.map((d) => d.data()).toList();
  }

  Future<List<Map<String, dynamic>>> _loadEmergencies(
      {required int days}) async {
    final since = Timestamp.fromDate(
      DateTime.now().subtract(Duration(days: days)),
    );

    final snap = await FirebaseFirestore.instance
        .collection("emergencies")
        .where("userId", isEqualTo: userId)
        .where("timestamp", isGreaterThan: since)
        .get();

    return snap.docs.map((d) => d.data()).toList();
  }

  Future<List<Map<String, dynamic>>> _loadWandering() async {
    final snap = await FirebaseFirestore.instance
        .collection("emergencies")
        .where("userId", isEqualTo: userId)
        .where("type", isEqualTo: "wandering_alert")
        .get();

    return snap.docs.map((d) => d.data()).toList();
  }

  Future<List<Timestamp>> _loadChatMetadata() async {
    // We only read chat timestamps, not message content.
    final snap = await FirebaseFirestore.instance
        .collection("chatMeta")
        .doc(userId)
        .collection("messages")
        .get();

    return snap.docs.map((d) => d.data()["timestamp"] as Timestamp).toList();
  }

  // --------------------------------------------------------------------
  // AI BEHAVIOR STUB ENGINE
  // --------------------------------------------------------------------
  Map<String, dynamic> _stubAIBehaviorAnalysis({
    required List<Map<String, dynamic>> vitals,
    required List<Map<String, dynamic>> meds,
    required List<Map<String, dynamic>> emergencies,
    required List<Map<String, dynamic>> wandering,
    required List<Timestamp> chat,
  }) {
    // SIMPLE RULE-BASED SIMULATION OF AI
    int emergencyCount = emergencies.length;
    int wanderCount = wandering.length;
    int chatCount = chat.length;
    int medCount = meds.length;
    int vitalCount = vitals.length;

    int riskScore = 45;

    if (emergencyCount > 3) riskScore += 20;
    if (wanderCount > 1) riskScore += 10;
    if (vitalCount < 5) riskScore += 10;
    if (chatCount < 3) riskScore += 5;

    String trendSummary =
        "Behavioral patterns indicate mild instability. Monitoring recommended.";

    if (riskScore >= 80) {
      trendSummary =
          "Significant increases in emergencies and reduced activity suggest higher risk.";
    } else if (riskScore >= 60) {
      trendSummary = "Moderate behavioral changes detected.";
    }

    return {
      "riskScore": riskScore,
      "trendSummary": trendSummary,
      "recommendations": [
        "Encourage movement and hydration.",
        "Check if medications are being taken correctly.",
        "Review sleep consistency.",
        "Increase caregiving check-ins.",
      ],
      "seniorSummary":
          "Your activity has changed recently. Please take your time when standing and keep hydrated.",
      "timestamp": DateTime.now().toIso8601String(),
    };
  }

  // --------------------------------------------------------------------
  // UI
  // --------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (aiResult == null) {
      return const Center(
        child: Text("Unable to generate behavior analysis."),
      );
    }

    return _buildSummaryUI();
  }

  // --------------------------------------------------------------------
  // Behavior Summary UI
  // --------------------------------------------------------------------
  Widget _buildSummaryUI() {
    final score = aiResult!["riskScore"];
    final color = score >= 80
        ? Colors.red.shade300
        : score >= 60
            ? Colors.orange.shade300
            : Colors.green.shade300;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            "Behavior Risk Score: $score / 100",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // Summary
          _infoCard(
            "Behavior Summary",
            aiResult!["trendSummary"],
            Icons.trending_up_rounded,
            Colors.white,
          ),

          const SizedBox(height: 8),

          // Recommendations
          _infoCard(
            "Caregiver Recommendations",
            (aiResult!["recommendations"] as List)
                .map((e) => "- $e")
                .join("\n"),
            Icons.support_agent,
            Colors.white,
          ),

          const SizedBox(height: 8),

          // Senior-friendly summary
          _infoCard(
            "For Senior",
            aiResult!["seniorSummary"],
            Icons.elderly_rounded,
            Colors.white70,
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String content, IconData icon, Color color) {
    return Container(
      width: double.infinity,
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
              Icon(icon, size: 28),
              const SizedBox(width: 8),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
