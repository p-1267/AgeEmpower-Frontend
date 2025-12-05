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
import '/custom_code/actions/index.dart';
// DO NOT REMOVE ABOVE

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationSettingsDashboardCW extends StatefulWidget {
  final double? width;
  final double? height;

  const NotificationSettingsDashboardCW({super.key, this.width, this.height});

  @override
  State<NotificationSettingsDashboardCW> createState() =>
      _NotificationSettingsDashboardCWState();
}

class _NotificationSettingsDashboardCWState
    extends State<NotificationSettingsDashboardCW> {
  String? uid;
  Map<String, dynamic> settings = {};

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
    _load();
  }

  Future<void> _load() async {
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("notifications")
        .doc("settings")
        .get();

    settings = doc.data() ??
        {
          "push": true,
          "sms": false,
          "email": true,
          "quietHoursStart": "22:00",
          "quietHoursEnd": "07:00",
        };

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: widget.width ?? double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _header(),
            const SizedBox(height: 20),
            NotificationChannelToggleCW(onChanged: _load),
            const SizedBox(height: 20),
            NotificationEscalationRulesCW(),
            const SizedBox(height: 20),
            QuietHoursEditorCW(onChanged: _load),
            const SizedBox(height: 20),
            SoundAndVibrationCW(),
            const SizedBox(height: 20),
            NotificationTestButtonCW(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Icon(Icons.notifications_active, size: 36, color: Colors.blue.shade700),
        const SizedBox(width: 12),
        const Text(
          "Notification Settings",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
