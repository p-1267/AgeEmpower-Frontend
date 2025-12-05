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

class SeniorMoodTrackerCW extends StatefulWidget {
  const SeniorMoodTrackerCW({super.key});

  @override
  State<SeniorMoodTrackerCW> createState() => _SeniorMoodTrackerCWState();
}

class _SeniorMoodTrackerCWState extends State<SeniorMoodTrackerCW> {
  String? userId;

  bool loading = true;
  bool analyzing = false;

  String? todayMood;
  String note = "";

  List<Map<String, dynamic>> last7 = [];
  Map<String, dynamic>? aiReport;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    _loadData();
  }

  // -------------------------------------------------------------------
  // Load today's mood + last 7 days + AI report
  // -------------------------------------------------------------------
  Future<void> _loadData() async {
    if (userId == null) return;

    final todayId = _todayId();

    // Today's mood
    final todaySnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("mood")
        .doc(todayId)
        .get();

    if (todaySnap.exists) {
      todayMood = todaySnap.data()!["mood"];
      note = todaySnap.data()!["note"] ?? "";
    }

    // Last 7 days
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

    final moodSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("mood")
        .where("timestamp", isGreaterThan: Timestamp.fromDate(sevenDaysAgo))
        .orderBy("timestamp", descending: true)
        .get();

    last7 = moodSnap.docs.map((d) => d.data()).toList();

    // AI Mood Report
    final aiSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("moodAI")
        .doc("report")
        .get();

    if (aiSnap.exists) {
      aiReport = aiSnap.data();
    }

    setState(() => loading = false);
  }

  // -------------------------------------------------------------------
  // Save today's mood
  // -------------------------------------------------------------------
  Future<void> _saveMood(String mood) async {
    if (userId == null) return;

    setState(() => todayMood = mood);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("mood")
        .doc(_todayId())
        .set({
      "mood": mood,
      "note": note,
      "timestamp": FieldValue.serverTimestamp(),
    });

    _loadData();
  }

  // -------------------------------------------------------------------
  // Generate AI emotional trend report
  // -------------------------------------------------------------------
  Future<void> _runAIAnalysis() async {
    setState(() => analyzing = true);

    // A simple stub AI:
    int sadCount = last7.where((e) {
      final m = (e["mood"] ?? "").toString().toLowerCase();
      return m.contains("sad") || m.contains("very sad");
    }).length;

    int happyCount = last7.where((e) {
      final m = (e["mood"] ?? "").toString().toLowerCase();
      return m.contains("happy");
    }).length;

    int riskScore = 40 + (sadCount * 10) - (happyCount * 5);
    if (riskScore < 0) riskScore = 0;
    if (riskScore > 100) riskScore = 100;

    String summary = "Mood patterns look stable.";
    if (riskScore >= 70) summary = "Notable increase in sadness detected.";
    if (riskScore >= 85) summary = "High emotional distress risk.";

    aiReport = {
      "riskScore": riskScore,
      "summary": summary,
      "recommendations": [
        "Encourage positive social interaction.",
        "Check in with the senior more frequently.",
        "Monitor sleep and hydration closely.",
      ],
      "seniorSummary": riskScore >= 70
          ? "You've been having some tough days lately. It's okay — try talking to someone you trust."
          : "You're doing well! Keep taking care of yourself.",
      "generatedAt": DateTime.now().toIso8601String(),
    };

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("moodAI")
        .doc("report")
        .set(aiReport!);

    setState(() => analyzing = false);
  }

  // -------------------------------------------------------------------
  // Utility: today's ID
  // -------------------------------------------------------------------
  String _todayId() {
    final d = DateTime.now();
    return "${d.year}-${d.month}-${d.day}";
  }

  // -------------------------------------------------------------------
  // UI
  // -------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return Column(
      children: [
        Row(
          children: const [
            Icon(Icons.emoji_emotions, size: 32),
            SizedBox(width: 10),
            Text("Daily Mood Tracker",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 14),
        _buildMoodButtons(),
        const SizedBox(height: 12),
        _buildNoteInput(),
        const SizedBox(height: 12),
        _buildTrendChart(),
        const SizedBox(height: 12),
        _buildAISummary(),
      ],
    );
  }

  // -------------------------------------------------------------------
  // Mood buttons
  // -------------------------------------------------------------------
  Widget _buildMoodButtons() {
    final moods = {
      "Very Happy": Icons.sentiment_very_satisfied,
      "Happy": Icons.sentiment_satisfied,
      "Neutral": Icons.sentiment_neutral,
      "Sad": Icons.sentiment_dissatisfied,
      "Very Sad": Icons.sentiment_very_dissatisfied,
    };

    return Wrap(
      spacing: 10,
      children: moods.entries.map((e) {
        return ChoiceChip(
          selected: todayMood == e.key,
          selectedColor: Colors.blue.shade200,
          label: Row(children: [
            Icon(e.value),
            const SizedBox(width: 6),
            Text(e.key),
          ]),
          onSelected: (_) => _saveMood(e.key),
        );
      }).toList(),
    );
  }

  // -------------------------------------------------------------------
  // Note input
  // -------------------------------------------------------------------
  Widget _buildNoteInput() {
    return TextField(
      decoration: const InputDecoration(
        labelText: "Add a note (optional)…",
        border: OutlineInputBorder(),
      ),
      controller: TextEditingController(text: note),
      onChanged: (v) => note = v,
    );
  }

  // -------------------------------------------------------------------
  // Mood trend (last 7 days)
  // -------------------------------------------------------------------
  Widget _buildTrendChart() {
    if (last7.isEmpty) {
      return const Text("No mood data yet for last 7 days.");
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Text(
            "Last 7 Days Mood Trend",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: last7.map((day) {
              final m = (day["mood"] ?? "").toString().toLowerCase();
              int value = 3;
              if (m.contains("very happy"))
                value = 5;
              else if (m.contains("happy"))
                value = 4;
              else if (m.contains("neutral"))
                value = 3;
              else if (m.contains("sad"))
                value = 2;
              else if (m.contains("very sad")) value = 1;

              return Column(
                children: [
                  Container(
                    width: 20,
                    height: value * 12,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 4),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------
  // AI emotional summary
  // -------------------------------------------------------------------
  Widget _buildAISummary() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: analyzing ? null : _runAIAnalysis,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: analyzing
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(color: Colors.white))
              : const Text("Analyze Mood"),
        ),
        const SizedBox(height: 12),
        if (aiReport != null)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Text(
                  "Emotional Risk Score: ${aiReport!["riskScore"]} / 100",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(aiReport!["summary"],
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                const Text("Caregiver Recommendations:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ...((aiReport!["recommendations"] as List)
                    .map((e) =>
                        Text("- $e", style: const TextStyle(fontSize: 16)))
                    .toList()),
                const SizedBox(height: 10),
                Text(
                  "For Senior:\n${aiReport!["seniorSummary"]}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
