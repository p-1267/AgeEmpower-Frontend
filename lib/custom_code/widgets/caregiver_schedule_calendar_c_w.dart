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

import '/flutter_flow/custom_functions.dart';
// DO NOT REMOVE ABOVE LINE — REQUIRED FOR FLUTTERFLOW CUSTOM WIDGETS

// -----------------------------------------------------------------------------
// Additional imports
// -----------------------------------------------------------------------------
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

/// ---------------------------------------------------------------------------
/// CAREGIVER SCHEDULE CALENDAR (Hybrid Month + Weekly Detail)
/// ---------------------------------------------------------------------------
/// Features:
///  - Month view with visual dots for scheduled shifts
///  - Tap any day -> Weekly detail view
///  - Weekly view shows shifts, tasks, and caregivers
///  - Firestore hybrid structure (users + agencies)
///  - Senior-friendly design, matches your existing widgets
/// ---------------------------------------------------------------------------

class CaregiverScheduleCalendarCW extends StatefulWidget {
  final double? width;
  final double? height;

  /// If viewing as an agency:
  /// pass agencyId (Firestore: /agencies/{agencyId}/schedules)
  final String? agencyId;

  /// If viewing as a senior or caregiver:
  /// schedules load from /users/{uid}/schedules
  final String? seniorId;

  const CaregiverScheduleCalendarCW({
    super.key,
    this.width,
    this.height,
    this.agencyId,
    this.seniorId,
  });

  @override
  State<CaregiverScheduleCalendarCW> createState() =>
      _CaregiverScheduleCalendarCWState();
}

class _CaregiverScheduleCalendarCWState
    extends State<CaregiverScheduleCalendarCW> {
  DateTime _focusedMonth = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  StreamSubscription? _sub;
  List<Map<String, dynamic>> _schedules = [];

  @override
  void initState() {
    super.initState();
    _listenSchedules();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Determine Firestore path based on agency vs senior
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // Listen to schedule changes
  // ---------------------------------------------------------------------------
  void _listenSchedules() {
    _sub = _scheduleCollection()
        .orderBy("date", descending: false)
        .snapshots()
        .listen((snap) {
      setState(() {
        _schedules = snap.docs.map((e) => e.data()).toList();
      });
    });
  }

  // ---------------------------------------------------------------------------
  // Helpers for calendar display
  // ---------------------------------------------------------------------------
  bool _hasSchedule(DateTime day) {
    return _schedules.any((s) {
      final ts = s["date"] as Timestamp?;
      if (ts == null) return false;
      final dt = ts.toDate();
      return dt.year == day.year && dt.month == day.month && dt.day == day.day;
    });
  }

  List<Map<String, dynamic>> _getWeekShifts(DateTime day) {
    final monday = day.subtract(Duration(days: day.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));

    return _schedules.where((s) {
      final ts = s["date"] as Timestamp?;
      if (ts == null) return false;
      final dt = ts.toDate();
      return dt.isAfter(monday.subtract(const Duration(seconds: 1))) &&
          dt.isBefore(sunday.add(const Duration(days: 1)));
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // UI BUILDING
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 10),
          _buildMonthView(),
          const SizedBox(height: 20),
          _buildWeeklyDetailView(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header (Month name + arrows)
  // ---------------------------------------------------------------------------
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
          onPressed: () => setState(() {
            _focusedMonth = DateTime(
                _focusedMonth.year, _focusedMonth.month - 1, _focusedMonth.day);
          }),
        ),
        Text(
          "${_monthName(_focusedMonth.month)} ${_focusedMonth.year}",
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, size: 30),
          onPressed: () => setState(() {
            _focusedMonth = DateTime(
                _focusedMonth.year, _focusedMonth.month + 1, _focusedMonth.day);
          }),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Month Grid
  // ---------------------------------------------------------------------------
  Widget _buildMonthView() {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final firstWeekday = firstDay.weekday;

    final daysInMonth =
        DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);

    final totalGridCells = daysInMonth + (firstWeekday - 1);
    final rows = (totalGridCells / 7).ceil();

    return Column(
      children: [
        // Weekday labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
              .map((d) => Expanded(
                  child: Center(
                      child: Text(d,
                          style:
                              const TextStyle(fontWeight: FontWeight.w600)))))
              .toList(),
        ),
        const SizedBox(height: 8),

        // Calendar cells
        for (int r = 0; r < rows; r++)
          Row(
            children: [
              for (int c = 0; c < 7; c++)
                Expanded(child: _buildCalendarCell(r, c, firstWeekday)),
            ],
          ),
      ],
    );
  }

  Widget _buildCalendarCell(int r, int c, int firstWeekday) {
    final index = r * 7 + c;
    final dayNum = index - (firstWeekday - 2);

    if (dayNum < 1 ||
        dayNum >
            DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month)) {
      return Container(height: 46); // Empty cell
    }

    final date = DateTime(_focusedMonth.year, _focusedMonth.month, dayNum);
    final isSelected = date.year == _selectedDay.year &&
        date.month == _selectedDay.month &&
        date.day == _selectedDay.day;

    final hasSchedule = _hasSchedule(date);

    return GestureDetector(
      onTap: () => setState(() => _selectedDay = date),
      child: Container(
        height: 46,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade300),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                "$dayNum",
                style: const TextStyle(fontSize: 16),
              ),
            ),
            if (hasSchedule)
              Positioned(
                bottom: 4,
                left: 0,
                right: 0,
                child: Icon(Icons.circle, size: 7, color: Colors.blue.shade700),
              )
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Weekly Detail View
  // ---------------------------------------------------------------------------
  Widget _buildWeeklyDetailView() {
    final weekShifts = _getWeekShifts(_selectedDay);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Weekly Schedule",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (weekShifts.isEmpty)
            const Text("No shifts this week.",
                style: TextStyle(fontSize: 16, color: Colors.black54)),
          for (var shift in weekShifts) _buildShiftCard(shift),
        ],
      ),
    );
  }

  Widget _buildShiftCard(Map<String, dynamic> shift) {
    final caregiver = shift["caregiverName"] ?? "Caregiver";
    final time = shift["timeRange"] ?? "Time TBA";
    final notes = shift["notes"] ?? "";

    final ts = shift["date"] as Timestamp?;
    final dt = ts?.toDate();
    final formatted =
        dt != null ? "${dt.year}-${dt.month}-${dt.day}" : "Unknown date";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(caregiver,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(time, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Text("Date: $formatted",
              style: const TextStyle(fontSize: 14, color: Colors.black54)),
          if (notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text("Notes: $notes",
                style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ]
        ],
      ),
    );
  }

  // Helpers
  String _monthName(int m) {
    const names = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return names[m];
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
