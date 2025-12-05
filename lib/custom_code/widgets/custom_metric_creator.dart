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
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomMetricCreator extends StatefulWidget {
  final double? width;
  final double? height;

  const CustomMetricCreator({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<CustomMetricCreator> createState() => _CustomMetricCreatorState();
}

class _CustomMetricCreatorState extends State<CustomMetricCreator> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _unitCtrl = TextEditingController();
  final TextEditingController _minCtrl = TextEditingController();
  final TextEditingController _maxCtrl = TextEditingController();
  final TextEditingController _ageCtrl = TextEditingController();

  bool _isNumeric = true;
  bool _loading = false;
  String? _aiMessage;
  String? _editingMetricId;

  static const String _aiBaseUrl = "https://YOUR-BACKEND-DOMAIN.com";

  CollectionReference<Map<String, dynamic>>? _metricsRef() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("metrics")
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snap, _) => snap.data()!,
          toFirestore: (map, _) => map,
        );
  }

  Future<void> _getAISuggestion() async {
    if (_nameCtrl.text.isEmpty || _unitCtrl.text.isEmpty) {
      setState(() => _aiMessage = "Enter name + unit first.");
      return;
    }

    setState(() {
      _loading = true;
      _aiMessage = null;
    });

    try {
      final age = int.tryParse(_ageCtrl.text.trim());

      final uri = Uri.parse("$_aiBaseUrl/api/ai/metrics/suggest-range");

      final resp = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "metricName": _nameCtrl.text,
          "unit": _unitCtrl.text,
          if (age != null) "age": age,
        }),
      );

      final data = jsonDecode(resp.body);

      if (data["min"] != null) _minCtrl.text = data["min"].toString();
      if (data["max"] != null) _maxCtrl.text = data["max"].toString();

      setState(() {
        _aiMessage = "AI suggestion applied.";
      });
    } catch (e) {
      setState(() => _aiMessage = "AI Error: $e");
    }

    setState(() => _loading = false);
  }

  Future<void> _saveMetric() async {
    final ref = _metricsRef();
    if (ref == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Not logged in")));
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    double? min = _isNumeric ? double.tryParse(_minCtrl.text.trim()) : null;
    double? max = _isNumeric ? double.tryParse(_maxCtrl.text.trim()) : null;

    final data = {
      "name": _nameCtrl.text.trim(),
      "unit": _unitCtrl.text.trim(),
      "isNumeric": _isNumeric,
      "minValue": min,
      "maxValue": max,
      "createdAt": FieldValue.serverTimestamp(),
    };

    try {
      if (_editingMetricId == null) {
        await ref.add(data);
      } else {
        await ref.doc(_editingMetricId).update(data);
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              _editingMetricId == null ? "Metric created" : "Metric updated")));

      setState(() {
        _editingMetricId = null;
        _nameCtrl.clear();
        _unitCtrl.clear();
        _minCtrl.clear();
        _maxCtrl.clear();
        _ageCtrl.clear();
        _aiMessage = null;
        _isNumeric = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => _loading = false);
  }

  Future<void> _delete(String id) async {
    final ref = _metricsRef();
    if (ref == null) return;

    await ref.doc(id).delete();

    if (_editingMetricId == id) {
      setState(() {
        _editingMetricId = null;
        _nameCtrl.clear();
        _unitCtrl.clear();
        _minCtrl.clear();
        _maxCtrl.clear();
      });
    }
  }

  void _edit(String id, Map<String, dynamic> data) {
    setState(() {
      _editingMetricId = id;
      _nameCtrl.text = data["name"] ?? "";
      _unitCtrl.text = data["unit"] ?? "";
      _isNumeric = data["isNumeric"] ?? true;
      _minCtrl.text = data["minValue"]?.toString() ?? "";
      _maxCtrl.text = data["maxValue"]?.toString() ?? "";
      _aiMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Center(child: Text("Please sign in."));
    }

    final metricsRef = _metricsRef();

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          // ---- FORM ----
          Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  _editingMetricId == null
                      ? "Create Custom Metric"
                      : "Edit Custom Metric",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: "Metric Name"),
                  validator: (v) => v == null || v.isEmpty ? "Required" : null,
                ),
                TextFormField(
                  controller: _unitCtrl,
                  decoration: const InputDecoration(labelText: "Unit"),
                  validator: (v) => v == null || v.isEmpty ? "Required" : null,
                ),
                TextFormField(
                  controller: _ageCtrl,
                  decoration: const InputDecoration(
                      labelText: "Age (for AI, optional)"),
                  keyboardType: TextInputType.number,
                ),
                SwitchListTile(
                  title: const Text("Numeric Metric?"),
                  value: _isNumeric,
                  onChanged: (v) => setState(() => _isNumeric = v),
                ),
                if (_isNumeric)
                  Column(
                    children: [
                      TextFormField(
                        controller: _minCtrl,
                        decoration: const InputDecoration(labelText: "Min"),
                      ),
                      TextFormField(
                        controller: _maxCtrl,
                        decoration: const InputDecoration(labelText: "Max"),
                      ),
                    ],
                  ),
                if (_aiMessage != null)
                  Text(_aiMessage!,
                      style: const TextStyle(color: Colors.deepPurple)),
                if (_loading)
                  const CircularProgressIndicator()
                else
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _getAISuggestion,
                          child: const Text("AI Suggest"),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveMetric,
                          child: Text(
                              _editingMetricId == null ? "Save" : "Update"),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ---- LIST ----
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: metricsRef
                  ?.orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data!.docs;
                if (docs.isEmpty) {
                  return const Center(child: Text("No metrics yet."));
                }
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final doc = docs[i];
                    final data = doc.data();
                    return ListTile(
                      title: Text(data["name"] ?? ""),
                      subtitle: Text(
                          "${data["minValue"] ?? '-'} - ${data["maxValue"] ?? '-'} ${data["unit"]}"),
                      onTap: () => _edit(doc.id, data),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _delete(doc.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
