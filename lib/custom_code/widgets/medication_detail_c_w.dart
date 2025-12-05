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

import '/flutter_flow/custom_functions.dart';
import '/custom_code/actions/index.dart';
import '/custom_code/widgets/index.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class MedicationDetailCW extends StatefulWidget {
  final double? width;
  final double? height;
  final DocumentReference? medDocRef;

  const MedicationDetailCW({
    Key? key,
    required this.medDocRef,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<MedicationDetailCW> createState() => _MedicationDetailCWState();
}

class _MedicationDetailCWState extends State<MedicationDetailCW> {
  Map<String, dynamic>? med;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadMedication();
  }

  Future<void> _loadMedication() async {
    if (widget.medDocRef == null) return;

    final snap = await widget.medDocRef!.get();
    if (!snap.exists) {
      setState(() {
        loading = false;
        med = null;
      });
      return;
    }

    setState(() {
      med = snap.data() as Map<String, dynamic>?;
      loading = false;
    });
  }

  Widget _sectionTitle(String s) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        s,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
      ),
    );
  }

  Widget _card(Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (med == null) {
      return const Center(child: Text("Medication not found."));
    }

    final name = med!['name'] ?? "";
    final dosage = med!['dosage'] ?? "";
    final strength = med!['strength'] ?? "";
    final form = med!['form'] ?? "";
    final schedule = (med!['schedule'] as List?)?.cast<String>() ?? [];
    final remaining = med!['remaining'] ?? 0;
    final lowThreshold = med!['lowThreshold'] ?? 5;
    final isLow = remaining <= lowThreshold;

    return SizedBox(
      width: widget.width ?? 400,
      height: widget.height ?? double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "$dosage — $strength — $form",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // ---------------- DOSAGE SCHEDULE ----------------
            _sectionTitle("Daily Schedule"),
            _card(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final t in schedule)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            t,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  if (schedule.isEmpty) const Text("No schedule set."),
                ],
              ),
            ),

            // ---------------- REFILL STATUS ----------------
            _sectionTitle("Refill Status"),
            _card(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Remaining: $remaining pills",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Low threshold: $lowThreshold pills",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  if (isLow)
                    ElevatedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => MedicationRefillTrackerCW(
                            medDocRef: widget.medDocRef,
                            width: widget.width,
                            height: widget.height,
                          ),
                        );
                      },
                      icon: const Icon(Icons.local_pharmacy),
                      label: const Text("Request Refill"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                    )
                  else
                    const Text(
                      "Refill level OK",
                      style: TextStyle(color: Colors.green),
                    ),
                ],
              ),
            ),

            // ---------------- ADHERENCE ----------------
            _sectionTitle("Adherence"),
            _card(
              MedicationAdherenceCW(
                medDocRef: widget.medDocRef,
                width: widget.width,
                height: 200,
              ),
            ),

            // ---------------- SIDE EFFECTS ----------------
            _sectionTitle("Side Effects"),
            _card(
              SideEffectLoggerCW(
                medDocRef: widget.medDocRef,
                width: widget.width,
                height: 200,
              ),
            ),

            // ---------------- AI SAFETY SUMMARY ----------------
            _sectionTitle("AI Safety Summary"),
            _card(
              MedicationSafetySummaryCW(
                medDocRef: widget.medDocRef,
                width: widget.width,
                height: 220,
              ),
            ),

            // ---------------- INTERACTIONS ----------------
            _sectionTitle("Interactions"),
            _card(
              ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => DrugInteractionCheckerCW(
                      width: widget.width,
                      height: widget.height,
                    ),
                  );
                },
                icon: const Icon(Icons.health_and_safety),
                label: const Text("Check Interactions"),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
