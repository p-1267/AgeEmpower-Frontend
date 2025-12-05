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

class ManageSubscriptionCW extends StatefulWidget {
  const ManageSubscriptionCW({super.key});

  @override
  State<ManageSubscriptionCW> createState() => _ManageSubscriptionCWState();
}

class _ManageSubscriptionCWState extends State<ManageSubscriptionCW> {
  String? uid;
  String currentPlan = "free";

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
    _load();
  }

  Future<void> _load() async {
    if (uid == null) return;
    final doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    setState(() => currentPlan = doc.data()?["subscription"] ?? "free");
  }

  Future<void> _cancel() async {
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({"subscription": "free"});

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Subscription canceled")));

    _load();
  }

  @override
  Widget build(BuildContext context) {
    return _card(
      title: "Manage Subscription",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Current Plan: $currentPlan",
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: currentPlan == "free" ? null : _cancel,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                minimumSize: const Size(double.infinity, 48)),
            child: const Text("Cancel Subscription"),
          )
        ],
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
