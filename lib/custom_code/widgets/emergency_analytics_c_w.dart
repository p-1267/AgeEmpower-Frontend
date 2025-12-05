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
import 'dart:math';

class EmergencyAnalyticsCW extends StatefulWidget {
  const EmergencyAnalyticsCW({super.key});

  @override
  State<EmergencyAnalyticsCW> createState() => _EmergencyAnalyticsCWState();
}

class _EmergencyAnalyticsCWState extends State<EmergencyAnalyticsCW> {
  bool loading = true;
  bool aiLoading = false;

  List<Map<String, dynamic>> events = [];
  Map<String, dynamic> stats = {};
  Map<String, dynamic>? aiReport;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  // ------------------------------------------------------------------
  // Load all emergencies for the signed-in agency
  // ------------------------------------------------------------------
  Future<void> _loadEvents() async {
    final agencyId = FirebaseAuth.instance.currentUser?.uid;
    if (agencyId == null) return;

    final emergencySnap =
        await FirebaseFirestore.instance.collection("emergencies").get();

    List<Map<String, dynamic>> agencyEvents = [];

    // Filter by seniors belonging to agency
    for (final doc in emergencySnap.docs) {
      final event = doc.data();
      final uid = event["userId"];
      if (uid == null) continue;

      final userSnap =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      final userData = userSnap.data();
      if (userData == null) continue;

      if (userData["agency"] == agencyId) {
        agencyEvents.add(event);
      }
    }

    events = agencyEvents;

    _computeStats();

    setState(() => loading = false);
  }

  // ------------------------------------------------------------------
  // Compute analytics statistics
  // ------------------------------------------------------------------
  void _computeStats() {
    stats = {
      "total": events.length,
      "sos": events.where((e) => e["type"] == "sos").length,
      "fall": events.where((e) => e["type"] == "fall_detected").length,
      "wandering": events.where((e) => e["type"] == "wandering_alert").length,
      "chat": events.where((e) => e["type"] == "chat_detected").length,
      "resolved": events.where((e) => e["resolved"] == true).length,
      "active": events.where((e) => e["resolved"] != true).length,
    };
  }

  // ------------------------------------------------------------------
  // Run AI Pattern Recognition (stub)
  // ------------------------------------------------------------------
  Future<void> _runAIAnalysis() async {
    setState(() => aiLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // simulate work

    aiReport = {
      "agencyRiskScore": 74,
      "predictionSummary":
          "Emergency patterns suggest increased risk of falls in the next 30 days, especially for seniors with mobility issues.",
      "recommendations": [
        "Increase monitoring for seniors with >2 falls in last 60 days.",
        "Review medication combinations for high-risk seniors.",
        "Enable geofencing for wandering-prone individuals.",
      ]
    };

    setState(() => aiLoading = false);
  }

  // ------------------------------------------------------------------
  // UI
  // ------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildKeyStats(),
        const SizedBox(height: 20),
        Expanded(child: _buildCharts()),
      ],
    );
  }

  // ------------------------------------------------------------------
  // Header
  // ------------------------------------------------------------------
  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.analytics, size: 30),
        const SizedBox(width: 10),
        const Text(
          "Emergency Analytics",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: aiLoading ? null : _runAIAnalysis,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: aiLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : const Text("Run AI Insights"),
        ),
      ],
    );
  }

  // ------------------------------------------------------------------
  // Key statistics section
  // ------------------------------------------------------------------
  Widget _buildKeyStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _statRow("Total Emergencies", stats["total"]),
          _statRow("SOS Events", stats["sos"]),
          _statRow("Falls Detected", stats["fall"]),
          _statRow("Wandering Alerts", stats["wandering"]),
          _statRow("Chat-Emergency", stats["chat"]),
          _statRow("Active", stats["active"]),
          _statRow("Resolved", stats["resolved"]),
        ],
      ),
    );
  }

  Widget _statRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            "$value",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // CHARTS SECTION
  // ------------------------------------------------------------------
  Widget _buildCharts() {
    return ListView(
      children: [
        _buildPieChart(),
        const SizedBox(height: 22),
        _buildLineChart(),
        const SizedBox(height: 22),
        if (aiReport != null) _buildAIInsightCard(),
      ],
    );
  }

  // ------------------------------------------------------------------
  // PIE CHART
  // ------------------------------------------------------------------
  Widget _buildPieChart() {
    final map = {
      "SOS": stats["sos"],
      "Fall": stats["fall"],
      "Wandering": stats["wandering"],
      "Chat": stats["chat"],
    };

    final total = map.values.fold(0, (a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Emergency Type Distribution",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 220,
            height: 220,
            child: CustomPaint(
              painter: _PieChartPainter(map),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // SIMPLE TREND LINE CHART
  // ------------------------------------------------------------------
  Widget _buildLineChart() {
    final eventsByDay = <String, int>{};

    for (final e in events) {
      final ts = e["timestamp"] as Timestamp?;
      if (ts == null) continue;

      final date = ts.toDate();
      final key = "${date.year}-${date.month}-${date.day}";

      eventsByDay[key] = (eventsByDay[key] ?? 0) + 1;
    }

    final sortedKeys = eventsByDay.keys.toList()..sort();
    final values = sortedKeys.map((k) => eventsByDay[k]!).toList();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Emergency Frequency Trend",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 160,
            child: CustomPaint(
              painter: _LineChartPainter(values),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // AI INSIGHTS CARD
  // ------------------------------------------------------------------
  Widget _buildAIInsightCard() {
    final score = aiReport!["agencyRiskScore"];
    final color = score >= 70
        ? Colors.red.shade300
        : score >= 40
            ? Colors.orange.shade300
            : Colors.green.shade300;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Agency Risk Score: $score / 100",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(aiReport!["predictionSummary"]),
          const SizedBox(height: 12),
          const Text(
            "Recommended Actions:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...((aiReport!["recommendations"] as List)
              .map((r) => Text("- $r"))
              .toList()),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// PIE CHART PAINTER
// ----------------------------------------------------------------------
class _PieChartPainter extends CustomPainter {
  final Map<String, int> data;

  _PieChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.values.fold(0, (a, b) => a + b);
    if (total == 0) return;

    double start = -pi / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    final colors = [
      Colors.red,
      Colors.orange,
      Colors.blue,
      Colors.green,
    ];

    int i = 0;

    data.forEach((label, value) {
      final sweep = (value / total) * 2 * pi;
      paint.color = colors[i % colors.length];

      canvas.drawArc(
        Rect.fromLTWH(0, 0, size.width, size.height),
        start,
        sweep,
        true,
        paint,
      );

      start += sweep;
      i++;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ----------------------------------------------------------------------
// LINE CHART PAINTER
// ----------------------------------------------------------------------
class _LineChartPainter extends CustomPainter {
  final List<int> values;

  _LineChartPainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final dx = size.width / (values.length - 1);
    final points = <Offset>[];

    for (int i = 0; i < values.length; i++) {
      final x = dx * i;
      final y = size.height - ((values[i] / maxValue) * size.height);
      points.add(Offset(x, y));
    }

    final path = Path()..addPolygon(points, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
