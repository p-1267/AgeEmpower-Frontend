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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationEscalationRulesCW extends StatefulWidget {
  const NotificationEscalationRulesCW({super.key});

  @override
  State<NotificationEscalationRulesCW> createState() =>
      _NotificationEscalationRulesCWState();
}

class _NotificationEscalationRulesCWState
    extends State<NotificationEscalationRulesCW> {
  String? uid;

  int delayBeforeFamily = 10;
  int delayBeforeCaregiver = 20;
  int delayBeforeAgency = 30;

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
        .doc("escalation")
        .get();

    final d = snap.data() ?? {};

    setState(() {
      delayBeforeFamily = d["familyDelay"] ?? 10;
      delayBeforeCaregiver = d["caregiverDelay"] ?? 20;
      delayBeforeAgency = d["agencyDelay"] ?? 30;
    });
  }

  Future<void> _save() async {
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("notifications")
        .doc("escalation")
        .set({
      "familyDelay": delayBeforeFamily,
      "caregiverDelay": delayBeforeCaregiver,
      "agencyDelay": delayBeforeAgency,
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Escalation saved")));
  }

  @override
  Widget build(BuildContext context) {
    return _card(
      title: "Escalation Rules",
      child: Column(
        children: [
          _slider("Notify Family After", delayBeforeFamily, (v) {
            setState(() => delayBeforeFamily = v);
          }),
          _slider("Notify Caregiver After", delayBeforeCaregiver, (v) {
            setState(() => delayBeforeCaregiver = v);
          }),
          _slider("Notify Agency After", delayBeforeAgency, (v) {
            setState(() => delayBeforeAgency = v);
          }),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                minimumSize: const Size(double.infinity, 48)),
            child: const Text(
              "Save Escalation Rules",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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

  Widget _slider(String label, int value, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: $value seconds", style: const TextStyle(fontSize: 16)),
        Slider(
          value: value.toDouble(),
          min: 5,
          max: 180,
          divisions: 35,
          onChanged: (v) => onChanged(v.round()),
          activeColor: Colors.blue.shade700,
        ),
      ],
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
