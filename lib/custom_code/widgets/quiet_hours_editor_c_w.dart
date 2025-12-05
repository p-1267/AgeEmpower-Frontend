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

class QuietHoursEditorCW extends StatefulWidget {
  final VoidCallback? onChanged;

  const QuietHoursEditorCW({super.key, this.onChanged});

  @override
  State<QuietHoursEditorCW> createState() => _QuietHoursEditorCWState();
}

class _QuietHoursEditorCWState extends State<QuietHoursEditorCW> {
  String start = "22:00";
  String end = "07:00";
  String? uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
    _load();
  }

  Future<void> _load() async {
    if (uid == null) return;

    final snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("notifications")
        .doc("settings")
        .get();

    final d = snap.data() ?? {};

    setState(() {
      start = d["quietHoursStart"] ?? "22:00";
      end = d["quietHoursEnd"] ?? "07:00";
    });
  }

  Future<void> _save() async {
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("notifications")
        .doc("settings")
        .set({
      "quietHoursStart": start,
      "quietHoursEnd": end,
    }, SetOptions(merge: true));

    widget.onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return _card(
      title: "Quiet Hours",
      child: Column(
        children: [
          _timeTile("Start", start, (v) => setState(() => start = v)),
          _timeTile("End", end, (v) => setState(() => end = v)),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                minimumSize: const Size(double.infinity, 48)),
            child: const Text("Save Quiet Hours",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blue.shade200),
        boxShadow: const [
          BoxShadow(
              color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _timeTile(String label, String value, ValueChanged<String> onChanged) {
    return GestureDetector(
      onTap: () async {
        final parts = value.split(":");
        final h = int.parse(parts[0]);
        final m = int.parse(parts[1]);

        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: h, minute: m),
        );

        if (picked != null) {
          onChanged(
              "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}");
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(child: Text("$label: $value")),
            const Icon(Icons.schedule),
          ],
        ),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
