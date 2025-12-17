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

import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WellnessAIMegaModuleCW extends StatefulWidget {
  const WellnessAIMegaModuleCW({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<WellnessAIMegaModuleCW> createState() => _WellnessAIMegaModuleCWState();
}

class _WellnessAIMegaModuleCWState extends State<WellnessAIMegaModuleCW>
    with SingleTickerProviderStateMixin {
  String? userId;
  late TabController tabController;

  bool loading = true;

  List<Map<String, dynamic>> vitals = [];
  List<Map<String, dynamic>> medications = [];
  List<Map<String, dynamic>> sleepRecords = [];
  List<Map<String, dynamic>> cognitiveTests = [];

  Map<String, dynamic>? wellnessReport;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  // ---------------------------------------------------------------------------
  // LOAD DATA
  // ---------------------------------------------------------------------------
  Future<void> _loadData() async {
    if (userId == null) return;

    final vitalsSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('vitals')
        .orderBy('timestamp', descending: true)
        .limit(14)
        .get();
    vitals = vitalsSnap.docs.map((e) => e.data()).toList();

    final medSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('medications')
        .get();
    medications = medSnap.docs.map((e) => e.data()).toList();

    final sleepSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('vitals')
        .orderBy('timestamp', descending: true)
        .limit(7)
        .get();
    sleepRecords = sleepSnap.docs.map((e) => e.data()).toList();

    final cogSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cognitiveTests')
        .orderBy('timestamp', descending: true)
        .limit(7)
        .get();
    cognitiveTests = cogSnap.docs.map((e) => e.data()).toList();

    await _runAIEngines();

    setState(() => loading = false);
  }

  // ---------------------------------------------------------------------------
  // AI ENGINE (stub)
  // ---------------------------------------------------------------------------
  Future<void> _runAIEngines() async {
    int cognitiveScore = 80;

    if (cognitiveTests.isNotEmpty) {
      final int errors = cognitiveTests.fold<int>(
        0,
        (a, b) => a + ((b['errors'] ?? 0) as int),
      );
      cognitiveScore -= errors * 5;
      if (cognitiveScore < 0) cognitiveScore = 0;
    }

    int nutritionScore = 85;
    if (medications.length > 5) nutritionScore -= 10;
    if (vitals.isNotEmpty && (vitals.first['oxygen'] ?? 100) < 92) {
      nutritionScore -= 10;
    }

    int sleepScore = 75;
    if (sleepRecords.isNotEmpty) {
      final double avgSleep = sleepRecords
              .map((e) => (e['sleepHours'] ?? 7).toDouble())
              .fold<double>(0, (a, b) => a + b) /
          sleepRecords.length;

      if (avgSleep < 6) sleepScore -= 20;
      if (avgSleep > 9) sleepScore -= 10;
    }

    wellnessReport = {
      'timestamp': DateTime.now().toIso8601String(),
      'cognitiveScore': cognitiveScore,
      'nutritionScore': nutritionScore,
      'sleepScore': sleepScore,
      'overallScore':
          ((cognitiveScore + nutritionScore + sleepScore) / 3).round(),
      'cognitiveSummary': _generateCognitiveSummary(cognitiveScore),
      'nutritionSummary': _generateNutritionSummary(nutritionScore),
      'sleepSummary': _generateSleepSummary(sleepScore),
      'recommendations':
          _generateRecommendations(cognitiveScore, nutritionScore, sleepScore),
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wellnessAI')
        .doc('report')
        .set(wellnessReport!);
  }

  // ---------------------------------------------------------------------------
  // SUMMARY HELPERS
  // ---------------------------------------------------------------------------
  String _generateCognitiveSummary(int score) {
    if (score >= 75) return 'Cognitive performance appears stable.';
    if (score >= 50) return 'Mild cognitive changes detected.';
    return 'Significant cognitive decline risk detected.';
  }

  String _generateNutritionSummary(int score) {
    if (score >= 75) return 'Nutrition levels appear balanced.';
    if (score >= 50) return 'Potential nutritional inconsistencies observed.';
    return 'High-risk nutrition pattern detected.';
  }

  String _generateSleepSummary(int score) {
    if (score >= 75) return 'Sleep patterns appear healthy.';
    if (score >= 50) return 'Irregular sleep trends detected.';
    return 'Sleep quality significantly disrupted.';
  }

  List<String> _generateRecommendations(
      int cognitive, int nutrition, int sleep) {
    final List<String> rec = [];
    if (cognitive < 70) rec.add('Increase brain stimulation activities.');
    if (nutrition < 70) rec.add('Improve diet and hydration.');
    if (sleep < 70) rec.add('Improve bedtime routine.');
    if (rec.isEmpty) rec.add('No major concerns today.');
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

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          Row(
            children: const [
              Icon(Icons.health_and_safety, size: 32),
              SizedBox(width: 10),
              Text(
                'Wellness AI Assistant',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TabBar(
            controller: tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(icon: Icon(Icons.psychology), text: 'Cognitive AI'),
              Tab(icon: Icon(Icons.restaurant), text: 'Nutrition AI'),
              Tab(icon: Icon(Icons.bedtime), text: 'Sleep AI'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                _buildTab(
                  'Cognitive Score',
                  wellnessReport!['cognitiveScore'],
                  wellnessReport!['cognitiveSummary'],
                  Icons.psychology,
                ),
                _buildTab(
                  'Nutrition Score',
                  wellnessReport!['nutritionScore'],
                  wellnessReport!['nutritionSummary'],
                  Icons.restaurant,
                ),
                _buildTab(
                  'Sleep Score',
                  wellnessReport!['sleepScore'],
                  wellnessReport!['sleepSummary'],
                  Icons.bedtime,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int score, String summary, IconData icon) {
    Color color = score < 50
        ? Colors.red
        : score < 75
            ? Colors.orange
            : Colors.green;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _scoreCard(title, score, icon, color),
          _summaryCard('$title Summary', summary, icon),
        ],
      ),
    );
  }

  Widget _scoreCard(String title, int score, IconData icon, Color color) {
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
              '$title: $score / 100',
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
              '$title:\n$summary',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
