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

class SubscriptionCheckoutCW extends StatefulWidget {
  final String planId;

  const SubscriptionCheckoutCW({super.key, required this.planId});

  @override
  State<SubscriptionCheckoutCW> createState() => _SubscriptionCheckoutCWState();
}

class _SubscriptionCheckoutCWState extends State<SubscriptionCheckoutCW> {
  bool loading = false;
  String? uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> _completeSubscription() async {
    if (uid == null) return;

    setState(() => loading = true);

    // FF Stripe action completes checkout externally.
    await Future.delayed(const Duration(seconds: 2));

    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "subscription": widget.planId,
      "subscriptionUpdated": FieldValue.serverTimestamp(),
    });

    setState(() => loading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _dialog(
      title: "Confirm Subscription",
      desc: "You're choosing the '${widget.planId}' plan.",
      button: "Complete Checkout",
      loading: loading,
      onPressed: loading ? null : _completeSubscription,
    );
  }

  Widget _dialog({
    required String title,
    required String desc,
    required String button,
    required bool loading,
    VoidCallback? onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(desc, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                minimumSize: const Size(double.infinity, 48)),
            child: loading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(button,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
