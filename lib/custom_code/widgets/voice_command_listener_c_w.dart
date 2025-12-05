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

import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceCommandListenerCW extends StatefulWidget {
  const VoiceCommandListenerCW({super.key});

  @override
  State<VoiceCommandListenerCW> createState() => _VoiceCommandListenerCWState();
}

class _VoiceCommandListenerCWState extends State<VoiceCommandListenerCW> {
  late stt.SpeechToText sttEngine;
  bool listening = false;
  String command = "";

  @override
  void initState() {
    super.initState();
    sttEngine = stt.SpeechToText();
  }

  Future<void> _listen() async {
    bool available = await sttEngine.initialize();
    if (!available) return;

    setState(() => listening = true);

    sttEngine.listen(
      onResult: (r) {
        setState(() => command = r.recognizedWords);
        _processCommand(command);
      },
    );
  }

  Future<void> _processCommand(String cmd) async {
    final lower = cmd.toLowerCase();

    if (lower.contains("medication")) {}
    if (lower.contains("doctor")) {}
    if (lower.contains("help")) {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _listen,
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.purple,
        child: Icon(
          listening ? Icons.mic : Icons.mic_none,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
