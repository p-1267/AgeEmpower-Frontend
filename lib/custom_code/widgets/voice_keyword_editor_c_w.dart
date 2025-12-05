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

class VoiceKeywordEditorCW extends StatefulWidget {
  final double? width;
  final double? height;

  const VoiceKeywordEditorCW({super.key, this.width, this.height});

  @override
  State<VoiceKeywordEditorCW> createState() => _VoiceKeywordEditorCWState();
}

class _VoiceKeywordEditorCWState extends State<VoiceKeywordEditorCW> {
  List<String> keywords = [];
  TextEditingController ctrl = TextEditingController();
  String? uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
    _loadKeywords();
  }

  Future<void> _loadKeywords() async {
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("voiceSettings")
        .doc("keywords")
        .get();

    final data = doc.data() ?? {};
    setState(() {
      keywords = List<String>.from(data["list"] ?? []);
    });
  }

  Future<void> _saveKeywords() async {
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("voiceSettings")
        .doc("keywords")
        .set({"list": keywords});

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Keywords updated")));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Emergency Keywords",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: keywords
                .map((k) => Chip(
                      label: Text(k),
                      backgroundColor: Colors.red.shade100,
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () {
                        setState(() => keywords.remove(k));
                      },
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: ctrl,
                  decoration: InputDecoration(
                    hintText: "Add keyword…",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  final text = ctrl.text.trim();
                  if (text.isNotEmpty && !keywords.contains(text)) {
                    setState(() {
                      keywords.add(text);
                      ctrl.clear();
                    });
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.blue.shade700,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              )
            ],
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _saveKeywords,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              backgroundColor: Colors.blue.shade700,
            ),
            child: const Text("Save Keywords",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
