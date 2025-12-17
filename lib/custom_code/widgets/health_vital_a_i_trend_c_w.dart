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

class HealthVitalAITrendCW extends StatefulWidget {
  const HealthVitalAITrendCW({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<HealthVitalAITrendCW> createState() => _HealthVitalAITrendCWState();
}

class _HealthVitalAITrendCWState extends State<HealthVitalAITrendCW> {
  bool loading = true;
  bool analyzing = false;
  bool error = false;

  String? userId;
  List<Map<String, dynamic>> vitals = [];
  Map<String, dynamic>? aiReport;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    _loadVitals();
  }

  // ------------------------------------------------------------------
  // LOAD VITAL RECORDS (past 30 days)
  // ------------------------------------------------------------------
  Future<void> _loadVitals() async {
    if (userId == null) return;

    try {
      final since = DateTime.now().subtract(const Duration(days: 30));

      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('vitals')
          .where('timestamp', isGreaterThan: Timestamp.fromDate(since))
          .orderBy('timestamp', descending: true)
          .get();

      vitals = snap.docs.map((d) => d.data()).toList();

      final reportSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('healthAI')
          .doc('trend')
          .get();

      if (reportSnap.exists) {
        aiReport = reportSnap.data();
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
  // RUN AI TREND ANALYSIS (stub)
  // ------------------------------------------------------------------
  Future<void> _runAIAnalysis() async {
    if (vitals.isEmpty) return;

    setState(() => analyzing = true);

    final simulatedResponse = {
      'fallRisk': 0.42,
      'heartRisk': 0.31,
      'wanderingRisk': 0.18,
      'overallRiskScore': 67,
      'trendSummary':
          'Vitals indicate moderately elevated fall risk due to variability in steps, sleep hours, and lower oxygen readings on certain days.',
      'caregiverGuidance':
          'Encourage consistent sleep schedules and hydration. Monitor for dizziness.',
      'seniorSummary':
          'Your recent activity and sleep patterns suggest being careful with balance and movement.',
    };

    aiReport = simulatedResponse;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('healthAI')
        .doc('trend')
        .set(simulatedResponse);

    setState(() => analyzing = false);
  }

  // ------------------------------------------------------------------
  // UI
  // ------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error) {
      return const Center(child: Text('Unable to load vitals data.'));
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildVitalTrendSummary(),
          const SizedBox(height: 12),
          _buildAITrendSection(),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------------
  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.monitor_heart_rounded, size: 32),
        const SizedBox(width: 12),
        const Text(
          'AI Vital Trends',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: analyzing ? null : _runAIAnalysis,
          child: analyzing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : const Text('Analyze Trends'),
        ),
      ],
    );
  }

  // ------------------------------------------------------------------
  // BASIC TREND SUMMARY
  // ------------------------------------------------------------------
  Widget _buildVitalTrendSummary() {
    if (vitals.isEmpty) {
      return const Text('No recent vital data available.');
    }

    final recent = vitals.first;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _trendRow('Heart Rate', '${recent['heartRate']} bpm'),
          _trendRow(
              'Blood Pressure', '${recent['systolic']}/${recent['diastolic']}'),
          _trendRow('Oxygen', '${recent['oxygen']}%'),
          _trendRow('Steps', '${recent['steps']}'),
          _trendRow('Sleep Hours', '${recent['sleepHours']}h'),
        ],
      ),
    );
  }

  Widget _trendRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // AI TREND SECTION
  // ------------------------------------------------------------------
  Widget _buildAITrendSection() {
    if (aiReport == null) {
      return const Text(
        'No AI trend analysis available. Run the analysis above.',
      );
    }

    final score = aiReport!['overallRiskScore'] ?? 0;
    final color = score >= 70
        ? Colors.red.shade300
        : score >= 40
            ? Colors.orange.shade300
            : Colors.green.shade300;

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Health Risk Score: $score / 100',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 14),
            _aiCard(
              title: 'Trend Summary',
              content: aiReport!['trendSummary'],
              icon: Icons.trending_up_rounded,
              color: Colors.blue.shade100,
            ),
            _aiCard(
              title: 'Fall Risk',
              content:
                  'Estimated Fall Risk: ${(aiReport!['fallRisk'] * 100).toStringAsFixed(1)}%',
              icon: Icons.warning_amber_rounded,
              color: Colors.orange.shade100,
            ),
            _aiCard(
              title: 'Heart Event Risk',
              content:
                  'Estimated Heart Risk: ${(aiReport!['heartRisk'] * 100).toStringAsFixed(1)}%',
              icon: Icons.favorite_rounded,
              color: Colors.red.shade100,
            ),
            _aiCard(
              title: 'Wandering Risk',
              content:
                  'Estimated Wandering Risk: ${(aiReport!['wanderingRisk'] * 100).toStringAsFixed(1)}%',
              icon: Icons.directions_walk_rounded,
              color: Colors.green.shade100,
            ),
            _aiCard(
              title: 'Caregiver Guidance',
              content: aiReport!['caregiverGuidance'],
              icon: Icons.support_agent,
              color: Colors.purple.shade100,
            ),
            _aiCard(
              title: 'Senior Summary',
              content: aiReport!['seniorSummary'],
              icon: Icons.elderly_rounded,
              color: Colors.teal.shade100,
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // AI CARD
  // ------------------------------------------------------------------
  Widget _aiCard({
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
              Icon(icon),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Text(content),
        ],
      ),
    );
  }
}
