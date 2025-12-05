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

class AppleHealthConnectCW extends StatefulWidget {
  @override
  State<AppleHealthConnectCW> createState() => _AppleHealthConnectCWState();
}

class _AppleHealthConnectCWState extends State<AppleHealthConnectCW> {
  bool connecting = false;
  String? uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> _connectAppleHealth() async {
    setState(() => connecting = true);

    await Future.delayed(const Duration(seconds: 2)); // simulate permissions

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("integrations")
        .doc("devices")
        .set({"appleHealth": true}, SetOptions(merge: true));

    setState(() => connecting = false);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildDialog(
      title: "Apple Health Connection",
      description:
          "Enable Apple Health access to sync heart rate, activity, and wellness data.",
      buttonText: "Enable Apple Health",
      loading: connecting,
      onPressed: connecting ? null : _connectAppleHealth,
    );
  }

  Widget _buildDialog({
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback? onPressed,
    bool loading = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(description, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              minimumSize: const Size(double.infinity, 52),
            ),
            child: loading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(buttonText,
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
