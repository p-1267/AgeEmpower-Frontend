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

// Automatic FF imports…
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportSchedulerCW extends StatefulWidget {
  final double? width;
  final double? height;

  const ReportSchedulerCW({super.key, this.width, this.height});

  @override
  State<ReportSchedulerCW> createState() => _ReportSchedulerCWState();
}

class _ReportSchedulerCWState extends State<ReportSchedulerCW> {
  bool daily = false;
  bool weekly = true;
  bool monthly = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("reports")
        .doc("schedule")
        .get();

    final d = doc.data() ?? {};

    setState(() {
      daily = d["daily"] ?? false;
      weekly = d["weekly"] ?? false;
      monthly = d["monthly"] ?? false;
    });
  }

  Future<void> _save() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("reports")
        .doc("schedule")
        .set({
      "daily": daily,
      "weekly": weekly,
      "monthly": monthly,
      "updatedAt": FieldValue.serverTimestamp()
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Schedule saved")));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Report Scheduling",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _toggle("Daily Reports", daily, (v) => setState(() => daily = v)),
          _toggle("Weekly Reports", weekly, (v) => setState(() => weekly = v)),
          _toggle(
              "Monthly Reports", monthly, (v) => setState(() => monthly = v)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              backgroundColor: Colors.blue.shade700,
            ),
            child: const Text("Save Schedule",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _toggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
