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

class QuietHoursSchedulerCW extends StatefulWidget {
  final double? width;
  final double? height;

  const QuietHoursSchedulerCW({
    super.key,
    this.width,
    this.height,
  });

  @override
  State<QuietHoursSchedulerCW> createState() => _QuietHoursSchedulerCWState();
}

class _QuietHoursSchedulerCWState extends State<QuietHoursSchedulerCW> {
  TimeOfDay quietStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay quietEnd = const TimeOfDay(hour: 7, minute: 0);

  bool overrideCritical = true;
  bool loading = true;

  String? uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
    _loadQuietHours();
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? quietStart : quietEnd,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          quietStart = picked;
        } else {
          quietEnd = picked;
        }
      });
    }
  }

  Future<void> _loadQuietHours() async {
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("settings")
        .doc("quietHours")
        .get();

    final data = doc.data() ?? {};

    setState(() {
      quietStart = _parseTime(data["start"] ?? "22:00") ??
          const TimeOfDay(hour: 22, minute: 0);
      quietEnd = _parseTime(data["end"] ?? "07:00") ??
          const TimeOfDay(hour: 7, minute: 0);
      overrideCritical = data["overrideCritical"] ?? true;
      loading = false;
    });
  }

  TimeOfDay? _parseTime(String timeString) {
    try {
      final parts = timeString.split(":");
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveQuietHours() async {
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("settings")
        .doc("quietHours")
        .set({
      "start":
          "${quietStart.hour}:${quietStart.minute.toString().padLeft(2, '0')}",
      "end": "${quietEnd.hour}:${quietEnd.minute.toString().padLeft(2, '0')}",
      "overrideCritical": overrideCritical,
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Quiet hours saved")),
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
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Quiet Hours",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildTimeRow("Start", quietStart, () => _pickTime(true)),
          _buildTimeRow("End", quietEnd, () => _pickTime(false)),
          SwitchListTile(
            title: const Text("Allow critical alerts during quiet hours"),
            value: overrideCritical,
            onChanged: (v) => setState(() => overrideCritical = v),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveQuietHours,
            child: const Text("Save Quiet Hours"),
          )
        ],
      ),
    );
  }

  Widget _buildTimeRow(String label, TimeOfDay time, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("${label}: ${time.format(context)}",
            style: const TextStyle(fontSize: 18)),
        TextButton(onPressed: onTap, child: const Text("Change")),
      ],
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
