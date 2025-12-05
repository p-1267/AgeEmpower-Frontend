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
import '/flutter_flow/custom_functions.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationChannelSelectorCW extends StatefulWidget {
  final double? width;
  final double? height;

  const NotificationChannelSelectorCW({
    super.key,
    this.width,
    this.height,
  });

  @override
  State<NotificationChannelSelectorCW> createState() =>
      _NotificationChannelSelectorCWState();
}

class _NotificationChannelSelectorCWState
    extends State<NotificationChannelSelectorCW> {
  bool push = true;
  bool sms = false;
  bool email = false;

  bool loading = true;
  String? uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    if (uid == null) return;
    final snap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    final data = snap.data() ?? {};

    final prefs = data["notificationPrefs"] ?? {};
    setState(() {
      push = prefs["push"] ?? true;
      sms = prefs["sms"] ?? false;
      email = prefs["email"] ?? false;
      loading = false;
    });
  }

  Future<void> _savePrefs() async {
    if (uid == null) return;

    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "notificationPrefs": {
        "push": push,
        "sms": sms,
        "email": email,
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Notification preferences saved")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      width: widget.width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Notification Channels",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          SwitchListTile(
            title: const Text("Push Notifications"),
            value: push,
            onChanged: (v) => setState(() => push = v),
          ),
          SwitchListTile(
            title: const Text("SMS Alerts"),
            subtitle: const Text("May require premium plan"),
            value: sms,
            onChanged: (v) => setState(() => sms = v),
          ),
          SwitchListTile(
            title: const Text("Email Notifications"),
            value: email,
            onChanged: (v) => setState(() => email = v),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: _savePrefs,
            child: const Text("Save Settings"),
          )
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
