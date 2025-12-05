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

// lib/custom_code/widgets/recent_readings_cw.dart
// Lists recent vitals for a given type.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecentReadingsCW extends StatelessWidget {
  final String type; // BP | HR | SpO2 | Temp
  final int limit;

  const RecentReadingsCW({
    Key? key,
    required this.type,
    this.limit = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Text('Sign in to see readings');
    }
    final q = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('vitals')
        .where('type', isEqualTo: type)
        .orderBy('ts', descending: true)
        .limit(limit);

    return StreamBuilder<QuerySnapshot>(
      stream: q.snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Padding(
              padding: EdgeInsets.all(12), child: LinearProgressIndicator());
        }
        if (snap.hasError) {
          return Text('Error: ${snap.error}');
        }
        final docs = snap.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Text('No readings yet.'),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, i) {
            final d = docs[i].data() as Map<String, dynamic>;
            final v1 = d['value1'];
            final v2 = d['value2'];
            final unit = d['unit'] ?? '';
            final ts = (d['ts'] as Timestamp?)?.toDate();
            final when = ts != null
                ? '${ts.year}/${ts.month}/${ts.day} ${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}'
                : '';
            final value =
                (type == 'BP' && v2 != null) ? '$v1/$v2 $unit' : '$v1 $unit';
            return ListTile(
              leading: const Icon(Icons.favorite_outline),
              title: Text(value),
              subtitle: Text(when),
            );
          },
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemCount: docs.length,
        );
      },
    );
  }
}
