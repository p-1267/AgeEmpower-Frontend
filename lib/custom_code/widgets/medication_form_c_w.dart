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

// CUSTOM IMPORTS (FIXED)
import '/custom_code/widgets/medication_auto_fill_c_w.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicationFormCW extends StatefulWidget {
  final double? width;
  final double? height;

  final String? medId; // null = add new

  const MedicationFormCW({
    Key? key,
    this.width,
    this.height,
    this.medId,
  }) : super(key: key);

  @override
  State<MedicationFormCW> createState() => _MedicationFormCWState();
}

class _MedicationFormCWState extends State<MedicationFormCW> {
  // Controllers
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _dosageCtrl = TextEditingController();
  final TextEditingController _strengthCtrl = TextEditingController();
  final TextEditingController _formCtrl = TextEditingController();
  final TextEditingController _remainingCtrl = TextEditingController();
  final TextEditingController _lowThresholdCtrl = TextEditingController();
  final TextEditingController _pharmacyNameCtrl = TextEditingController();
  final TextEditingController _pharmacyPhoneCtrl = TextEditingController();
  final TextEditingController _doctorNameCtrl = TextEditingController();
  final TextEditingController _doctorPhoneCtrl = TextEditingController();
  final TextEditingController _notesCtrl = TextEditingController();

  List<String> schedule = [];

  bool active = true;
  bool ongoing = true;
  bool loading = false;
  bool editing = false;

  @override
  void initState() {
    super.initState();
    editing = widget.medId != null;

    if (editing) {
      _load();
    } else {
      _remainingCtrl.text = "30";
      _lowThresholdCtrl.text = "5";
    }
  }

  Future<void> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("medications")
        .doc(widget.medId)
        .get();

    if (!doc.exists) return;

    final d = doc.data() ?? {};

    _nameCtrl.text = d["name"] ?? "";
    _dosageCtrl.text = d["dosage"] ?? "";
    _strengthCtrl.text = d["strength"] ?? "";
    _formCtrl.text = d["form"] ?? "";
    _remainingCtrl.text = (d["remaining"] ?? 0).toString();
    _lowThresholdCtrl.text = (d["lowThreshold"] ?? 5).toString();

    _pharmacyNameCtrl.text = d["pharmacyName"] ?? "";
    _pharmacyPhoneCtrl.text = d["pharmacyPhone"] ?? "";
    _doctorNameCtrl.text = d["doctorName"] ?? "";
    _doctorPhoneCtrl.text = d["doctorPhone"] ?? "";
    _notesCtrl.text = d["notes"] ?? "";

    schedule = List<String>.from(d["schedule"] ?? []);
    active = d["active"] ?? true;
    ongoing = d["ongoing"] ?? true;
    setState(() {});
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dosageCtrl.dispose();
    _strengthCtrl.dispose();
    _formCtrl.dispose();
    _remainingCtrl.dispose();
    _lowThresholdCtrl.dispose();
    _pharmacyNameCtrl.dispose();
    _pharmacyPhoneCtrl.dispose();
    _doctorNameCtrl.dispose();
    _doctorPhoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.width ?? MediaQuery.of(context).size.width;

    return SizedBox(
      width: w,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              editing ? "Edit Medication" : "Add Medication",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),

            // -------- AUTO-FILL MODULE (NOW WORKING) --------
            MedicationAutoFillCW(
              onSelected: (data) {
                _nameCtrl.text = data["name"] ?? "";
                _formCtrl.text = data["form"] ?? "";
                _strengthCtrl.text = data["strength"] ?? "";
                _dosageCtrl.text = data["dosage"] ?? "";
              },
            ),

            const SizedBox(height: 24),

            _field(_nameCtrl, "Name"),
            const SizedBox(height: 12),
            _field(_dosageCtrl, "Dosage (e.g. 1 tablet)"),
            const SizedBox(height: 12),
            _field(_strengthCtrl, "Strength (e.g. 20 mg)"),
            const SizedBox(height: 12),
            _field(_formCtrl, "Form (Tablet, Capsule, etc.)"),

            const SizedBox(height: 24),
            _buildScheduleSection(),

            const SizedBox(height: 24),

            _field(_remainingCtrl, "Remaining Pills",
                type: TextInputType.number),
            const SizedBox(height: 12),
            _field(_lowThresholdCtrl, "Low Refill Threshold",
                type: TextInputType.number),

            const SizedBox(height: 24),

            _field(_pharmacyNameCtrl, "Pharmacy Name"),
            const SizedBox(height: 12),
            _field(_pharmacyPhoneCtrl, "Pharmacy Phone",
                type: TextInputType.phone),

            const SizedBox(height: 12),
            _field(_doctorNameCtrl, "Prescriber Name"),
            const SizedBox(height: 12),
            _field(_doctorPhoneCtrl, "Prescriber Phone",
                type: TextInputType.phone),

            const SizedBox(height: 24),
            _field(_notesCtrl, "Notes", maxLines: 4),

            const SizedBox(height: 24),

            SwitchListTile(
              value: active,
              title: const Text("Active"),
              onChanged: (v) => setState(() => active = v),
            ),

            SwitchListTile(
              value: ongoing,
              title: const Text("Ongoing Treatment"),
              onChanged: (v) => setState(() => ongoing = v),
            ),

            const SizedBox(height: 20),

            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 54)),
                    child: Text(
                      editing ? "Update Medication" : "Save Medication",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label,
      {int maxLines = 1, TextInputType type = TextInputType.text}) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      keyboardType: type,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
    );
  }

  // SCHEDULE PICKER
  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Daily Schedule",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          children: schedule
              .map((t) => Chip(
                    label: Text(t),
                    onDeleted: () {
                      setState(() => schedule.remove(t));
                    },
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _pickTime,
          icon: const Icon(Icons.access_time),
          label: const Text("Add Time"),
        ),
      ],
    );
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t == null) return;

    final formatted =
        "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

    setState(() => schedule.add(formatted));
  }

  Future<void> _save() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => loading = true);

    final map = {
      "name": _nameCtrl.text.trim(),
      "dosage": _dosageCtrl.text.trim(),
      "strength": _strengthCtrl.text.trim(),
      "form": _formCtrl.text.trim(),
      "remaining": int.tryParse(_remainingCtrl.text) ?? 0,
      "lowThreshold": int.tryParse(_lowThresholdCtrl.text) ?? 5,
      "schedule": schedule,
      "pharmacyName": _pharmacyNameCtrl.text.trim(),
      "pharmacyPhone": _pharmacyPhoneCtrl.text.trim(),
      "doctorName": _doctorNameCtrl.text.trim(),
      "doctorPhone": _doctorPhoneCtrl.text.trim(),
      "notes": _notesCtrl.text.trim(),
      "active": active,
      "ongoing": ongoing,
      "updatedAt": FieldValue.serverTimestamp(),
    };

    final medsRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("medications");

    try {
      if (editing) {
        await medsRef.doc(widget.medId).update(map);
      } else {
        await medsRef.add({
          ...map,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }

    setState(() => loading = false);
  }
}
