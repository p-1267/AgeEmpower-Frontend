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

import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

class AutoScaffoldCW extends StatelessWidget {
  const AutoScaffoldCW({
    super.key,
    required this.content,
    this.width,
    this.height,
    this.title,
    this.showBack = false,
  });

  final Widget content;
  final double? width;
  final double? height;
  final String? title;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        children: [
          AutoHeaderCW(
            title: title,
            showBack: showBack,
            width: width,
            height: 64,
          ),
          Expanded(
            child: Container(
              width: width,
              padding: const EdgeInsets.all(16),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}
