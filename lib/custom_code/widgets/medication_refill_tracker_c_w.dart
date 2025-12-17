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

class MedicationRefillTrackerCW extends StatefulWidget {
  const MedicationRefillTrackerCW({
    super.key,
    required this.medicationRef,
  });

  final DocumentReference medicationRef;

  @override
  State<MedicationRefillTrackerCW> createState() =>
      _MedicationRefillTrackerCWState();
}

class _MedicationRefillTrackerCWState extends State<MedicationRefillTrackerCW> {
  late final DocumentReference<Map<String, dynamic>> _medRef;

  @override
  void initState() {
    super.initState();
    _medRef = widget.medicationRef.withConverter<Map<String, dynamic>>(
      fromFirestore: (s, _) => (s.data() ?? {}),
      toFirestore: (m, _) => m,
    );
  }

  int _asInt(dynamic v, int fallback) => (v is num) ? v.toInt() : fallback;

  Future<void> _consumeDose(Map<String, dynamic> med) async {
    final dailyDose = _asInt(med['dailyDose'], 1);
    final pillsRemaining = _asInt(med['pillsRemaining'], 0);

    if (pillsRemaining <= 0) return;

    // Basic “dose consumption”: subtract 1 pill per mark.
    // If you have complex dosing, store perDosePills and use that.
    await _medRef.set({
      'pillsRemaining': (pillsRemaining - 1).clamp(0, 999999),
      'lastPillUpdateAt': FieldValue.serverTimestamp(),
      'dailyDose': dailyDose,
    }, SetOptions(merge: true));
  }

  Future<void> _requestRefill(Map<String, dynamic> med) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final name = (med['name'] ?? 'Medication').toString();

    // Writes a refill request object under the medication doc
    await _medRef.collection('refillRequests').add({
      'createdAt': FieldValue.serverTimestamp(),
      'createdAtLocalMs': DateTime.now().millisecondsSinceEpoch,
      'status': 'requested',
      'requestedBy': uid,
      'medicationName': name,
    });

    // Optional: also create a general notification doc if your app uses it
    await FirebaseFirestore.instance.collection('notifications').add({
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'unread',
      'type': 'refill_request',
      'toUser': uid,
      'payload': {
        'medicationRefPath': _medRef.path,
        'medicationName': name,
      },
    });
  }

  String _daysLeftText(int pillsRemaining, int dailyDose) {
    if (dailyDose <= 0) return '—';
    final days = pillsRemaining / dailyDose;
    if (days.isInfinite || days.isNaN) return '—';
    final rounded = days.floor();
    return '$rounded days';
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _medRef.snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return _card(theme,
              child: const Center(child: CircularProgressIndicator()));
        }

        final med = snap.data!.data() ?? {};
        final dailyDose = _asInt(med['dailyDose'], 1);
        final pillsRemaining = _asInt(med['pillsRemaining'], 0);
        final refillThreshold = _asInt(med['refillThreshold'], 5);

        final daysLeft = _daysLeftText(pillsRemaining, dailyDose);
        final bool low = pillsRemaining <= refillThreshold;

        final double pct = (() {
          final int initial = _asInt(
              med['initialPills'], pillsRemaining == 0 ? 1 : pillsRemaining);
          if (initial <= 0) return 0.0;
          return (pillsRemaining / initial).clamp(0, 1).toDouble();
        })();

        return _card(
          theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Refill tracker', style: theme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pills remaining', style: theme.bodyMedium),
                        const SizedBox(height: 4),
                        Text('$pillsRemaining',
                            style: theme.headlineSmall
                                .copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text('Estimated left: $daysLeft',
                            style: theme.bodySmall
                                .copyWith(color: theme.secondaryText)),
                        const SizedBox(height: 6),
                        if (low)
                          Text('Low supply',
                              style:
                                  theme.bodySmall.copyWith(color: theme.error)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 54,
                    height: 54,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(value: pct, strokeWidth: 6),
                        Text('${(pct * 100).round()}%', style: theme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          pillsRemaining <= 0 ? null : () => _consumeDose(med),
                      child: const Text('Consume 1 pill'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _requestRefill(med),
                      child: const Text('Request refill'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _card(FlutterFlowTheme theme, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.alternate),
      ),
      child: child,
    );
  }
}
