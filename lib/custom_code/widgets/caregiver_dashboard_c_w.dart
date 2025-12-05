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

// FF Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CaregiverDashboardCW extends StatelessWidget {
  final double? width;
  final double? height;

  const CaregiverDashboardCW({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final me = FirebaseAuth.instance.currentUser;
    if (me == null) return const Text("Login required");

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection("users").doc(me.uid).get(),
      builder: (c, snap) {
        if (!snap.hasData) return const CircularProgressIndicator();
        final linked = snap.data!.data()?["linkedTo"];
        if (linked == null) return const Text("No patient assigned.");

        return _overview(context, linked);
      },
    );
  }

  Widget _overview(BuildContext context, String uid) {
    final meds = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("medications");
    final alerts = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("alerts");
    final appts = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("appointments");

    return Column(
      children: [
        _tile("Medication Compliance", Icons.check_circle, meds),
        _tile("Alerts", Icons.warning_amber, alerts),
        _tile("Vitals Trend", Icons.monitor_heart, null, route: "/VitalsPage"),
        _tile("Appointments", Icons.event, appts),
      ],
    );
  }

  Widget _tile(String title, IconData icon, Query<Map<String, dynamic>>? ref,
      {String? route}) {
    return Card(
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        onTap: () => route != null ? Navigator.pushNamed(route) : null,
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
