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

class LanguageSelectorCW extends StatefulWidget {
  final double? width;
  final double? height;

  final Function(String languageCode)? onLanguageChanged;

  const LanguageSelectorCW({
    super.key,
    this.width,
    this.height,
    this.onLanguageChanged,
  });

  @override
  State<LanguageSelectorCW> createState() => _LanguageSelectorCWState();
}

class _LanguageSelectorCWState extends State<LanguageSelectorCW> {
  final List<Map<String, String>> languages = [
    {"code": "en", "name": "English"},
    {"code": "es", "name": "Español (Spanish)"},
    {"code": "ar", "name": "العربية (Arabic)"},
    {"code": "fr", "name": "Français (French)"},
    {"code": "de", "name": "Deutsch (German)"},
    {"code": "it", "name": "Italiano (Italian)"},
    {"code": "pt", "name": "Português (Portuguese)"},
    {"code": "nl", "name": "Nederlands (Dutch)"},
    // NEW – requested additions
    {"code": "sv", "name": "Svenska (Swedish)"},
    {"code": "fi", "name": "Suomi (Finnish)"},
  ];

  String selected = "en";
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
        .doc("language")
        .get();

    setState(() {
      selected = doc.data()?["code"] ?? "en";
    });
  }

  Future<void> _save() async {
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("settings")
        .doc("language")
        .set({"code": selected});

    widget.onLanguageChanged?.call(selected);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Language updated")),
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
          const Text(
            "Language",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _languageDropdown(),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              backgroundColor: Colors.blue.shade700,
            ),
            child: const Text(
              "Save Language",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _languageDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButton<String>(
        value: selected,
        isExpanded: true,
        underline: const SizedBox(),
        items: languages.map((lang) {
          return DropdownMenuItem(
            value: lang["code"],
            child: Text(
              lang["name"]!,
              style: const TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
        onChanged: (v) => setState(() => selected = v!),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
