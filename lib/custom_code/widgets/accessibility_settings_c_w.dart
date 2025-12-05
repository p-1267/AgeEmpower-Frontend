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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccessibilitySettingsCW extends StatefulWidget {
  final double? width;
  final double? height;

  final Function(double fontScale, bool highContrast, bool largeTouch)?
      onChanged;

  const AccessibilitySettingsCW({
    super.key,
    this.width,
    this.height,
    this.onChanged,
  });

  @override
  State<AccessibilitySettingsCW> createState() =>
      _AccessibilitySettingsCWState();
}

class _AccessibilitySettingsCWState extends State<AccessibilitySettingsCW> {
  double fontScale = 1.0;
  bool highContrast = false;
  bool largeTouchTargets = false;

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
        .collection("settings")
        .doc("accessibility")
        .get();

    final d = doc.data() ?? {};

    setState(() {
      fontScale = (d["fontScale"] ?? 1.0).toDouble();
      highContrast = d["highContrast"] ?? false;
      largeTouchTargets = d["largeTouchTargets"] ?? false;
    });
  }

  Future<void> _save() async {
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("settings")
        .doc("accessibility")
        .set({
      "fontScale": fontScale,
      "highContrast": highContrast,
      "largeTouchTargets": largeTouchTargets,
    });

    widget.onChanged?.call(fontScale, highContrast, largeTouchTargets);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Accessibility updated")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Accessibility",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _fontSizeSlider(),
          const SizedBox(height: 20),
          _toggleCard(
            "High Contrast Mode",
            highContrast,
            (v) => setState(() => highContrast = v),
          ),
          const SizedBox(height: 20),
          _toggleCard(
            "Large Touch Targets",
            largeTouchTargets,
            (v) => setState(() => largeTouchTargets = v),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              backgroundColor: Colors.blue.shade700,
            ),
            child: const Text("Save Accessibility",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _fontSizeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Font Size",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Slider(
          value: fontScale,
          min: 0.8,
          max: 1.6,
          divisions: 8,
          activeColor: Colors.blue.shade700,
          onChanged: (v) => setState(() => fontScale = v),
        ),
      ],
    );
  }

  Widget _toggleCard(String label, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
