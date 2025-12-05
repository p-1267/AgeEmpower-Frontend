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

class EmergencyAISummaryWidget extends StatefulWidget {
  const EmergencyAISummaryWidget({
    super.key,
    required this.eventId,
  });

  final String eventId;

  @override
  State<EmergencyAISummaryWidget> createState() =>
      _EmergencyAISummaryWidgetState();
}

class _EmergencyAISummaryWidgetState extends State<EmergencyAISummaryWidget> {
  bool loading = true;
  bool error = false;

  Map<String, dynamic>? eventData;
  Map<String, dynamic>? userData;

  Map<String, dynamic>? aiSummary;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  // ------------------------------------------------------------------
  // Load event + user data → then call AI stub
  // ------------------------------------------------------------------
  Future<void> _loadAll() async {
    try {
      // Load emergency event
      final eventSnap = await FirebaseFirestore.instance
          .collection('emergencies')
          .doc(widget.eventId)
          .get();

      eventData = eventSnap.data();
      if (eventData == null) {
        setState(() => error = true);
        return;
      }

      // Load user profile
      final userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(eventData!['userId'])
          .get();

      userData = userSnap.data();
      if (userData == null) {
        setState(() => error = true);
        return;
      }

      // Call AI stub
      await _generateAISummary();

      setState(() => loading = false);
    } catch (e) {
      setState(() => error = true);
    }
  }

  // ------------------------------------------------------------------
  // AI Summary (Stub Endpoint)
  // This will be replaced with your real backend later with 0 changes.
  // ------------------------------------------------------------------
  Future<void> _generateAISummary() async {
    final url = Uri.parse("https://stub-ai-endpoint.local/emergency-summary");

    // Build request payload
    final payload = {
      "user": {
        "name": userData?['name'] ?? "",
        "age": userData?['age'] ?? "",
        "conditions": userData?['conditions'] ?? [],
        "medications": userData?['medications'] ?? [],
      },
      "event": {
        "autoDetected": eventData?['autoDetected'],
        "location": eventData?['location'],
        "timestamp": eventData?['timestamp'].toString(),
      }
    };

    // Simulated AI response (because it's a stub)
    final simulatedAIResponse = {
      "summary":
          "A possible fall was detected. The user may require immediate evaluation. Please contact the user if safe to do so.",
      "riskScore": 78,
      "caregiverInstructions":
          "Check on the user immediately and confirm safety. If unresponsive, escalate to emergency services.",
      "familyInstructions":
          "A potential fall was detected. Stay available for updates.",
      "agencyInstructions":
          "Review the emergency details and be prepared for deployment.",
      "script911":
          "My client may have suffered a fall. They are located at the last known position in the event file. Please send medical assistance."
    };

    // Set stub result
    aiSummary = simulatedAIResponse;

    // Save summary back to Firestore
    await FirebaseFirestore.instance
        .collection('emergencies')
        .doc(widget.eventId)
        .update({"aiSummary": aiSummary});
  }

  // ------------------------------------------------------------------
  // UI
  // ------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error || aiSummary == null) {
      return const Center(
        child: Text(
          "Unable to load emergency summary.",
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }

    return _buildSummaryUI();
  }

  // ------------------------------------------------------------------
  // Beautiful AI Summary UI
  // ------------------------------------------------------------------
  Widget _buildSummaryUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildCard(
            title: "AI Emergency Summary",
            content: aiSummary!["summary"],
            icon: Icons.health_and_safety_rounded,
            color: Colors.red.shade100,
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: "Risk Score",
            content: "${aiSummary!['riskScore']} / 100",
            icon: Icons.warning_rounded,
            color: Colors.orange.shade100,
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: "Caregiver Instructions",
            content: aiSummary!["caregiverInstructions"],
            icon: Icons.support_agent,
            color: Colors.blue.shade100,
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: "Family Instructions",
            content: aiSummary!["familyInstructions"],
            icon: Icons.family_restroom,
            color: Colors.green.shade100,
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: "Agency Instructions",
            content: aiSummary!["agencyInstructions"],
            icon: Icons.apartment_rounded,
            color: Colors.purple.shade100,
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: "911 Script",
            content: aiSummary!["script911"],
            icon: Icons.phone_in_talk_rounded,
            color: Colors.red.shade200,
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 30, color: Colors.black54),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 18,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
