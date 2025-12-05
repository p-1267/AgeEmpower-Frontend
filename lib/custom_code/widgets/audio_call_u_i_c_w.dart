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

class AudioCallUI_CW extends StatelessWidget {
  final String callerName;

  const AudioCallUI_CW({super.key, required this.callerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              callerName,
              style: const TextStyle(color: Colors.white, fontSize: 26),
            ),
            const SizedBox(height: 40),
            const Text(
              "Audio Call",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _circle(Icons.call_end, Colors.red, () {
                  Navigator.pop(context);
                }),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _circle(IconData i, Color c, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 40,
        backgroundColor: c,
        child: Icon(i, color: Colors.white, size: 40),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
