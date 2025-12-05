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

// MOBILE ONLY PACKAGES
import 'package:location/location.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

// UI + Firestore service widgets
import 'package:flutter/widgets.dart';

class EmergencyCascadeCWMobileEngine extends StatefulWidget {
  const EmergencyCascadeCWMobileEngine({super.key});

  @override
  State<EmergencyCascadeCWMobileEngine> createState() =>
      _EmergencyCascadeCWMobileEngineState();
}

class _EmergencyCascadeCWMobileEngineState
    extends State<EmergencyCascadeCWMobileEngine> {
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

  GeoPoint? lastLocation;
  String emergencyEventId = "";

  Location location = Location();
  StreamSubscription<AccelerometerEvent>? accelListener;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _initFallDetection();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    cascadeTimer1?.cancel();
    cascadeTimer2?.cancel();
    accelListener?.cancel();
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
  // FALL DETECTION (Accelerometer threshold)
  // ---------------------------------------------------------
  void _initFallDetection() {
    accelListener = accelerometerEvents.listen((event) {
      final force = (event.x * event.x + event.y * event.y + event.z * event.z);

      if (force > 28 && !isEmergencyActive) {
        _triggerEmergency(autoDetected: true);
      }
    });
  }

  // ---------------------------------------------------------
  // LOCATION
  // ---------------------------------------------------------
  Future<void> _captureLocation() async {
    bool enabled = await location.serviceEnabled();
    if (!enabled) enabled = await location.requestService();
    if (!enabled) return;

    PermissionStatus perm = await location.hasPermission();
    if (perm == PermissionStatus.denied) {
      perm = await location.requestPermission();
    }
    if (perm != PermissionStatus.granted) return;

    final loc = await location.getLocation();
    lastLocation = GeoPoint(loc.latitude!, loc.longitude!);
  }

  // ---------------------------------------------------------
  // TRIGGER EMERGENCY
  // ---------------------------------------------------------
  Future<void> _triggerEmergency({bool autoDetected = false}) async {
    setState(() => isEmergencyActive = true);

    FlutterRingtonePlayer.playAlarm(volume: 0.8);
    Vibration.vibrate(duration: 900);

    await _captureLocation();

    // CREATE EMERGENCY RECORD
    final id = FirebaseFirestore.instance.collection('emergencies').doc().id;
    emergencyEventId = id;

    await FirebaseFirestore.instance.collection('emergencies').doc(id).set({
      "userId": userId,
      "timestamp": FieldValue.serverTimestamp(),
      "autoDetected": autoDetected,
      "location": lastLocation,
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
    FlutterRingtonePlayer.stop();
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
    setState(() {
      countdownActive = true;
      countdownSeconds = 20;
    });

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
    FlutterRingtonePlayer.stop();

    // NOTIFY CAREGIVERS
    await _notifyGroup("caregiverStatus", caregivers);

    cascadeTimer1 = Timer(const Duration(seconds: 20), () async {
      await _notifyGroup("familyStatus", family);
    });

    cascadeTimer2 = Timer(const Duration(seconds: 40), () async {
      if (agency != null) {
        await _notifyGroup("agencyStatus", [agency]);
      }
    });
  }

  Future<void> _notifyGroup(String field, List recipients) async {
    if (recipients.isEmpty) return;

    // Update emergency status
    await FirebaseFirestore.instance
        .collection('emergencies')
        .doc(emergencyEventId)
        .update({field: "notified"});

    // Send notifications
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
  // UI → Uses EmergencyCascadeCWUI
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return EmergencyCascadeCWUI(
      isEmergencyActive: isEmergencyActive,
      countdownActive: countdownActive,
      countdownSeconds: countdownSeconds,
      onSOSPressed: () => _triggerEmergency(autoDetected: false),
      onCancelPressed: _cancelEmergency,
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
