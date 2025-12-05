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

// Automatic FF imports
// DO NOT REMOVE ABOVE

class OfflineSyncNowButtonCW extends StatelessWidget {
  final double? width;
  final double? height;

  /// Function supplied by parent to execute queued writes
  final Future<void> Function()? onSyncNow;

  const OfflineSyncNowButtonCW({
    super.key,
    this.width,
    this.height,
    this.onSyncNow,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onSyncNow,
      icon: const Icon(Icons.sync),
      label: const Text(
        "Sync Now",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
