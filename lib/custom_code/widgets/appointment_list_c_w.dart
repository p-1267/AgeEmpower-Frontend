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
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// ---------------------------------------------------------------------------
/// APPOINTMENT LIST WIDGET
/// ---------------------------------------------------------------------------
/// Provides:
///   - Upcoming & Past appointments tabbed list
///   - Provider card linking
///   - Appointment status badge
///   - Beautiful AgeEmpower design
///   - Senior-friendly typography
///   - Firestore Hybrid Structure (Option C)
///
/// Firestore Structure:
///   /users/{uid}/appointments/{apptId}
///   /agencies/{agencyId}/appointments/{apptId}
///
/// Required fields:
///   providerName, providerId, specialty, date, notes, status
/// ---------------------------------------------------------------------------

class AppointmentListCW extends StatefulWidget {
  final String? seniorId; // If viewing for a specific senior
  final String? agencyId; // If agency user is viewing

  final double? width;
  final double? height;

  /// When user taps appointment → parent can open profile or detail
  final Function(String appointmentId, Map<String, dynamic> data)?
      onAppointmentSelected;

  const AppointmentListCW({
    super.key,
    this.seniorId,
    this.agencyId,
    this.width,
    this.height,
    this.onAppointmentSelected,
  });

  @override
  State<AppointmentListCW> createState() => _AppointmentListCWState();
}

class _AppointmentListCWState extends State<AppointmentListCW> {
  String mode = "upcoming"; // "upcoming" or "past"

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          Expanded(child: _buildAppointmentStream()),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header tabs
  // ---------------------------------------------------------------------------
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _tabButton("Upcoming", "upcoming"),
        _tabButton("Past", "past"),
      ],
    );
  }

  Widget _tabButton(String label, String value) {
    final bool selected = mode == value;

    return GestureDetector(
      onTap: () => setState(() => mode = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade700 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? Colors.blue.shade900 : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Firestore path
  // ---------------------------------------------------------------------------
  CollectionReference<Map<String, dynamic>> _appointmentCollection() {
    if (widget.agencyId != null) {
      return FirebaseFirestore.instance
          .collection("agencies")
          .doc(widget.agencyId)
          .collection("appointments");
    }

    final uid = widget.seniorId ?? FirebaseAuth.instance.currentUser?.uid;

    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("appointments");
  }

  // ---------------------------------------------------------------------------
  // Load and filter appointments
  // ---------------------------------------------------------------------------
  Widget _buildAppointmentStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: _appointmentCollection()
          .orderBy("date", descending: mode == "past")
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snap.data!.docs;

        final now = DateTime.now();

        final filtered = docs.where((d) {
          final data = d.data() as Map<String, dynamic>;
          final ts = data["date"] as Timestamp?;
          if (ts == null) return false;

          final dt = ts.toDate();

          if (mode == "upcoming") return dt.isAfter(now);
          return dt.isBefore(now);
        }).toList();

        if (filtered.isEmpty) {
          return Center(
            child: Text(
              mode == "upcoming"
                  ? "No upcoming appointments"
                  : "No past appointments",
              style: const TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, i) {
            final doc = filtered[i];
            final apptId = doc.id;
            final data = doc.data() as Map<String, dynamic>;

            return _buildAppointmentCard(apptId, data);
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Appointment Card UI
  // ---------------------------------------------------------------------------
  Widget _buildAppointmentCard(String apptId, Map<String, dynamic> appt) {
    final String providerName = appt["providerName"] ?? "Provider";
    final String specialty = appt["specialty"] ?? "";
    final String status = appt["status"] ?? "pending";

    final Timestamp? ts = appt["date"];
    final DateTime? dt = ts?.toDate();

    final String formattedDate =
        dt != null ? "${dt.month}/${dt.day}/${dt.year}" : "Unknown date";

    final String formattedTime =
        dt != null ? "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}" : "";

    return GestureDetector(
      onTap: () => widget.onAppointmentSelected?.call(apptId, appt),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.blue.shade200),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            _buildAvatar(specialty),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    providerName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    specialty,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "$formattedDate  •  $formattedTime",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            _buildStatusBadge(status),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Avatar Bubble
  // ---------------------------------------------------------------------------
  Widget _buildAvatar(String specialty) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: Colors.blue.shade100,
      child: Icon(
        Icons.local_hospital,
        color: Colors.blue.shade700,
        size: 28,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Status Badge
  // ---------------------------------------------------------------------------
  Widget _buildStatusBadge(String status) {
    Color bg;
    Color fg;

    switch (status) {
      case "confirmed":
        bg = Colors.green.shade600;
        fg = Colors.white;
        break;
      case "completed":
        bg = Colors.grey.shade600;
        fg = Colors.white;
        break;
      case "pending":
      default:
        bg = Colors.orange.shade600;
        fg = Colors.white;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
