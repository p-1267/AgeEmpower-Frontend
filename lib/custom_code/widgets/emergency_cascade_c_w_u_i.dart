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

class EmergencyCascadeCWUI extends StatelessWidget {
  const EmergencyCascadeCWUI({
    super.key,
    required this.isEmergencyActive,
    required this.countdownActive,
    required this.countdownSeconds,
    required this.onSOSPressed,
    required this.onCancelPressed,
  });

  final bool isEmergencyActive;
  final bool countdownActive;
  final int countdownSeconds;

  final VoidCallback onSOSPressed;
  final VoidCallback onCancelPressed;

  @override
  Widget build(BuildContext context) {
    return isEmergencyActive
        ? _buildEmergencyActiveUI(context)
        : _buildIdleUI(context);
  }

  // --------------------------------------------------------
  // IDLE UI — Big red SOS button (senior friendly)
  // --------------------------------------------------------
  Widget _buildIdleUI(BuildContext context) {
    return Center(
      child: GestureDetector(
        onLongPress: onSOSPressed,
        child: Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red.shade700,
            boxShadow: [
              BoxShadow(
                color: Colors.red.shade300,
                blurRadius: 30,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              "HOLD FOR SOS",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------
  // ACTIVE EMERGENCY VIEW
  // --------------------------------------------------------
  Widget _buildEmergencyActiveUI(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      color: Colors.red.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "EMERGENCY ACTIVE",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade800,
            ),
          ),
          const SizedBox(height: 20),
          if (countdownActive)
            Text(
              "Escalating in $countdownSeconds seconds…",
              style: TextStyle(
                fontSize: 24,
                color: Colors.red.shade700,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Text(
              "Emergency Cascade In Progress…",
              style: TextStyle(
                fontSize: 24,
                color: Colors.red.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          const SizedBox(height: 40),
          SizedBox(
            width: 240,
            child: ElevatedButton(
              onPressed: onCancelPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                "I’M SAFE — CANCEL",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Icon(
            Icons.warning_rounded,
            color: Colors.red.shade400,
            size: 80,
          ),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
