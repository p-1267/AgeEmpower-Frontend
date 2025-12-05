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
import 'EmergencyAISummaryWidget.dart';

class AgencyEmergencyConsoleCW extends StatefulWidget {
  const AgencyEmergencyConsoleCW({super.key});

  @override
  State<AgencyEmergencyConsoleCW> createState() =>
      _AgencyEmergencyConsoleCWState();
}

class _AgencyEmergencyConsoleCWState extends State<AgencyEmergencyConsoleCW> {
  String? agencyId;

  @override
  void initState() {
    super.initState();
    agencyId = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    if (agencyId == null) {
      return const Center(
        child: Text(
          "No agency account detected",
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return Column(
      children: [
        _buildHeader(),
        Expanded(child: _buildEmergencyStream()),
      ],
    );
  }

  // ----------------------------------------------------------------------
  // HEADER (Agency Title + Filters Placeholder)
  // ----------------------------------------------------------------------
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        children: [
          const Icon(Icons.business, size: 36),
          const SizedBox(width: 10),
          const Text(
            "Agency Emergency Console",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  // REALTIME STREAM OF ALL EMERGENCIES FOR THE AGENCY
  // ----------------------------------------------------------------------
  Widget _buildEmergencyStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('emergencies')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final events = snap.data!.docs
            .map((d) => d.data() as Map<String, dynamic>)
            .toList();

        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _filterAgencyEvents(events),
          builder: (context, agencyEventsSnap) {
            if (!agencyEventsSnap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final agencyEvents = agencyEventsSnap.data!;

            if (agencyEvents.isEmpty) {
              return const Center(
                child: Text(
                  "No emergencies reported for this agency.",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: agencyEvents.length,
              itemBuilder: (c, i) => _buildEmergencyCard(agencyEvents[i]),
            );
          },
        );
      },
    );
  }

  // ----------------------------------------------------------------------
  // FILTER EVENTS BY AGENCY ASSIGNMENT
  // ----------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> _filterAgencyEvents(
      List<Map<String, dynamic>> events) async {
    List<Map<String, dynamic>> result = [];

    for (final e in events) {
      final userId = e["userId"];
      if (userId == null) continue;

      final snap = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      final data = snap.data();
      if (data == null) continue;

      if (data["agency"] == agencyId) {
        result.add(e);
      }
    }

    return result;
  }

  // ----------------------------------------------------------------------
  // BUILD EMERGENCY CARD
  // ----------------------------------------------------------------------
  Widget _buildEmergencyCard(Map<String, dynamic> event) {
    final String type = (event["type"] ?? "sos").toString();
    final bool resolved = event["resolved"] == true;
    final String eventId = event["eventId"] ?? "";
    final Timestamp? ts = event["timestamp"];
    final location = event["location"];

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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: resolved ? Colors.grey : color, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE BAR
          Row(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  resolved ? "RESOLVED" : type.toUpperCase(),
                  style: TextStyle(
                    color: resolved ? Colors.grey : color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text("Event ID: $eventId"),
          if (ts != null) Text("Time: ${ts.toDate()}"),

          if (location != null)
            Text(
              "Location: ${location.latitude}, ${location.longitude}",
              style: const TextStyle(fontSize: 14),
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
                  child: const Text("Resolve"),
                ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _openAISummary(eventId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text("AI Summary"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _viewLocation(location),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                ),
                child: const Text("Location"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  // ACTION: MARK RESOLVED
  // ----------------------------------------------------------------------
  Future<void> _markResolved(String eventId) async {
    await FirebaseFirestore.instance
        .collection('emergencies')
        .doc(eventId)
        .update({"resolved": true});
  }

  // ----------------------------------------------------------------------
  // ACTION: AI SUMMARY
  // ----------------------------------------------------------------------
  void _openAISummary(String eventId) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: SizedBox(
          height: 480,
          width: 360,
          child: EmergencyAISummaryWidget(eventId: eventId),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // ACTION: LOCATION VIEWER
  // ----------------------------------------------------------------------
  void _viewLocation(dynamic loc) {
    if (loc == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location unavailable")),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "Location: ${loc.latitude.toStringAsFixed(5)}, ${loc.longitude.toStringAsFixed(5)}"),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
