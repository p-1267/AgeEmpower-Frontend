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

class ChatUIBasicCW extends StatelessWidget {
  const ChatUIBasicCW({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Container(color: Colors.grey.shade200)),
        TextField(decoration: const InputDecoration(hintText: "Message...")),
      ],
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
