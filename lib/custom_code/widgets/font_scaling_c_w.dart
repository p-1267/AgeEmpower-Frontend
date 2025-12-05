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

class FontScalingCW extends StatelessWidget {
  final double scale;

  const FontScalingCW({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: const Text(
          "This is a live preview of your font size settings.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
