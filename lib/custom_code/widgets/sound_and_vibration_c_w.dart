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

class SoundAndVibrationCW extends StatefulWidget {
  const SoundAndVibrationCW({super.key});

  @override
  State<SoundAndVibrationCW> createState() => _SoundAndVibrationCWState();
}

class _SoundAndVibrationCWState extends State<SoundAndVibrationCW> {
  String? uid;

  String selectedTone = "Default";
  String vibrationMode = "Short";

  final List<String> tones = [
    "Default",
    "Soft Chime",
    "Alert",
    "Bell",
    "Digital"
  ];
  final List<String> vibrations = ["Short", "Long", "Pulse"];

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
    _load();
  }

  Future<void> _load() async {
    if (uid == null) return;
    final d = (await FirebaseFirestore.instance
                .collection("users")
                .doc(uid)
                .collection("notifications")
                .doc("sound")
                .get())
            .data() ??
        {};

    setState(() {
      selectedTone = d["tone"] ?? "Default";
      vibrationMode = d["vibration"] ?? "Short";
    });
  }

  Future<void> _save() async {
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("notifications")
        .doc("sound")
        .set({
      "tone": selectedTone,
      "vibration": vibrationMode,
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Sound updated")));
  }

  @override
  Widget build(BuildContext context) {
    return _card(
      title: "Sound & Vibration",
      child: Column(
        children: [
          _dropdown("Notification Tone", tones, selectedTone,
              (v) => setState(() => selectedTone = v)),
          const SizedBox(height: 14),
          _dropdown("Vibration Mode", vibrations, vibrationMode,
              (v) => setState(() => vibrationMode = v)),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text("Save Sound Settings",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blue.shade200),
        boxShadow: const [
          BoxShadow(
              color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 3))
        ],
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

  Widget _dropdown(
    String label,
    List<String> items,
    String selected,
    ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Container(
          margin: const EdgeInsets.only(top: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
          ),
          child: DropdownButton<String>(
            value: selected,
            underline: const SizedBox(),
            isExpanded: true,
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => onChanged(v!),
          ),
        ),
      ],
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
