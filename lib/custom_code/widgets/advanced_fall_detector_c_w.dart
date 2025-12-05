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
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdvancedFallDetectorCW extends StatefulWidget {
  const AdvancedFallDetectorCW({super.key});

  @override
  State<AdvancedFallDetectorCW> createState() => _AdvancedFallDetectorCWState();
}

class _AdvancedFallDetectorCWState extends State<AdvancedFallDetectorCW> {
  // Accelerometer stream
  StreamSubscription<AccelerometerEvent>? accelSub;

  // Rolling buffer (for pre-fall analysis)
  final List<double> recentMagnitudes = [];

  int inactivityCounter = 0;
  bool fallSuspected = false;
  bool impactDetected = false;
  bool inactivityDetected = false;

  bool fallConfirmed = false;
  bool countdownActive = false;
  int countdown = 12;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  @override
  void dispose() {
    accelSub?.cancel();
    timer?.cancel();
    super.dispose();
  }

  // -------------------------------------------------------------------
  // START SENSOR MONITORING
  // -------------------------------------------------------------------
  void _startMonitoring() {
    accelSub = accelerometerEvents.listen((event) {
      final magnitude = _vectorMagnitude(event.x, event.y, event.z);

      _updateRollingBuffer(magnitude);

      if (_detectPreFall(magnitude)) {
        fallSuspected = true;
      }

      if (fallSuspected && _detectImpact(magnitude)) {
        impactDetected = true;
      }

      if (impactDetected) {
        _checkInactivity(magnitude);
      }

      if (impactDetected && inactivityDetected && !fallConfirmed) {
        fallConfirmed = true;
        _handleFallEvent();
      }
    });
  }

  // -------------------------------------------------------------------
  // ROLLING MAGNITUDE BUFFER
  // -------------------------------------------------------------------
  void _updateRollingBuffer(double magnitude) {
    recentMagnitudes.add(magnitude);
    if (recentMagnitudes.length > 15) {
      recentMagnitudes.removeAt(0);
    }
  }

  // -------------------------------------------------------------------
  // VECTOR MAGNITUDE
  // -------------------------------------------------------------------
  double _vectorMagnitude(double x, double y, double z) {
    return sqrt(x * x + y * y + z * z);
  }

  // -------------------------------------------------------------------
  // PRE-FALL DETECTION (instability)
  // -------------------------------------------------------------------
  bool _detectPreFall(double magnitude) {
    if (magnitude > 18 && magnitude < 40) {
      return true;
    }
    return false;
  }

  // -------------------------------------------------------------------
  // IMPACT DETECTION
  // -------------------------------------------------------------------
  bool _detectImpact(double magnitude) {
    return magnitude >= 35; // strong impact
  }

  // -------------------------------------------------------------------
  // POST-IMPACT INACTIVITY
  // -------------------------------------------------------------------
  void _checkInactivity(double magnitude) {
    if (magnitude < 3.5) {
      inactivityCounter++;
    } else {
      inactivityCounter = 0;
    }

    if (inactivityCounter > 10) {
      inactivityDetected = true;
    }
  }

  // -------------------------------------------------------------------
  // FALL CONFIRMED → Trigger alarm + countdown
  // -------------------------------------------------------------------
  Future<void> _handleFallEvent() async {
    Vibration.vibrate(duration: 800);
    FlutterRingtonePlayer.playAlarm(volume: 0.8);

    setState(() {
      countdownActive = true;
      countdown = 12;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (countdown == 0) {
        t.cancel();
        FlutterRingtonePlayer.stop();
        _triggerSOS();
      } else {
        setState(() => countdown--);
      }
    });
  }

  // -------------------------------------------------------------------
  // AUTO SOS TRIGGER
  // -------------------------------------------------------------------
  Future<void> _triggerSOS() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final eid = FirebaseFirestore.instance.collection('emergencies').doc().id;

    await FirebaseFirestore.instance.collection('emergencies').doc(eid).set({
      "eventId": eid,
      "userId": uid,
      "timestamp": FieldValue.serverTimestamp(),
      "type": "fall_detected",
      "autoDetected": true,
      "impactGForce": true, // placeholder; can store magnitude
      "resolved": false,
    });
  }

  // -------------------------------------------------------------------
  // CANCEL FALL
  // -------------------------------------------------------------------
  void _cancelFall() {
    FlutterRingtonePlayer.stop();
    setState(() {
      countdownActive = false;
      fallConfirmed = false;
      fallSuspected = false;
      impactDetected = false;
      inactivityDetected = false;
      inactivityCounter = 0;
    });
  }

  // -------------------------------------------------------------------
  // UI
  // -------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (!countdownActive) {
      return Container(
        padding: const EdgeInsets.all(14),
        child: const Text(
          "Advanced Fall Detector Active",
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.red),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_rounded, size: 50, color: Colors.red),
          const SizedBox(height: 10),
          const Text(
            "Fall Detected!",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "Requesting help in $countdown seconds…",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _cancelFall,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            ),
            child: const Text(
              "I'm OK — Cancel",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
