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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;

class VitalsTrendCW extends StatelessWidget {
  final String type; // BP|HR|SpO2|Temp
  final int limit;
  const VitalsTrendCW({Key? key, required this.type, this.limit = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox(height: 100);

    final q = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('vitals')
        .where('type', isEqualTo: type)
        .orderBy('ts', descending: true)
        .limit(limit);

    return StreamBuilder<QuerySnapshot>(
      stream: q.snapshots(),
      builder: (ctx, snap) {
        if (!snap.hasData) {
          return const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
        }
        final docs = snap.data!.docs;
        if (docs.isEmpty)
          return const SizedBox(
              height: 120, child: Center(child: Text('No data')));
        final values = docs
            .map((d) => (d.data() as Map<String, dynamic>)['value1'])
            .whereType<num>()
            .map((e) => e.toDouble())
            .toList()
            .reversed
            .toList();
        return SizedBox(
            height: 120, child: CustomPaint(painter: _Spark(values)));
      },
    );
  }
}

class _Spark extends CustomPainter {
  final List<double> points;
  _Spark(this.points);
  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final minV = points.reduce(math.min);
    final maxV = points.reduce(math.max);
    final span = (maxV - minV) == 0 ? 1.0 : (maxV - minV);
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = i * (size.width / (points.length - 1));
      final y = size.height - ((points[i] - minV) / span) * size.height;
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.blue;
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant _Spark old) => old.points != points;
}
