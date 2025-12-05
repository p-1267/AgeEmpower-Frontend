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

import '/custom_code/actions/index.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

/// A custom widget that displays the latest vitals for the current user.
/// It listens to the `healthMetrics` collection and renders the most
/// recent value for Heart Rate (HR), Blood Pressure (BP), Temperature (TEMP),
/// and Oxygen (OXYGEN). If no data is available, it shows '--'.
class VitalsOverviewCW extends StatelessWidget {
  /// Optional width and height; FlutterFlow may pass these but they are ignored.
  final double? width;
  final double? height;
  const VitalsOverviewCW({
    super.key,
    this.width,
    this.height,
  });

  Stream<QuerySnapshot<Map<String, dynamic>>> _stream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Stream.empty();
    }
    return FirebaseFirestore.instance
        .collection('healthMetrics')
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _stream(),
      builder: (context, snapshot) {
        final latest = <String, dynamic>{};
        if (snapshot.hasData) {
          for (final doc in snapshot.data!.docs) {
            final data = doc.data();
            final type = data['type'] as String?;
            if (type != null && !latest.containsKey(type)) {
              latest[type] = data['value'];
            }
          }
        }
        final hr = latest['HR'] ?? '--';
        final bp = latest['BP'] ?? '--';
        final temp = latest['TEMP'] ?? '--';
        final oxy = latest['OXYGEN'] ?? '--';

        Widget buildMetric(String title, dynamic value, Color color) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodySmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodySmall.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
              Text(
                value.toString(),
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .fontStyle,
                      ),
                      color: color,
                      letterSpacing: 0.0,
                    ),
              ),
            ],
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today's Vitals",
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.interTight(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                          ),
                    ),
                    Icon(
                      Icons.favorite_rounded,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 24.0,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildMetric(
                        'Heart Rate', hr, FlutterFlowTheme.of(context).success),
                    buildMetric('Blood Pressure', bp,
                        FlutterFlowTheme.of(context).success),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildMetric('Temperature', temp,
                        FlutterFlowTheme.of(context).success),
                    buildMetric('Oxygen Level', oxy,
                        FlutterFlowTheme.of(context).success),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
