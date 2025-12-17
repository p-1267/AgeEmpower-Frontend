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

import 'package:cloud_firestore/cloud_firestore.dart';

import 'medication_adherence_c_w.dart';
import 'medication_refill_tracker_c_w.dart';
import 'medication_safety_summary_c_w.dart';

class MedicationDetailCW extends StatelessWidget {
  const MedicationDetailCW({
    super.key,
    required this.medicationRef,
  });

  final DocumentReference medicationRef;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return FutureBuilder<DocumentSnapshot>(
      future: medicationRef.get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
        final String name = (data['name'] ?? 'Medication').toString();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style:
                    theme.headlineSmall.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              MedicationAdherenceCW(medicationRef: medicationRef),
              const SizedBox(height: 14),
              MedicationRefillTrackerCW(medicationRef: medicationRef),
              const SizedBox(height: 14),
              MedicationSafetySummaryCW(medicationRef: medicationRef),
            ],
          ),
        );
      },
    );
  }
}
