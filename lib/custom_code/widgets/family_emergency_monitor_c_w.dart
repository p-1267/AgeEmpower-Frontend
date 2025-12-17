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
import 'emergency_a_i_summary_widget.dart';

class FamilyEmergencyMonitorCW extends StatefulWidget {
  const FamilyEmergencyMonitorCW({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<FamilyEmergencyMonitorCW> createState() =>
      _FamilyEmergencyMonitorCWState();
}

class _FamilyEmergencyMonitorCWState extends State<FamilyEmergencyMonitorCW> {
  String? familyUserId;

  @override
  void initState() {
    super.initState();
    familyUserId = FirebaseAuth.instance.currentUser?.uid;
  }

  // --------------------------------------------------------------------
  // MAIN UI
  // --------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (familyUserId == null) {
      return const Center(
        child: Text('No family account detected.'),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildEmergencyStream()),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------
  // HEADER
  // --------------------------------------------------------------------
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: const [
          Icon(Icons.family_restroom, size: 36),
          SizedBox(width: 10),
          Text(
            'Family Emergency Monitor',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------
  // FIRESTORE STREAM
  // --------------------------------------------------------------------
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
            .map((e) => e.data() as Map<String, dynamic>)
            .toList();

        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _filterFamilyEvents(events),
          builder: (context, filteredSnap) {
            if (!filteredSnap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final familyEvents = filteredSnap.data!;

            if (familyEvents.isEmpty) {
              return const Center(
                child: Text(
                  'No emergencies for your loved ones.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: familyEvents.length,
              itemBuilder: (c, i) => _buildEmergencyCard(familyEvents[i]),
            );
          },
        );
      },
    );
  }

  // --------------------------------------------------------------------
  // FILTER EVENTS BY FAMILY LINK
  // --------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> _filterFamilyEvents(
    List<Map<String, dynamic>> events,
  ) async {
    final List<Map<String, dynamic>> results = [];

    for (final e in events) {
      final userId = e['userId'];
      if (userId == null) continue;

      final userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final data = userSnap.data();
      if (data == null) continue;

      final List familyList = (data['family'] ?? []) as List;

      if (familyList.contains(familyUserId)) {
        results.add(e);
      }
    }

    return results;
  }

  // --------------------------------------------------------------------
  // EMERGENCY CARD
  // --------------------------------------------------------------------
  Widget _buildEmergencyCard(Map<String, dynamic> event) {
    final bool resolved = event['resolved'] == true;
    final String type = event['type'] ?? 'sos';
    final Timestamp? ts = event['timestamp'];
    final String eventId = event['eventId'] ?? '';
    final location = event['location'];

    IconData icon;
    Color color;

    switch (type) {
      case 'fall_detected':
        icon = Icons.warning_amber_rounded;
        color = Colors.orange;
        break;
      case 'wandering_alert':
        icon = Icons.directions_walk;
        color = Colors.blue;
        break;
      case 'chat_detected':
        icon = Icons.chat_bubble_outline;
        color = Colors.purple;
        break;
      default:
        icon = Icons.warning_rounded;
        color = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: resolved ? Colors.grey.shade200 : color.withOpacity(0.17),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: resolved ? Colors.grey : color,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  resolved ? 'RESOLVED' : type.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    color: resolved ? Colors.grey : color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (ts != null)
            Text('Time: ${ts.toDate()}', style: const TextStyle(fontSize: 16)),
          Text('Event ID: $eventId', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          if (location != null)
            Text(
              'Location: ${location.latitude.toStringAsFixed(5)}, ${location.longitude.toStringAsFixed(5)}',
              style: const TextStyle(fontSize: 14),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _showAISummary(eventId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text('AI Summary'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _messageSenior,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Message'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------
  // AI SUMMARY
  // --------------------------------------------------------------------
  void _showAISummary(String eventId) {
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

  // --------------------------------------------------------------------
  // PLACEHOLDER MESSAGE ACTION
  // --------------------------------------------------------------------
  void _messageSenior() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Messaging feature will open senior chat.'),
      ),
    );
  }
}
