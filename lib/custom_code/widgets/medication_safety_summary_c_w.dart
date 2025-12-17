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

class MedicationSafetySummaryCW extends StatelessWidget {
  const MedicationSafetySummaryCW({
    super.key,
    required this.medicationRef,
  });

  final DocumentReference medicationRef;

  int _asInt(dynamic v, int fallback) => (v is num) ? v.toInt() : fallback;

  int _computeSafetyScore(Map<String, dynamic> med) {
    // Simple, extensible scoring (advanced-ready)
    // Add more signals over time without changing API.
    int score = 0;

    final bool hasContra = (med['contraindications'] is List) &&
        (med['contraindications'] as List).isNotEmpty;
    final bool hasInteractions = (med['interactions'] is List) &&
        (med['interactions'] as List).isNotEmpty;

    if (hasContra) score += 35;
    if (hasInteractions) score += 25;

    final int ageRisk = _asInt(med['ageRiskScore'], 0); // optional field
    score += ageRisk.clamp(0, 40);

    return score.clamp(0, 100);
  }

  String _category(int score) {
    if (score < 25) return 'Low';
    if (score < 55) return 'Moderate';
    if (score < 80) return 'Elevated';
    return 'High';
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    final medRef = medicationRef.withConverter<Map<String, dynamic>>(
      fromFirestore: (s, _) => (s.data() ?? {}),
      toFirestore: (m, _) => m,
    );

    final sideEffectsRef = medRef.collection('sideEffects');

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: medRef.snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return _card(theme,
              child: const Center(child: CircularProgressIndicator()));
        }

        final med = snap.data!.data() ?? {};
        final score = _computeSafetyScore(med);
        final cat = _category(score);

        final instructions = (med['instructions'] ?? '').toString();
        final contraindications = (med['contraindications'] is List)
            ? (med['contraindications'] as List).cast<dynamic>()
            : const [];
        final interactions = (med['interactions'] is List)
            ? (med['interactions'] as List).cast<dynamic>()
            : const [];

        return _card(
          theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Safety summary', style: theme.titleMedium),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Risk: $cat',
                      style: theme.headlineSmall
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text('$score/100', style: theme.bodyMedium),
                ],
              ),
              const SizedBox(height: 10),

              if (instructions.isNotEmpty) ...[
                Text('Instructions', style: theme.bodyMedium),
                const SizedBox(height: 6),
                Text(instructions, style: theme.bodySmall),
                const SizedBox(height: 10),
              ],

              if (contraindications.isNotEmpty) ...[
                Text('Contraindications', style: theme.bodyMedium),
                const SizedBox(height: 6),
                ...contraindications.take(4).map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• ${e.toString()}', style: theme.bodySmall),
                    )),
                const SizedBox(height: 10),
              ],

              if (interactions.isNotEmpty) ...[
                Text('Interactions', style: theme.bodyMedium),
                const SizedBox(height: 6),
                ...interactions.take(4).map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• ${e.toString()}', style: theme.bodySmall),
                    )),
                const SizedBox(height: 10),
              ],

              // Recent side effects (no collectionGroup; scoped to this medication)
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: sideEffectsRef
                    .orderBy('createdAtLocalMs', descending: true)
                    .limit(3)
                    .snapshots(),
                builder: (context, seSnap) {
                  if (!seSnap.hasData) return const SizedBox.shrink();
                  final docs = seSnap.data!.docs;
                  if (docs.isEmpty) {
                    return Text('No recent side effects logged.',
                        style: theme.bodySmall
                            .copyWith(color: theme.secondaryText));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recent side effects', style: theme.bodyMedium),
                      const SizedBox(height: 6),
                      ...docs.map((d) {
                        final m = d.data();
                        final label = (m['label'] ?? m['note'] ?? 'Side effect')
                            .toString();
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
