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

// lib/custom_code/widgets/add_health_metric_form_cw.dart
// A modal dialog that collects a new health metric and saves it to Firestore.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddHealthMetricFormCW extends StatefulWidget {
  final double width;
  final double height;

  const AddHealthMetricFormCW({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<AddHealthMetricFormCW> createState() => _AddHealthMetricFormCWState();
}

class _AddHealthMetricFormCWState extends State<AddHealthMetricFormCW> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'BP';
  final _v1 = TextEditingController(); // systolic / HR / SpO2 / Temp
  final _v2 = TextEditingController(); // diastolic (BP)
  bool _saving = false;

  @override
  void dispose() {
    _v1.dispose();
    _v2.dispose();
    super.dispose();
  }

  String _unit(String type) {
    switch (type) {
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final type = _type;
      final value1 = double.parse(_v1.text.trim());
      final value2 = (type == 'BP' && _v2.text.trim().isNotEmpty)
          ? double.parse(_v2.text.trim())
          : null;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('vitals')
          .add({
        'type': type,
        'value1': value1,
        'value2': value2,
        'unit': _unit(type),
        'ts': FieldValue.serverTimestamp(),
      });

      if (mounted) Navigator.of(context).maybePop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBP = _type == 'BP';

    return Material(
      color: Colors.transparent,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            margin: const EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Add Health Metric',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).maybePop(false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _type,
                    items: const [
                      DropdownMenuItem(
                          value: 'BP', child: Text('Blood Pressure')),
                      DropdownMenuItem(value: 'HR', child: Text('Heart Rate')),
                      DropdownMenuItem(value: 'SpO2', child: Text('SpO₂')),
                      DropdownMenuItem(
                          value: 'Temp', child: Text('Temperature')),
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
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : const Text('Save'),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
