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

class AppointmentCardCW extends StatelessWidget {
  final double? width;
  final double? height;

  /// Appointment data from Firestore
  final Map<String, dynamic> appointmentData;

  /// Callback when card is tapped
  final Function(Map<String, dynamic> data)? onTap;

  const AppointmentCardCW({
    super.key,
    this.width,
    this.height,
    required this.appointmentData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final providerName = appointmentData["providerName"] ?? "Provider";
    final specialty = appointmentData["specialty"] ?? "General";
    final status = appointmentData["status"] ?? "pending";
    final Timestamp? ts = appointmentData["date"];
    final DateTime? dt = ts?.toDate();

    final dateText =
        dt != null ? "${dt.month}/${dt.day}/${dt.year}" : "Unknown date";
    final timeText =
        dt != null ? "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}" : "";

    return GestureDetector(
      onTap: () => onTap?.call(appointmentData),
      child: Container(
        width: width ?? double.infinity,
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
            _buildAvatar(),
            const SizedBox(width: 14),

            // Provider info block
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
                    "$dateText  •  $timeText",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
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
  // Avatar icon (simple hospital icon)
  // ---------------------------------------------------------------------------
  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 28,
      backgroundColor: Colors.blue.shade100,
      child: Icon(
        Icons.local_hospital,
        color: Colors.blue.shade700,
        size: 30,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Status Chip UI
  // ---------------------------------------------------------------------------
  Widget _buildStatusBadge(String status) {
    Color bg;
    switch (status) {
      case "confirmed":
        bg = Colors.green.shade600;
        break;
      case "completed":
        bg = Colors.grey.shade600;
        break;
      case "pending":
      default:
        bg = Colors.orange.shade600;
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
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
