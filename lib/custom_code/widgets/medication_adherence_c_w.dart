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

class MedicationAdherenceCW extends StatefulWidget {
  const MedicationAdherenceCW({
    super.key,
    required this.medicationRef,
  });

  final DocumentReference medicationRef;

  @override
  State<MedicationAdherenceCW> createState() => _MedicationAdherenceCWState();
}

class _MedicationAdherenceCWState extends State<MedicationAdherenceCW> {
  late final DocumentReference<Map<String, dynamic>> _medRef;
  late final CollectionReference<Map<String, dynamic>> _logsRef;

  @override
  void initState() {
    super.initState();
    _medRef = widget.medicationRef.withConverter<Map<String, dynamic>>(
      fromFirestore: (s, _) => (s.data() ?? {}),
      toFirestore: (m, _) => m,
    );
    _logsRef = _medRef.collection('adherenceLogs');
  }

  DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<void> _markTakenNow(Map<String, dynamic> med) async {
    final now = DateTime.now();
    final today = _startOfDay(now);

    final int dailyDose =
        (med['dailyDose'] is num) ? (med['dailyDose'] as num).toInt() : 1;

    await FirebaseFirestore.instance.runTransaction((tx) async {
      final medSnap = await tx.get(_medRef);
      final medData = medSnap.data() ?? {};

      final int takenToday = (medData['takenToday'] is num)
          ? (medData['takenToday'] as num).toInt()
          : 0;
      if (takenToday >= dailyDose) {
        return; // already complete for today
      }

      // Write a log entry
      final newLog = _logsRef.doc();
      tx.set(newLog, {
        'timestamp': FieldValue.serverTimestamp(),
        'takenAtLocalMs': now.millisecondsSinceEpoch,
        'dayKey': '${today.year}-${today.month}-${today.day}',
        'type': 'taken',
      });

      tx.update(_medRef, {
        'takenToday': takenToday + 1,
        'lastTakenAt': FieldValue.serverTimestamp(),
        'lastTakenAtLocalMs': now.millisecondsSinceEpoch,
      });
    });
  }

  Future<void> _resetTakenIfNewDay(
      DocumentSnapshot<Map<String, dynamic>> snap) async {
    final data = snap.data() ?? {};
    final int lastDayMs = (data['takenDayLocalMs'] is num)
        ? (data['takenDayLocalMs'] as num).toInt()
        : 0;
    final now = DateTime.now();
    final todayStart = _startOfDay(now).millisecondsSinceEpoch;

    if (lastDayMs == 0) {
      // initialize
      await _medRef
          .set({'takenDayLocalMs': todayStart}, SetOptions(merge: true));
      return;
    }

    if (lastDayMs != todayStart) {
      await _medRef.set({
        'takenToday': 0,
        'takenDayLocalMs': todayStart,
      }, SetOptions(merge: true));
    }
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _medRef.snapshots(),
      builder: (context, medSnap) {
        if (!medSnap.hasData) {
          return _card(theme,
              child: const Center(child: CircularProgressIndicator()));
        }

        final med = medSnap.data!.data() ?? {};
        // Day rollover safety
        _resetTakenIfNewDay(medSnap.data!);

        final int dailyDose =
            (med['dailyDose'] is num) ? (med['dailyDose'] as num).toInt() : 1;
        final int takenToday =
            (med['takenToday'] is num) ? (med['takenToday'] as num).toInt() : 0;

        final lastTakenLocalMs = (med['lastTakenAtLocalMs'] is num)
            ? (med['lastTakenAtLocalMs'] as num).toInt()
            : 0;
        final DateTime? lastTaken = lastTakenLocalMs > 0
            ? DateTime.fromMillisecondsSinceEpoch(lastTakenLocalMs)
            : null;

        final double pct =
            dailyDose <= 0 ? 0 : (takenToday / dailyDose).clamp(0, 1);

        return _card(
          theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Adherence', style: theme.titleMedium),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Today', style: theme.bodyMedium),
                        const SizedBox(height: 4),
                        Text('$takenToday / $dailyDose doses',
                            style: theme.headlineSmall
                                .copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        if (lastTaken != null)
                          Text('Last taken: ${_formatTime(lastTaken)}',
                              style: theme.bodySmall
                                  .copyWith(color: theme.secondaryText)),
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
                    child: ElevatedButton(
                      onPressed: takenToday >= dailyDose
                          ? null
                          : () => _markTakenNow(med),
                      child: Text(takenToday >= dailyDose
                          ? 'Done for today'
                          : 'Mark dose taken'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Recent logs (lightweight)
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _logsRef
                    .orderBy('takenAtLocalMs', descending: true)
                    .limit(5)
                    .snapshots(),
                builder: (context, logsSnap) {
                  if (!logsSnap.hasData) return const SizedBox.shrink();
                  final docs = logsSnap.data!.docs;
                  if (docs.isEmpty) {
                    return Text('No recent logs',
                        style: theme.bodySmall
                            .copyWith(color: theme.secondaryText));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recent', style: theme.bodyMedium),
                      const SizedBox(height: 6),
                      ...docs.map((d) {
                        final m = d.data();
                        final ms = (m['takenAtLocalMs'] is num)
                            ? (m['takenAtLocalMs'] as num).toInt()
                            : 0;
                        final dt = ms > 0
                            ? DateTime.fromMillisecondsSinceEpoch(ms)
                            : null;
                        final label = dt == null
                            ? 'Dose taken'
                            : 'Dose taken at ${_formatTime(dt)}';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• $label', style: theme.bodySmall),
                        );
                      }),
                    ],
                  );
                },
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
