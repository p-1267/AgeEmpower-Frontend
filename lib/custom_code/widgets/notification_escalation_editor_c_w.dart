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

class NotificationEscalationEditorCW extends StatefulWidget {
  final double? width;
  final double? height;

  const NotificationEscalationEditorCW({
    super.key,
    this.width,
    this.height,
  });

  @override
  State<NotificationEscalationEditorCW> createState() =>
      _NotificationEscalationEditorCWState();
}

class _NotificationEscalationEditorCWState
    extends State<NotificationEscalationEditorCW> {
  int caregiverDelay = 30;
  int familyDelay = 60;
  int agencyDelay = 120;

  bool loading = true;
  String? uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
    _loadRules();
  }

  Future<void> _loadRules() async {
    if (uid == null) return;

    final snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("settings")
        .doc("escalationRules")
        .get();

    final data = snap.data() ?? {};

    setState(() {
      caregiverDelay = data["caregiverDelay"] ?? 30;
      familyDelay = data["familyDelay"] ?? 60;
      agencyDelay = data["agencyDelay"] ?? 120;
      loading = false;
    });
  }

  Future<void> _saveRules() async {
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("settings")
        .doc("escalationRules")
        .set({
      "caregiverDelay": caregiverDelay,
      "familyDelay": familyDelay,
      "agencyDelay": agencyDelay,
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Escalation rules saved")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      width: widget.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Text(
            "Emergency Escalation Rules",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildSlider(
            label: "Caregiver response time (seconds)",
            value: caregiverDelay.toDouble(),
            onChanged: (v) => setState(() => caregiverDelay = v.toInt()),
          ),
          _buildSlider(
            label: "Family response time (seconds)",
            value: familyDelay.toDouble(),
            onChanged: (v) => setState(() => familyDelay = v.toInt()),
          ),
          _buildSlider(
            label: "Agency response time (seconds)",
            value: agencyDelay.toDouble(),
            onChanged: (v) => setState(() => agencyDelay = v.toInt()),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveRules,
            child: const Text("Save Escalation Rules"),
          )
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        Slider(
          value: value,
          min: 10,
          max: 300,
          divisions: 29,
          label: "${value.toInt()} sec",
          onChanged: onChanged,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
