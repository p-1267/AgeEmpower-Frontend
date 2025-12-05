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

class DailyQuickActionsCW extends StatelessWidget {
  final VoidCallback? onSOS;
  final VoidCallback? onChat;
  final VoidCallback? onMedication;
  final VoidCallback? onReports;

  const DailyQuickActionsCW({
    super.key,
    this.onSOS,
    this.onChat,
    this.onMedication,
    this.onReports,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _action(Icons.warning, "SOS", Colors.red.shade700, onSOS),
        _action(Icons.chat, "Chat", Colors.blue.shade700, onChat),
        _action(Icons.medication, "Medication", Colors.green.shade700,
            onMedication),
        _action(
            Icons.description, "Reports", Colors.purple.shade700, onReports),
      ],
    );
  }

  Widget _action(
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
            Icon(icon, size: 46, color: color),
            const SizedBox(height: 10),
            Text(label,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
