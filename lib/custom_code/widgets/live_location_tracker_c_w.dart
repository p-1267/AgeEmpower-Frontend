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

// DO NOT REMOVE ABOVE

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';

class LiveLocationTrackerCW extends StatefulWidget {
  final double? width;
  final double? height;

  const LiveLocationTrackerCW({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<LiveLocationTrackerCW> createState() => _LiveLocationTrackerCWState();
}

class _LiveLocationTrackerCWState extends State<LiveLocationTrackerCW> {
  final Location _location = Location();

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  Future<void> _startTracking() async {
    final granted = await _location.requestPermission();
    if (granted != PermissionStatus.granted &&
        granted != PermissionStatus.grantedLimited) {
      return;
    }

    _location.onLocationChanged.listen((loc) async {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("location")
          .doc("latest")
          .set({
        "lat": loc.latitude,
        "lng": loc.longitude,
        "updatedAt": FieldValue.serverTimestamp(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Live Location Active",
      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
