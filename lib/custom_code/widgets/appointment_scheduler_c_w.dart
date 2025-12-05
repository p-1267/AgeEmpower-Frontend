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

class AppointmentSchedulerCW extends StatefulWidget {
  const AppointmentSchedulerCW({super.key});

  @override
  State<AppointmentSchedulerCW> createState() => _AppointmentSchedulerCWState();
}

class _AppointmentSchedulerCWState extends State<AppointmentSchedulerCW> {
  final doctor = TextEditingController();
  final reason = TextEditingController();
  DateTime? date;

  Future<void> _save() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("appointments")
        .add({
      "doctor": doctor.text,
      "reason": reason.text,
      "date": date,
      "status": "upcoming",
      "createdAt": FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
            controller: doctor,
            decoration: const InputDecoration(labelText: "Doctor")),
        TextField(
            controller: reason,
            decoration: const InputDecoration(labelText: "Reason")),
        ElevatedButton(
            onPressed: () async {
              date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2040));
              setState(() {});
            },
            child: const Text("Choose Date")),
        ElevatedButton(onPressed: _save, child: const Text("Save Appointment"))
      ],
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
