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

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmergencyCascadeCWWebEngine extends StatefulWidget {
  const EmergencyCascadeCWWebEngine({super.key});

  @override
  State<EmergencyCascadeCWWebEngine> createState() =>
      _EmergencyCascadeCWWebEngineState();
}

class _EmergencyCascadeCWWebEngineState
    extends State<EmergencyCascadeCWWebEngine> {
  bool isEmergencyActive = false;
  bool countdownActive = false;
  int countdownSeconds = 20;

  Timer? countdownTimer;
  Timer? cascadeTimer1;
  Timer? cascadeTimer2;

  String? userId;
  Map<String, dynamic>? userData;

  List<dynamic> caregivers = [];
  List<dynamic> family = [];
  String? agency;

  String emergencyEventId = "";

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    cascadeTimer1?.cancel();
    cascadeTimer2?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------
  // LOAD USER + CONTACT DATA
  // ---------------------------------------------------------
  Future<void> _loadUser() async {
    userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final snap =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    userData = snap.data();

    caregivers = userData?['caregivers'] ?? [];
    family = userData?['family'] ?? [];
    agency = userData?['agency'];
  }

  // ---------------------------------------------------------
  // TRIGGER EMERGENCY (WEB-SAFE VERSION)
  // ---------------------------------------------------------
  Future<void> _triggerEmergency() async {
    setState(() {
      isEmergencyActive = true;
      countdownActive = true;
      countdownSeconds = 20;
    });

    // CREATE EMERGENCY RECORD (Web cannot capture GPS or sensors)
    final id = FirebaseFirestore.instance.collection('emergencies').doc().id;
    emergencyEventId = id;

    await FirebaseFirestore.instance.collection('emergencies').doc(id).set({
      "userId": userId,
      "timestamp": FieldValue.serverTimestamp(),
      "autoDetected": false,
      "location": null,
      "platform": "web",
      "caregiverStatus": "pending",
      "familyStatus": "pending",
      "agencyStatus": "pending",
      "resolved": false,
    });

    _startCountdown();
  }

  // ---------------------------------------------------------
  // CANCEL EMERGENCY
  // ---------------------------------------------------------
  Future<void> _cancelEmergency() async {
    await FirebaseFirestore.instance
        .collection('emergencies')
        .doc(emergencyEventId)
        .update({"resolved": true});

    setState(() {
      isEmergencyActive = false;
      countdownActive = false;
    });
  }

  // ---------------------------------------------------------
  // COUNTDOWN → THEN START CASCADE
  // ---------------------------------------------------------
  void _startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownSeconds == 0) {
        timer.cancel();
        countdownActive = false;
        _startCascade();
      } else {
        setState(() => countdownSeconds -= 1);
      }
    });
  }

  // ---------------------------------------------------------
  // CASCADE (CAREGIVERS → FAMILY → AGENCY)
  // ---------------------------------------------------------
  Future<void> _startCascade() async {
    // Notify caregivers first
    await _notify("caregiverStatus", caregivers);

    cascadeTimer1 = Timer(const Duration(seconds: 20), () async {
      await _notify("familyStatus", family);
    });

    cascadeTimer2 = Timer(const Duration(seconds: 40), () async {
      if (agency != null) {
        await _notify("agencyStatus", [agency]);
      }
    });
  }

  Future<void> _notify(String field, List recipients) async {
    if (recipients.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('emergencies')
        .doc(emergencyEventId)
        .update({field: "notified"});

    for (var user in recipients) {
      await FirebaseFirestore.instance.collection('notifications').add({
        "toUser": user,
        "eventId": emergencyEventId,
        "type": "emergency",
        "timestamp": FieldValue.serverTimestamp(),
      });
    }
  }

  // ---------------------------------------------------------
  // UI → Uses the shared EmergencyCascadeCWUI widget
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return EmergencyCascadeCWUI(
      isEmergencyActive: isEmergencyActive,
      countdownActive: countdownActive,
      countdownSeconds: countdownSeconds,
      onSOSPressed: _triggerEmergency,
      onCancelPressed: _cancelEmergency,
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
