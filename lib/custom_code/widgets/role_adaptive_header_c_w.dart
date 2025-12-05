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

class RoleAdaptiveHeaderCW extends StatelessWidget {
  final String role;
  final Map<String, dynamic> userData;

  const RoleAdaptiveHeaderCW({
    super.key,
    required this.role,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    String title = "Welcome";
    String subtitle = "";

    if (role == "senior") {
      title = "Good day, ${userData["name"] ?? "Friend"}";
      subtitle = "Here’s your health & safety overview.";
    } else if (role == "family") {
      title = "Family Dashboard";
      subtitle = "Monitor your loved one's wellbeing.";
    } else if (role == "agency") {
      title = "Agency Operations";
      subtitle = "Resident alerts and caregiver performance.";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(subtitle,
            style: const TextStyle(fontSize: 16, color: Colors.black54)),
      ],
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
