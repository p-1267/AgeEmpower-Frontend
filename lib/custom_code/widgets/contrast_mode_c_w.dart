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

class ContrastModeCW extends StatelessWidget {
  final bool enabled;

  const ContrastModeCW({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    final bg = enabled ? Colors.black : Colors.white;
    final fg = enabled ? Colors.yellow : Colors.black87;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: fg, width: 2),
      ),
      child: Text(
        "High Contrast Preview",
        style: TextStyle(color: fg, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
