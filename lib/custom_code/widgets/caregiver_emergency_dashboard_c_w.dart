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

class CaregiverEmergencyDashboardCW extends StatefulWidget {
  const CaregiverEmergencyDashboardCW({super.key});

  @override
  State<CaregiverEmergencyDashboardCW> createState() =>
      _CaregiverEmergencyDashboardCWState();
}

class _CaregiverEmergencyDashboardCWState
    extends State<CaregiverEmergencyDashboardCW> {
  String? caregiverId;

  @override
  void initState() {
    super.initState();
    caregiverId = FirebaseAuth.instance.currentUser?.uid;
  }

  // --------------------------------------------------------------------
  // Determine if caregiver is linked to a specific senior
  // --------------------------------------------------------------------
  Future<bool> _isCaregiverForUser(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = doc.data();
    if (data == null) return false;

    final caregivers = data['caregivers'] ?? [];
    return caregivers.contains(caregiverId);
  }

  // --------------------------------------------------------------------
  // UI BUILD
  // --------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (caregiverId == null) {
      return const Center(
        child: Text("No caregiver account found."),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('emergencies')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final allEvents = snapshot.data!.docs;

        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _filterEventsForCaregiver(allEvents),
          builder: (context, filteredSnapshot) {
            if (!filteredSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final events = filteredSnapshot.data!;

            if (events.isEmpty) {
              return const Center(
                child: Text(
                  "No emergencies detected.",
                  style: TextStyle(fontSize: 20),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                return _buildEmergencyCard(events[index]);
              },
            );
          },
        );
      },
    );
  }

  // --------------------------------------------------------------------
  // Filter events the caregiver is responsible for
  // --------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> _filterEventsForCaregiver(
      List<QueryDocumentSnapshot> docs) async {
    List<Map<String, dynamic>> results = [];

    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;

      final isLinked = await _isCaregiverForUser(data["userId"]);
      if (isLinked) {
        results.add(data);
      }
    }

    return results;
  }

  // --------------------------------------------------------------------
  // EMERGENCY CARD UI
  // --------------------------------------------------------------------
  Widget _buildEmergencyCard(Map<String, dynamic> event) {
    final bool resolved = event["resolved"] == true;
    final String type = event["type"] ?? "emergency";
    final Timestamp? time = event["timestamp"];
    final String eventId = event["eventId"] ?? "";

    IconData icon;
    Color color;

    switch (type) {
      case "fall_detected":
        icon = Icons.falling;
        color = Colors.orange;
        break;
      case "wandering_alert":
        icon = Icons.directions_walk;
        color = Colors.blue;
        break;
      default:
        icon = Icons.warning_rounded;
        color = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: resolved ? Colors.grey.shade200 : color.withOpacity(0.15),
        border: Border.all(
          color: resolved ? Colors.grey : color,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON + TITLE
          Row(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  resolved
                      ? "Resolved Emergency"
                      : "Emergency: $type".toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: resolved ? Colors.grey : color,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            "Event ID: $eventId",
            style: const TextStyle(fontSize: 16),
          ),

          if (time != null)
            Text(
              "Time: ${time.toDate()}",
              style: const TextStyle(fontSize: 16),
            ),

          const SizedBox(height: 14),

          // ACTION BUTTONS
          Row(
            children: [
              if (!resolved)
                ElevatedButton(
                  onPressed: () => _markResolved(eventId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text("Mark Resolved"),
                ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _openSummary(eventId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text("AI Summary"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _viewLocation(event),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text("Location"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------
  // ACTION: MARK RESOLVED
  // --------------------------------------------------------------------
  Future<void> _markResolved(String eventId) async {
    await FirebaseFirestore.instance
        .collection('emergencies')
        .doc(eventId)
        .update({"resolved": true});
  }

  // --------------------------------------------------------------------
  // ACTION: OPEN AI SUMMARY
  // --------------------------------------------------------------------
  void _openSummary(String eventId) {
    showDialog(
      context: context,
      builder: (c) => Dialog(
        child: SizedBox(
          height: 500,
          width: 350,
          child: EmergencyAISummaryWidget(eventId: eventId),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------
  // ACTION: VIEW LOCATION
  // --------------------------------------------------------------------
  void _viewLocation(Map<String, dynamic> event) {
    final loc = event["location"];
    if (loc == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No location available.")),
      );
      return;
    }

    final lat = loc.latitude;
    final lon = loc.longitude;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Location: $lat, $lon")),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
