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
// DO NOT REMOVE ABOVE

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class HealthOverviewCardProCW extends StatefulWidget {
  final String? userId;
  final double? width;
  final double? height;

  const HealthOverviewCardProCW({
    super.key,
    required this.userId,
    this.width,
    this.height,
  });

  @override
  State<HealthOverviewCardProCW> createState() =>
      _HealthOverviewCardProCWState();
}

class _HealthOverviewCardProCWState extends State<HealthOverviewCardProCW> {
  Map<String, dynamic> health = {};
  int riskScore = 0;
  String riskLevel = "Unknown";

  @override
  void initState() {
    super.initState();
    _loadHealth();
  }

  Future<void> _loadHealth() async {
    if (widget.userId == null) return;

    final snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .collection("health")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();

    if (snap.docs.isNotEmpty) {
      health = snap.docs.first.data();
      _calculateRisk();
      setState(() {});
    }
  }

  void _calculateRisk() {
    final hr = health["heartRate"] ?? 70;
    final steps = health["steps"] ?? 0;
    final sleep = health["sleepHours"] ?? 0;

    int score = 0;

    // Heart rate contribution
    if (hr < 50 || hr > 110)
      score += 40;
    else if (hr < 60 || hr > 100)
      score += 20;
    else
      score += 5;

    // Steps contribution
    if (steps < 2000)
      score += 30;
    else if (steps < 5000) score += 15;

    // Sleep contribution
    if (sleep < 5)
      score += 30;
    else if (sleep < 7) score += 15;

    riskScore = min(score, 100);

    if (riskScore < 20)
      riskLevel = "Low";
    else if (riskScore < 50)
      riskLevel = "Moderate";
    else if (riskScore < 75)
      riskLevel = "Elevated";
    else
      riskLevel = "High";
  }

  Color _riskColor() {
    switch (riskLevel) {
      case "Low":
        return Colors.green.shade600;
      case "Moderate":
        return Colors.orange.shade600;
      case "Elevated":
        return Colors.deepOrange.shade600;
      case "High":
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blue.shade200),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 20),
          _riskSection(),
          const SizedBox(height: 20),
          _metricsSection(),
          const SizedBox(height: 20),
          _chartsSection(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // Header
  // ---------------------------------------------------------
  Widget _header() {
    return Row(
      children: [
        Icon(Icons.health_and_safety, size: 36, color: Colors.blue.shade800),
        const SizedBox(width: 10),
        const Text(
          "Health Summary",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  // ---------------------------------------------------------
  // RISK SCORE
  // ---------------------------------------------------------
  Widget _riskSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _riskColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _riskColor()),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: _riskColor(),
            child: Text(
              "$riskScore",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              "Risk Level: $riskLevel",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _riskColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // METRICS
  // ---------------------------------------------------------
  Widget _metricsSection() {
    return Column(
      children: [
        _metricTile(
            "Heart Rate", "${health["heartRate"] ?? "--"} bpm", Icons.favorite),
        const SizedBox(height: 10),
        _metricTile(
            "Steps", "${health["steps"] ?? "--"}", Icons.directions_walk),
        const SizedBox(height: 10),
        _metricTile("Sleep", "${health["sleepHours"] ?? "--"} hrs", Icons.bed),
      ],
    );
  }

  Widget _metricTile(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.blue.shade700),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // TREND CHARTS (minimal visual placeholder, FF can replace with chart widget)
  // ---------------------------------------------------------
  Widget _chartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Recent Trends",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _miniChart("Heart Rate Trend"),
        const SizedBox(height: 12),
        _miniChart("Step Trend"),
        const SizedBox(height: 12),
        _miniChart("Sleep Trend"),
      ],
    );
  }

  Widget _miniChart(String label) {
    return Container(
      height: 80,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          "$label (chart placeholder)",
          style: TextStyle(color: Colors.blue.shade700),
        ),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
