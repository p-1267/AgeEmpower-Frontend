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

// Automatic FF imports…
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VoiceLanguageSelectorCW extends StatefulWidget {
  final double? width;
  final double? height;

  const VoiceLanguageSelectorCW({super.key, this.width, this.height});

  @override
  State<VoiceLanguageSelectorCW> createState() =>
      _VoiceLanguageSelectorCWState();
}

class _VoiceLanguageSelectorCWState extends State<VoiceLanguageSelectorCW> {
  String selectedLanguage = "English (US)";
  String selectedVoice = "Standard Female";

  final languages = [
    "English (US)",
    "English (UK)",
    "Spanish",
    "Arabic",
    "French",
    "German"
  ];

  final voices = [
    "Standard Female",
    "Standard Male",
    "Warm Female",
    "Deep Male"
  ];

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
        .doc("language")
        .get();

    final d = doc.data() ?? {};
    setState(() {
      selectedLanguage = d["language"] ?? "English (US)";
      selectedVoice = d["voice"] ?? "Standard Female";
    });
  }

  Future<void> _save() async {
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("voiceSettings")
        .doc("language")
        .set({
      "language": selectedLanguage,
      "voice": selectedVoice,
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Language settings saved")));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Voice Language",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _dropdown("Language", selectedLanguage, languages,
              (v) => setState(() => selectedLanguage = v)),
          const SizedBox(height: 20),
          _dropdown("Voice Style", selectedVoice, voices,
              (v) => setState(() => selectedVoice = v)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              backgroundColor: Colors.blue.shade700,
            ),
            child: const Text("Save",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> items,
      ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButton<String>(
            value: value,
            underline: const SizedBox(),
            isExpanded: true,
            items: items.map((i) {
              return DropdownMenuItem(value: i, child: Text(i));
            }).toList(),
            onChanged: (v) => onChanged(v!),
          ),
        ),
      ],
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
