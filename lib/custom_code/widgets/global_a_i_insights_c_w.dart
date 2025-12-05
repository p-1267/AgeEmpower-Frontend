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
// DO NOT REMOVE ABOVE

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GlobalAIInsightsCW extends StatefulWidget {
  final double? width;
  final double? height;

  const GlobalAIInsightsCW({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<GlobalAIInsightsCW> createState() => _GlobalAIInsightsCWState();
}

class _GlobalAIInsightsCWState extends State<GlobalAIInsightsCW> {
  bool loading = false;
  String summary = "";
  List<dynamic> risks = [];
  List<dynamic> recommendations = [];

  final String AI_URL =
      "https://YOUR_BACKEND_DOMAIN/api/ai/global-health-insights";

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Text("Please sign in.");

    final width = widget.width ?? MediaQuery.of(context).size.width;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "AI Health Insights",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            "A complete health profile summary powered by AI.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: loading ? null : () => _runInsight(uid),
            icon: const Icon(Icons.smart_toy),
            label: const Text("Generate AI Report"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          if (loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (!loading && summary.isNotEmpty) _buildResult(),
        ],
      ),
    );
  }

  Widget _buildResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _section("Overall Summary", summary),
        if (risks.isNotEmpty) ...[
          const SizedBox(height: 20),
          _sectionList("Risks", risks, color: Colors.red),
        ],
        if (recommendations.isNotEmpty) ...[
          const SizedBox(height: 20),
          _sectionList("Recommendations", recommendations, color: Colors.blue),
        ],
      ],
    );
  }

  Widget _section(String title, String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Widget _sectionList(String title, List<dynamic> items,
      {Color color = Colors.black}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 10),
          ...items.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(e.toString(),
                          style: const TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Future<void> _runInsight(String uid) async {
    setState(() {
      loading = true;
      summary = "";
      risks = [];
      recommendations = [];
    });

    // Step 1: Gather all data

    final medsSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("medications")
        .get();

    final meds = medsSnap.docs.map((d) => d.data()).toList();

    // no collectionGroup → manually gather vitals
    final vitalsSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("vitals")
        .orderBy("ts", descending: true)
        .limit(30)
        .get();
    final vitals = vitalsSnap.docs.map((d) => d.data()).toList();

    List<Map<String, dynamic>> sideEffects = [];
    for (final m in medsSnap.docs) {
      final s = await m.reference.collection("sideEffects").get();
      for (final e in s.docs) {
        sideEffects.add(e.data());
      }
    }

    List<Map<String, dynamic>> adherence = [];
    for (final m in medsSnap.docs) {
      final a = await m.reference.collection("adherence").get();
      for (final e in a.docs) {
        adherence.add(e.data());
      }
    }

    final alertsSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("alerts")
        .orderBy("createdAt", descending: true)
        .limit(20)
        .get();
    final alerts = alertsSnap.docs.map((d) => d.data()).toList();

    // Step 2: Send to AI
    final resp = await http.post(
      Uri.parse(AI_URL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "medications": meds,
        "vitals": vitals,
        "sideEffects": sideEffects,
        "adherence": adherence,
        "alerts": alerts,
      }),
    );

    if (resp.statusCode != 200) {
      setState(() => loading = false);
      return;
    }

    final json = jsonDecode(resp.body);

    setState(() {
      summary = json["summary"] ?? "";
      risks = json["risks"] ?? [];
      recommendations = json["recommendations"] ?? [];
      loading = false;
    });

    // Step 3: Store to Firestore
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("aiInsights")
        .add({
      "summary": summary,
      "risks": risks,
      "recommendations": recommendations,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
