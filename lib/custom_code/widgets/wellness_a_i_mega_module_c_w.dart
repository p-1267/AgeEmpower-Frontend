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

class WellnessAIMegaModuleCW extends StatefulWidget {
  const WellnessAIMegaModuleCW({super.key});

  @override
  State<WellnessAIMegaModuleCW> createState() => _WellnessAIMegaModuleCWState();
}

class _WellnessAIMegaModuleCWState extends State<WellnessAIMegaModuleCW>
    with SingleTickerProviderStateMixin {
  String? userId;

  late TabController tabController;

  bool loading = true;
  bool analyzing = true;

  // Loaded Data
  List<Map<String, dynamic>> vitals = [];
  List<Map<String, dynamic>> medications = [];
  List<Map<String, dynamic>> sleepRecords = [];
  List<Map<String, dynamic>> cognitiveTests = [];

  // AI Results
  Map<String, dynamic>? wellnessReport;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  // ---------------------------------------------------------------------------
  // LOAD NECESSARY DATA
  // ---------------------------------------------------------------------------
  Future<void> _loadData() async {
    if (userId == null) return;

    // Load vitals (last 14 days)
    final vitalsSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("vitals")
        .orderBy("timestamp", descending: true)
        .limit(14)
        .get();

    vitals = vitalsSnap.docs.map((e) => e.data()).toList();

    // Load medications
    final medSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("medications")
        .get();

    medications = medSnap.docs.map((e) => e.data()).toList();

    // Load sleep records (7 days)
    final sleepSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("vitals")
        .orderBy("timestamp", descending: true)
        .limit(7)
        .get();

    sleepRecords = sleepSnap.docs.map((e) => e.data()).toList();

    // Load cognitive tests (7 most recent)
    final cogSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("cognitiveTests")
        .orderBy("timestamp", descending: true)
        .limit(7)
        .get();

    cognitiveTests = cogSnap.docs.map((e) => e.data()).toList();

    // Run AI engines automatically
    await _runAIEngines();

    setState(() {
      loading = false;
      analyzing = false;
    });
  }

  // ---------------------------------------------------------------------------
  // AI ENGINES (STUB LOGIC FOR NOW)
  // ---------------------------------------------------------------------------
  Future<void> _runAIEngines() async {
    // -------- Cognitive Score --------
    int cognitiveScore = 80; // baseline
    if (cognitiveTests.isNotEmpty) {
      final errors = cognitiveTests.fold(0, (a, b) => a + (b["errors"] ?? 0));
      cognitiveScore -= errors * 5;
      if (cognitiveScore < 0) cognitiveScore = 0;
    }

    // -------- Nutrition Score --------
    int nutritionScore = 85;
    if (medications.length > 5) nutritionScore -= 10; // polypharmacy
    if (vitals.isNotEmpty && (vitals.first["oxygen"] ?? 100) < 92) {
      nutritionScore -= 10;
    }

    // -------- Sleep Score --------
    int sleepScore = 75;
    if (sleepRecords.isNotEmpty) {
      double avgSleep = sleepRecords
              .map((e) => (e["sleepHours"] ?? 7).toDouble())
              .fold(0, (a, b) => a + b) /
          sleepRecords.length;

      if (avgSleep < 6) sleepScore -= 20;
      if (avgSleep > 9) sleepScore -= 10;
    }

    // Compile AI report
    wellnessReport = {
      "timestamp": DateTime.now().toIso8601String(),
      "cognitiveScore": cognitiveScore,
      "nutritionScore": nutritionScore,
      "sleepScore": sleepScore,
      "overallScore":
          ((cognitiveScore + nutritionScore + sleepScore) / 3).round(),
      "cognitiveSummary": _generateCognitiveSummary(cognitiveScore),
      "nutritionSummary": _generateNutritionSummary(nutritionScore),
      "sleepSummary": _generateSleepSummary(sleepScore),
      "recommendations": _generateRecommendations(
        cognitiveScore,
        nutritionScore,
        sleepScore,
      ),
    };

    // Save report
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("wellnessAI")
        .doc("report")
        .set(wellnessReport!);
  }

  // ---------------------------------------------------------------------------
  // AI Summaries (stub logic)
  // ---------------------------------------------------------------------------
  String _generateCognitiveSummary(int score) {
    if (score >= 75) return "Cognitive performance appears stable.";
    if (score >= 50) return "Mild cognitive changes detected.";
    return "Significant cognitive decline risk detected.";
  }

  String _generateNutritionSummary(int score) {
    if (score >= 75) return "Nutrition levels appear balanced.";
    if (score >= 50) return "Potential nutritional inconsistencies observed.";
    return "High-risk nutrition pattern. Consider reviewing diet and medications.";
  }

  String _generateSleepSummary(int score) {
    if (score >= 75) return "Sleep patterns appear healthy.";
    if (score >= 50) return "Irregular sleep trends detected.";
    return "Sleep quality appears significantly disrupted.";
  }

  List<String> _generateRecommendations(
      int cognitive, int nutrition, int sleep) {
    List<String> rec = [];

    if (cognitive < 70) rec.add("Increase brain stimulation activities.");
    if (nutrition < 70) rec.add("Review diet and increase hydration.");
    if (sleep < 70) rec.add("Improve bedtime routine and screen-free time.");

    if (rec.isEmpty)
      rec.add("No major concerns today. Keep up healthy habits!");

    return rec;
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        const SizedBox(height: 8),

        // HEADER
        Row(
          children: const [
            Icon(Icons.health_and_safety, size: 32),
            SizedBox(width: 10),
            Text(
              "Wellness AI Assistant",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // TAB BAR
        TabBar(
          controller: tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.psychology), text: "Cognitive AI"),
            Tab(icon: Icon(Icons.restaurant), text: "Nutrition AI"),
            Tab(icon: Icon(Icons.bedtime), text: "Sleep AI"),
          ],
        ),

        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              _buildCognitiveTab(),
              _buildNutritionTab(),
              _buildSleepTab(),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TAB: Cognitive AI
  // ---------------------------------------------------------------------------
  Widget _buildCognitiveTab() {
    final score = wellnessReport!["cognitiveScore"];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _scoreCard("Cognitive Score", score, Icons.psychology),
          _summaryCard("Cognitive Summary", wellnessReport!["cognitiveSummary"],
              Icons.brain),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB: Nutrition AI
  // ---------------------------------------------------------------------------
  Widget _buildNutritionTab() {
    final score = wellnessReport!["nutritionScore"];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _scoreCard("Nutrition Score", score, Icons.restaurant),
          _summaryCard("Nutrition Summary", wellnessReport!["nutritionSummary"],
              Icons.local_dining),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB: Sleep AI
  // ---------------------------------------------------------------------------
  Widget _buildSleepTab() {
    final score = wellnessReport!["sleepScore"];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _scoreCard("Sleep Score", score, Icons.bedtime),
          _summaryCard(
              "Sleep Summary", wellnessReport!["sleepSummary"], Icons.bed),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UI Components
  // ---------------------------------------------------------------------------
  Widget _scoreCard(String title, int score, IconData icon) {
    Color color = Colors.green;
    if (score < 75) color = Colors.orange;
    if (score < 50) color = Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "$title: $score / 100",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, String summary, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$title:\n$summary",
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
