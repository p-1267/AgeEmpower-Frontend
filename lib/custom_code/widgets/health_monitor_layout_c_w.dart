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

// Begin custom widget code (put this right after the auto header)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;

class HealthMonitorLayoutCW extends StatefulWidget {
  final double width;
  final double height;

  const HealthMonitorLayoutCW({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<HealthMonitorLayoutCW> createState() => _HealthMonitorLayoutCWState();
}

class _HealthMonitorLayoutCWState extends State<HealthMonitorLayoutCW> {
  String selectedType = 'BP'; // BP | HR | SpO2 | Temp

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: user == null
          ? const Center(child: Text('Please sign in to view vitals.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // TOP ACTIONS: Add Reading + Custom Metrics
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => _openAddReadingSheet(context),
                          child: const Text('Add Reading'),
                        ),
                        const SizedBox(height: 12),
                        // NEW BUTTON – opens Custom Metric Creator page
                        ElevatedButton.icon(
                          icon: const Icon(Icons.analytics_outlined),
                          label: const Text('Custom Metrics'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                          ),
                          onPressed: () {
                            // Use FlutterFlow navigation by page name
                            context.pushNamed('CustomMetricCreator');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  _TypeTabs(
                    value: selectedType,
                    onChanged: (v) => setState(() => selectedType = v),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trend (${_labelFor(selectedType)})',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _Trend(type: selectedType, limit: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Recent',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  _RecentList(type: selectedType, limit: 10),
                ],
              ),
            ),
    );
  }

  Future<void> _openAddReadingSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _AddReadingSheet(),
            ),
          ),
        );
      },
    );
    if (mounted) setState(() {}); // StreamBuilders auto-refresh
  }

  String _labelFor(String t) {
    switch (t) {
      case 'BP':
        return 'Blood Pressure';
      case 'HR':
        return 'Heart Rate';
      case 'SpO2':
        return 'SpO₂';
      case 'Temp':
        return 'Temperature';
      default:
        return t;
    }
  }
}

// ---- Add Reading Sheet ----

class _AddReadingSheet extends StatefulWidget {
  @override
  State<_AddReadingSheet> createState() => _AddReadingSheetState();
}

class _AddReadingSheetState extends State<_AddReadingSheet> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'BP';
  final _v1 = TextEditingController();
  final _v2 = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _v1.dispose();
    _v2.dispose();
    super.dispose();
  }

  String _unit(String t) {
    switch (t) {
      case 'BP':
        return 'mmHg';
      case 'HR':
        return 'bpm';
      case 'SpO2':
        return '%';
      case 'Temp':
        return '°C';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBP = _type == 'BP';

    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Add Health Reading',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _type,
              items: const [
                DropdownMenuItem(value: 'BP', child: Text('Blood Pressure')),
                DropdownMenuItem(value: 'HR', child: Text('Heart Rate')),
                DropdownMenuItem(value: 'SpO2', child: Text('SpO₂')),
                DropdownMenuItem(value: 'Temp', child: Text('Temperature')),
              ],
              onChanged: (v) => setState(() => _type = v ?? 'BP'),
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _v1,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: isBP ? 'Systolic' : 'Value',
                suffixText: _unit(_type),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            if (isBP) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _v2,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Diastolic'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
            ),
            const SizedBox(height: 4),
          ]),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _saving = true);
    try {
      final value1 = double.parse(_v1.text.trim());
      final value2 = _type == 'BP' ? double.parse(_v2.text.trim()) : null;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('vitals')
          .add({
        'type': _type,
        'value1': value1,
        'value2': value2,
        'unit': _unit(_type),
        'ts': FieldValue.serverTimestamp(),
      });

      if (mounted) Navigator.of(context).maybePop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

// ---- Trend (sparkline) ----

class _Trend extends StatelessWidget {
  final String type;
  final int limit;
  const _Trend({Key? key, required this.type, this.limit = 20})
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
        if (snap.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        final docs = snap.data?.docs ?? [];
        if (docs.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text('No data')),
          );
        }
        final values = docs
            .map((d) => (d.data() as Map<String, dynamic>)['value1'])
            .whereType<num>()
            .toList()
            .reversed
            .map((e) => e.toDouble())
            .toList();

        return SizedBox(
          height: 120,
          child: CustomPaint(painter: _Spark(values)),
        );
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
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.blue;
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant _Spark old) => old.points != points;
}

// ---- Recent list ----

class _RecentList extends StatelessWidget {
  final String type;
  final int limit;
  const _RecentList({Key? key, required this.type, this.limit = 10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    final q = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('vitals')
        .where('type', isEqualTo: type)
        .orderBy('ts', descending: true)
        .limit(limit);

    return StreamBuilder<QuerySnapshot>(
      stream: q.snapshots(),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(8),
            child: LinearProgressIndicator(),
          );
        }
        final docs = snap.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8),
            child: Text('No recent readings.'),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final d = docs[i].data() as Map<String, dynamic>;
            final v1 = d['value1'];
            final v2 = d['value2'];
            final unit = (d['unit'] ?? '').toString();
            final ts = (d['ts'] as Timestamp?)?.toDate();
            final when = ts != null
                ? '${ts.year}/${ts.month}/${ts.day} ${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}'
                : '';
            final value =
                (type == 'BP' && v2 != null) ? '$v1/$v2 $unit' : '$v1 $unit';
            return ListTile(
              leading: const Icon(Icons.monitor_heart_outlined),
              title: Text(value),
              subtitle: Text(when),
            );
          },
        );
      },
    );
  }
}

// ---- Segmented tabs ----

class _TypeTabs extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _TypeTabs({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = const ['BP', 'HR', 'SpO2', 'Temp'];
    return Wrap(
      spacing: 8,
      children: items.map((t) {
        final selected = value == t;
        return ChoiceChip(
          label: Text(t == 'SpO2' ? 'SpO₂' : t),
          selected: selected,
          onSelected: (_) => onChanged(t),
        );
      }).toList(),
    );
  }
}
