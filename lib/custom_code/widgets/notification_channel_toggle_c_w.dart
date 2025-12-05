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

class NotificationChannelToggleCW extends StatefulWidget {
  final VoidCallback? onChanged;

  const NotificationChannelToggleCW({super.key, this.onChanged});

  @override
  State<NotificationChannelToggleCW> createState() =>
      _NotificationChannelToggleCWState();
}

class _NotificationChannelToggleCWState
    extends State<NotificationChannelToggleCW> {
  String? uid;
  bool push = true;
  bool email = true;
  bool sms = false;

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

    final d = doc.data() ?? {};
    push = d["push"] ?? true;
    sms = d["sms"] ?? false;
    email = d["email"] ?? true;

    setState(() {});
  }

  Future<void> _save() async {
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("notifications")
        .doc("settings")
        .set({
      "push": push,
      "sms": sms,
      "email": email,
    }, SetOptions(merge: true));

    widget.onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return _card(
      title: "Notification Channels",
      child: Column(
        children: [
          _switchTile("Push Notifications", push, (v) {
            setState(() => push = v);
            _save();
          }),
          _switchTile("Email Alerts", email, (v) {
            setState(() => email = v);
            _save();
          }),
          _switchTile("SMS Messages", sms, (v) {
            setState(() => sms = v);
            _save();
          }),
        ],
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  BoxDecoration _box() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.blue.shade200),
      boxShadow: const [
        BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 3))
      ],
    );
  }

  Widget _switchTile(String label, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
          Switch(value: value, onChanged: onChanged)
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
