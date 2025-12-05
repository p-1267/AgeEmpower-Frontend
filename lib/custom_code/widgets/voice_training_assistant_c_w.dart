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

// Automatic FF imports…

class VoiceTrainingAssistantCW extends StatefulWidget {
  final double? width;
  final double? height;

  const VoiceTrainingAssistantCW({super.key, this.width, this.height});

  @override
  State<VoiceTrainingAssistantCW> createState() =>
      _VoiceTrainingAssistantCWState();
}

class _VoiceTrainingAssistantCWState extends State<VoiceTrainingAssistantCW> {
  int step = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Voice Training",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildStep(),
          const SizedBox(height: 40),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (step) {
      case 0:
        return const Text(
          "Step 1: Speak normally into your microphone.\n\nThis will help us calibrate sensitivity.",
          style: TextStyle(fontSize: 16),
        );
      case 1:
        return const Text(
          "Step 2: Say your emergency keyword (e.g., “help”).\n\nWe will learn your voice pattern.",
          style: TextStyle(fontSize: 16),
        );
      case 2:
        return const Text(
          "Step 3: Repeat the phrase: “Hey AgeEmpower”.\n\nThis trains the wake-word detection.",
          style: TextStyle(fontSize: 16),
        );
      default:
        return const Text(
          "Training complete! Your voice is now calibrated.",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        );
    }
  }

  Widget _buildButton() {
    return ElevatedButton(
      onPressed: () => setState(() => step++),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        backgroundColor:
            step >= 3 ? Colors.green.shade700 : Colors.blue.shade700,
      ),
      child: Text(
        step >= 3 ? "Finish" : "Next",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
