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
// DO NOT REMOVE ABOVE

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmergencySOSButtonCW extends StatefulWidget {
  final double? width;
  final double? height;

  const EmergencySOSButtonCW({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<EmergencySOSButtonCW> createState() => _EmergencySOSButtonCWState();
}

class _EmergencySOSButtonCWState extends State<EmergencySOSButtonCW> {
  bool sending = false;

  Future<void> _sendSOS() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => sending = true);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("emergencies")
        .add({
      "type": "sos",
      "message": "SOS Triggered",
      "severity": "high",
      "createdAt": FieldValue.serverTimestamp(),
      "status": "open",
    });

    if (mounted) {
      setState(() => sending = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("SOS sent")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 200,
      height: widget.height ?? 200,
      child: GestureDetector(
        onTap: sending ? null : _sendSOS,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.redAccent,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color(0x44000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              )
            ],
          ),
          alignment: Alignment.center,
          child: sending
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Text(
                  "SOS",
                  style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
        ),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
