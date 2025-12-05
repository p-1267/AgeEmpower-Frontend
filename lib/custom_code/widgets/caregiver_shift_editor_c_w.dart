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
// DO NOT REMOVE ABOVE

// Additional imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// --------------------------------------------------------------------------
/// CAREGIVER SHIFT EDITOR
/// --------------------------------------------------------------------------
/// Allows creating & editing shifts with:
///  - Date picker
///  - Start & end time
///  - Caregiver selection
///  - Optional notes
///  - Firestore save/update/delete
///
/// Matches AgeEmpower UI design.
/// Supports:
///    /users/{seniorId}/schedules
///    /agencies/{agencyId}/schedules
/// --------------------------------------------------------------------------

class CaregiverShiftEditorCW extends StatefulWidget {
  final String? agencyId;
  final String? seniorId;

  /// If editing an existing shift
  final String? shiftId;
  final Map<String, dynamic>? existingShiftData;

  final double? width;
  final double? height;

  const CaregiverShiftEditorCW({
    super.key,
    this.agencyId,
    this.seniorId,
    this.width,
    this.height,
    this.shiftId,
    this.existingShiftData,
  });

  @override
  State<CaregiverShiftEditorCW> createState() => _CaregiverShiftEditorCWState();
}

class _CaregiverShiftEditorCWState extends State<CaregiverShiftEditorCW> {
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  String? caregiverId;
  String caregiverName = "Select Caregiver";

  TextEditingController notesCtrl = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();

    if (widget.existingShiftData != null) {
      final data = widget.existingShiftData!;
      final ts = data["date"] as Timestamp?;

      selectedDate = ts?.toDate() ?? DateTime.now();

      final String timeRange = data["timeRange"] ?? "09:00 - 17:00";
      final parts = timeRange.split("-");
      startTime = _parseTime(parts[0].trim());
      endTime = _parseTime(parts[1].trim());

      caregiverId = data["caregiverId"];
      caregiverName = data["caregiverName"] ?? "Caregiver";
      notesCtrl.text = data["notes"] ?? "";
    }
  }

  TimeOfDay _parseTime(String s) {
    final parts = s.split(":");
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  // ------------------------ Firestore Path ------------------------
  CollectionReference<Map<String, dynamic>> _scheduleCollection() {
    if (widget.agencyId != null) {
      return FirebaseFirestore.instance
          .collection("agencies")
          .doc(widget.agencyId)
          .collection("schedules");
    }
    final uid = widget.seniorId ?? FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("schedules");
  }

  // ------------------------ Pickers ------------------------
  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? today,
      firstDate: today.subtract(const Duration(days: 365)),
      lastDate: today.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: startTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) setState(() => startTime = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: endTime ?? const TimeOfDay(hour: 17, minute: 0),
    );
    if (picked != null) setState(() => endTime = picked);
  }

  // ------------------------ Save ------------------------
  Future<void> _saveShift() async {
    if (selectedDate == null ||
        startTime == null ||
        endTime == null ||
        caregiverId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() => loading = true);

    final String timeRange =
        "${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')} - "
        "${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}";

    final data = {
      "date": Timestamp.fromDate(selectedDate!),
      "timeRange": timeRange,
      "caregiverId": caregiverId,
      "caregiverName": caregiverName,
      "notes": notesCtrl.text.trim(),
      "updatedAt": FieldValue.serverTimestamp(),
    };

    try {
      if (widget.shiftId == null) {
        // Create new shift
        final id = _scheduleCollection().doc().id;
        await _scheduleCollection().doc(id).set({
          "shiftId": id,
          ...data,
          "createdAt": FieldValue.serverTimestamp(),
        });
      } else {
        // Update existing
        await _scheduleCollection().doc(widget.shiftId).update(data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Shift saved successfully")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }

    setState(() => loading = false);
  }

  // ------------------------ Delete ------------------------
  Future<void> _deleteShift() async {
    if (widget.shiftId == null) return;

    await _scheduleCollection().doc(widget.shiftId).delete();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Shift deleted.")),
      );
    }
  }

  // ------------------------ Caregiver Picker ------------------------
  Future<void> _selectCaregiver() async {
    // In a real app, you will fetch caregivers from:
    // /agencies/{agencyId}/caregivers OR /users/{seniorId}/caregivers
    // For now, we simulate with a modal list.

    final caregivers = [
      {"id": "c1", "name": "John"},
      {"id": "c2", "name": "Sara"},
      {"id": "c3", "name": "Nurse Kelly"},
    ];

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: caregivers
                .map(
                  (c) => ListTile(
                    title: Text(c["name"]!),
                    onTap: () {
                      setState(() {
                        caregiverId = c["id"];
                        caregiverName = c["name"]!;
                      });
                      Navigator.pop(ctx);
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  // ------------------------ UI ------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
              color: Color(0x22000000), blurRadius: 12, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Shift Editor",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 20),

          // Date
          _buildRow(
            label: "Date",
            value: selectedDate != null
                ? "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}"
                : "Select Date",
            onTap: _pickDate,
          ),

          // Time Range
          _buildRow(
            label: "Start Time",
            value: startTime != null ? startTime!.format(context) : "Select",
            onTap: _pickStartTime,
          ),
          _buildRow(
            label: "End Time",
            value: endTime != null ? endTime!.format(context) : "Select",
            onTap: _pickEndTime,
          ),

          // Caregiver picker
          _buildRow(
            label: "Caregiver",
            value: caregiverName,
            onTap: _selectCaregiver,
          ),

          const SizedBox(height: 16),
          const Text("Notes",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),

          TextField(
            controller: notesCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Save button
          ElevatedButton(
            onPressed: loading ? null : _saveShift,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.blue.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Save Shift",
                    style: TextStyle(fontSize: 18),
                  ),
          ),

          // Delete button (edit mode)
          if (widget.shiftId != null) ...[
            const SizedBox(height: 10),
            TextButton(
              onPressed: _deleteShift,
              child: const Text(
                "Delete Shift",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
