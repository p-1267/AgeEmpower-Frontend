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
import 'dart:async';

/// --------------------------------------------------------------------------
/// CAREGIVER TASK LIST
/// --------------------------------------------------------------------------
/// Displays tasks in sections:
///   - Today
///   - Upcoming
///   - Completed
///
/// Firestore hybrid:
///    /users/{seniorId}/tasks
///    /agencies/{agencyId}/tasks
///
/// Supports:
///  - Checking tasks off
///  - Viewing priority tags
///  - Smooth UI animations
///  - Matches AgeEmpower widget design style
/// --------------------------------------------------------------------------

class CaregiverTaskListCW extends StatefulWidget {
  final String? seniorId;
  final String? agencyId;

  final double? width;
  final double? height;

  const CaregiverTaskListCW({
    super.key,
    this.seniorId,
    this.agencyId,
    this.width,
    this.height,
  });

  @override
  State<CaregiverTaskListCW> createState() => _CaregiverTaskListCWState();
}

class _CaregiverTaskListCWState extends State<CaregiverTaskListCW> {
  StreamSubscription? _sub;
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _listenTasks();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // Firestore Path (Hybrid)
  // --------------------------------------------------------------------------
  CollectionReference<Map<String, dynamic>> _taskCollection() {
    if (widget.agencyId != null) {
      return FirebaseFirestore.instance
          .collection("agencies")
          .doc(widget.agencyId)
          .collection("tasks");
    }

    final uid = widget.seniorId ?? FirebaseAuth.instance.currentUser?.uid;

    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("tasks");
  }

  // --------------------------------------------------------------------------
  // Listen to tasks in real time
  // --------------------------------------------------------------------------
  void _listenTasks() {
    _sub = _taskCollection()
        .orderBy("dueDate", descending: false)
        .snapshots()
        .listen((snap) {
      setState(() {
        _tasks = snap.docs.map((e) => e.data()).toList();
      });
    });
  }

  // --------------------------------------------------------------------------
  // Categorization
  // --------------------------------------------------------------------------
  List<Map<String, dynamic>> get todayTasks {
    final now = DateTime.now();
    return _tasks.where((t) {
      final ts = t["dueDate"] as Timestamp?;
      if (ts == null) return false;
      final dt = ts.toDate();
      return dt.year == now.year &&
          dt.month == now.month &&
          dt.day == now.day &&
          t["completed"] != true;
    }).toList();
  }

  List<Map<String, dynamic>> get upcomingTasks {
    final now = DateTime.now();
    return _tasks.where((t) {
      final ts = t["dueDate"] as Timestamp?;
      if (ts == null) return false;
      final dt = ts.toDate();
      return dt.isAfter(now) && t["completed"] != true;
    }).toList();
  }

  List<Map<String, dynamic>> get completedTasks {
    return _tasks.where((t) => t["completed"] == true).toList();
  }

  // --------------------------------------------------------------------------
  // Marking tasks complete
  // --------------------------------------------------------------------------
  Future<void> _toggleTaskCompletion(Map<String, dynamic> task) async {
    final taskId = task["taskId"];
    if (taskId == null) return;

    await _taskCollection().doc(taskId).update({
      "completed": !(task["completed"] == true),
      "completedAt": FieldValue.serverTimestamp(),
    });
  }

  // --------------------------------------------------------------------------
  // UI BUILD
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.grey.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Caregiver Tasks",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildSection("Today", todayTasks),
          const SizedBox(height: 12),
          _buildSection("Upcoming", upcomingTasks),
          const SizedBox(height: 12),
          _buildSection("Completed", completedTasks, completed: true),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Section UI
  // --------------------------------------------------------------------------
  Widget _buildSection(String title, List<Map<String, dynamic>> tasks,
      {bool completed = false}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: completed ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: completed ? Colors.green : Colors.blue.shade200,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
              color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                completed ? "No completed tasks yet." : "No tasks here.",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          for (var task in tasks) _buildTaskCard(task, completed: completed),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Task card UI
  // --------------------------------------------------------------------------
  Widget _buildTaskCard(Map<String, dynamic> task, {bool completed = false}) {
    final title = task["title"] ?? "Untitled Task";
    final priority = task["priority"] ?? "normal";
    final caregiver = task["assignedToName"] ?? "Unassigned";

    final Timestamp? ts = task["dueDate"];
    final due = ts?.toDate();

    final priorityColor = {
          "high": Colors.red.shade300,
          "medium": Colors.orange.shade400,
          "low": Colors.blue.shade400,
          "normal": Colors.grey.shade400,
        }[priority] ??
        Colors.grey.shade400;

    String dueText =
        due != null ? "${due.year}-${due.month}-${due.day}" : "No date";

    return GestureDetector(
      onTap: () {
        // Normally open Task Editor modal here.
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: completed ? Colors.green.shade100 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: completed ? Colors.green : Colors.grey.shade400),
        ),
        child: Row(
          children: [
            // Checkbox
            GestureDetector(
              onTap: () => _toggleTaskCompletion(task),
              child: Icon(
                completed ? Icons.check_circle : Icons.radio_button_unchecked,
                color: completed ? Colors.green.shade700 : Colors.grey,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("Due: $dueText",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87)),
                  Text("Assigned to: $caregiver",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),

            // Priority indicator
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: priorityColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
