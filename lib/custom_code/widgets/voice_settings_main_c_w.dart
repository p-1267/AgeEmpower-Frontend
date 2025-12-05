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
// DO NOT REMOVE ABOVE

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VoiceSettingsMainCW extends StatefulWidget {
  final double? width;
  final double? height;

  const VoiceSettingsMainCW({super.key, this.width, this.height});

  @override
  State<VoiceSettingsMainCW> createState() => _VoiceSettingsMainCWState();
}

class _VoiceSettingsMainCWState extends State<VoiceSettingsMainCW> {
  bool voiceEnabled = true;
  bool wakeWordEnabled = true;
  double sensitivity = 0.5;

  String? uid;

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
        .collection("voiceSettings")
        .doc("config")
        .get();

    final d = doc.data() ?? {};

    setState(() {
      voiceEnabled = d["voiceEnabled"] ?? true;
      wakeWordEnabled = d["wakeWordEnabled"] ?? true;
      sensitivity = (d["sensitivity"] ?? 0.5).toDouble();
    });
  }

  Future<void> _save() async {
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("voiceSettings")
        .doc("config")
        .set({
      "voiceEnabled": voiceEnabled,
      "wakeWordEnabled": wakeWordEnabled,
      "sensitivity": sensitivity,
      "updatedAt": FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Settings saved")));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Voice Settings",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildToggle(
            label: "Enable Voice Assistant",
            value: voiceEnabled,
            onChanged: (v) => setState(() => voiceEnabled = v),
          ),
          const SizedBox(height: 20),
          _buildToggle(
            label: "Enable Wake Word (“Hey AgeEmpower”)",
            value: wakeWordEnabled,
            onChanged: (v) => setState(() => wakeWordEnabled = v),
          ),
          const SizedBox(height: 20),
          _buildSensitivityCard(),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              backgroundColor: Colors.blue.shade700,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text(
              "Save Settings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(
      {required String label,
      required bool value,
      required ValueChanged<bool> onChanged}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildSensitivityCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Microphone Sensitivity",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Slider(
            value: sensitivity,
            min: 0.1,
            max: 1.0,
            divisions: 9,
            activeColor: Colors.blue,
            onChanged: (v) => setState(() => sensitivity = v),
          ),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
