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

class AutoHeaderCW extends StatelessWidget {
  const AutoHeaderCW({
    super.key,
    this.width,
    this.height,
    this.title,
    this.showBack = false,
  });

  final double? width;
  final double? height;
  final String? title;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final displayTitle = title ?? 'Dashboard';

    return SizedBox(
      width: width,
      height: height ?? 64,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            if (showBack)
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            Expanded(
              child: Text(
                displayTitle,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(Icons.notifications_none_rounded, size: 28),
            const SizedBox(width: 16),
            Icon(Icons.chat_bubble_outline_rounded, size: 26),
          ],
        ),
      ),
    );
  }
}
