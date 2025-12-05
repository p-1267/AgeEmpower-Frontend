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

// AUTOMATIC FLUTTERFLOW IMPORTS — DO NOT REMOVE
import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

// CUSTOM IMPORTS
import 'dart:convert';
import 'package:http/http.dart' as http;

class MedicationAutoFillCW extends StatefulWidget {
  final double? width;
  final double? height;

  // Callback sends selected drug info back to parent
  final Function(Map<String, dynamic>)? onSelected;

  const MedicationAutoFillCW({
    Key? key,
    this.width,
    this.height,
    this.onSelected,
  }) : super(key: key);

  @override
  State<MedicationAutoFillCW> createState() => _MedicationAutoFillCWState();
}

class _MedicationAutoFillCWState extends State<MedicationAutoFillCW> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _loading = false;
  List<dynamic> _results = [];

  final String _searchUrl = "https://YOUR_BACKEND_DOMAIN.com/api/drugdb/search";

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _searchDrugs() async {
    final q = _searchCtrl.text.trim();
    if (q.isEmpty) return;

    setState(() {
      _loading = true;
      _results = [];
    });

    try {
      final uri = Uri.parse(_searchUrl);
      final resp = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"query": q}),
      );

      if (resp.statusCode != 200) {
        _showToast("Error ${resp.statusCode}");
        setState(() => _loading = false);
        return;
      }

      final json = jsonDecode(resp.body);
      _results = json["results"] ?? [];
    } catch (e) {
      _showToast("Error: $e");
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Auto-Fill Medication",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _buildSearchBar(),
          const SizedBox(height: 16),
          if (_loading) const Center(child: CircularProgressIndicator()),
          if (!_loading) _buildResultsList(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchCtrl,
            decoration: const InputDecoration(
              labelText: "Search drug name...",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _searchDrugs(),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _searchDrugs,
          child: const Text("Search"),
        ),
      ],
    );
  }

  Widget _buildResultsList() {
    if (_results.isEmpty) {
      return const Text(
        "Start by searching medication name above.",
        style: TextStyle(color: Colors.grey),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final d = _results[i];

        final name = d["name"] ?? "";
        final form = d["form"] ?? "";
        final strength = d["strength"] ?? "";
        final typicalDosage = d["typicalDosage"] ?? "";
        final frequency = d["frequency"] ?? "";

        return Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title:
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle:
                Text("$form • $strength\nTypical: $typicalDosage • $frequency"),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.blue),
              onPressed: () {
                if (widget.onSelected != null) {
                  widget.onSelected!({
                    "name": name,
                    "form": form,
                    "strength": strength,
                    "dosage": typicalDosage,
                    "frequency": frequency,
                  });
                }
                _showToast("Medication info applied.");
              },
            ),
          ),
        );
      },
    );
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
