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

class VideoCallUI_CW extends StatelessWidget {
  final String callerName;

  const VideoCallUI_CW({super.key, required this.callerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Colors.grey.shade900),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Text(
              callerName,
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _circle(Icons.mic_off, Colors.grey, () {}),
                _circle(Icons.call_end, Colors.red, () {
                  Navigator.pop(context);
                }),
              ],
            ),
          )
        ],
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
