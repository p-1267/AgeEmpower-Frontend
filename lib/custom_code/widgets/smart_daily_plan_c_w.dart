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

class SmartDailyPlanCW extends StatefulWidget {
  const SmartDailyPlanCW({super.key});

  @override
  State<SmartDailyPlanCW> createState() => _SmartDailyPlanCWState();
}

class _SmartDailyPlanCWState extends State<SmartDailyPlanCW> {
  String? userId;

  bool loading = true;
  bool generating = false;

  List<Map<String, dynamic>> medications = [];
  List<Map<String, dynamic>> vitals = [];
  Map<String, dynamic>? behaviorReport;

  Map<String, dynamic>? dailyPlan;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    _loadData();
  }

  // ----------------------------------------------------------------------
  // LOAD RELEVANT DATA
  // ----------------------------------------------------------------------
  Future<void> _loadData() async {
    if (userId == null) return;

    final medsSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("medications")
        .get();

    medications = medsSnap.docs.map((d) => d.data()).toList();

    final vitalSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("vitals")
        .orderBy("timestamp", descending: true)
        .limit(7)
        .get();

    vitals = vitalSnap.docs.map((d) => d.data()).toList();

    final behaviorSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("behaviorAI")
        .doc("watcher")
        .get();

    if (behaviorSnap.exists) {
      behaviorReport = behaviorSnap.data();
    }

    final planSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("dailyPlan")
        .doc("aiPlan")
        .get();

    if (planSnap.exists) {
      dailyPlan = planSnap.data();
    }

    setState(() => loading = false);
  }

  // ----------------------------------------------------------------------
  // GENERATE DAILY PLAN (stub AI)
  // ----------------------------------------------------------------------
  Future<void> _generatePlan() async {
    setState(() => generating = true);

    // Gather simple signals
    int riskScore = behaviorReport?["riskScore"] ?? 40;

    String wakeTime = "7:30 AM";
    String sleepTime = "9:30 PM";

    if (riskScore > 70) {
      wakeTime = "8:00 AM";
      sleepTime = "9:00 PM";
    }

    // Basic hydration suggestion
    String hydration = riskScore > 60
        ? "Drink water 6–8 times today."
        : "Stay hydrated 4–6 glasses.";

    // Med schedule summary
    List<String> medLines = [];
    for (final m in medications) {
      medLines.add("${m["name"] ?? "Medication"} — ${m["dosage"] ?? ""}");
    }

    // Mobility suggestions
    String mobility = "Take gentle walks 2–3 times today.";
    if (riskScore > 70)
      mobility = "Use support when walking. Avoid long distances.";

    // Cognitive suggestions
    String cognitive = "Try a simple brain exercise or puzzle.";
    if (riskScore > 70)
      cognitive = "Do calming activities (music, light reading).";

    // Meals
    List<String> meals = [
      "Balanced breakfast",
      "Light lunch + hydration",
      "Healthy dinner"
    ];

    // Final plan structure
    final plan = {
      "date": DateTime.now().toIso8601String(),
      "wakeTime": wakeTime,
      "sleepTime": sleepTime,
      "hydration": hydration,
      "medications": medLines,
      "mobility": mobility,
      "cognitive": cognitive,
      "meals": meals,
      "behaviorScore": riskScore,
      "seniorSummary": riskScore > 70
          ? "Take things slowly today. Stay hydrated and avoid rushing."
          : "Today looks like a good day! Stay active and drink water.",
    };

    dailyPlan = plan;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("dailyPlan")
        .doc("aiPlan")
        .set(plan);

    setState(() => generating = false);
  }

  // ----------------------------------------------------------------------
  // BUILD UI
  // ----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_month, size: 32),
            const SizedBox(width: 10),
            const Text(
              "Smart Daily Plan",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: generating ? null : _generatePlan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: generating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(color: Colors.white))
                  : const Text("Generate"),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: dailyPlan == null
              ? const Center(
                  child: Text(
                    "No plan yet. Press Generate.",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : _buildPlanView(),
        ),
      ],
    );
  }

  // ----------------------------------------------------------------------
  // PLAN VIEW
  // ----------------------------------------------------------------------
  Widget _buildPlanView() {
    final plan = dailyPlan!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _card("Wake Time", plan["wakeTime"], Icons.wb_sunny),
          _card("Hydration", plan["hydration"], Icons.local_drink),
          _listCard("Medications", plan["medications"], Icons.medication),
          _card("Mobility Activity", plan["mobility"], Icons.directions_walk),
          _card("Cognitive Activity", plan["cognitive"], Icons.psychology),
          _listCard("Meals", plan["meals"], Icons.restaurant_menu),
          _card("Bedtime", plan["sleepTime"], Icons.bedtime),
          _card("Today's Safety Note", plan["seniorSummary"], Icons.shield),
        ],
      ),
    );
  }

  Widget _card(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "$title:\n$value",
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listCard(String title, List<dynamic> values, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 30),
              const SizedBox(width: 12),
              Text(
                "$title:",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...values
              .map((v) => Text("- $v", style: const TextStyle(fontSize: 18)))
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
