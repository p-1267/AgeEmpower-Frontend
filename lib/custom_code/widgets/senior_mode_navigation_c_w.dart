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

class SeniorModeNavigationCW extends StatelessWidget {
  final VoidCallback? onSOS;
  final VoidCallback? onCallFamily;
  final VoidCallback? onMedication;
  final VoidCallback? onReports;

  const SeniorModeNavigationCW({
    super.key,
    this.onSOS,
    this.onCallFamily,
    this.onMedication,
    this.onReports,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      children: [
        _bigButton(Icons.warning, "SOS", Colors.red.shade700, onSOS),
        _bigButton(Icons.family_restroom, "Family", Colors.blue.shade700,
            onCallFamily),
        _bigButton(Icons.medication, "Medication", Colors.green.shade700,
            onMedication),
        _bigButton(
            Icons.description, "Reports", Colors.purple.shade700, onReports),
      ],
    );
  }

  Widget _bigButton(
      IconData icon, String label, Color color, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 60),
            const SizedBox(height: 12),
            Text(label,
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
