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

class GlobalSyncStatusCW extends StatelessWidget {
  const GlobalSyncStatusCW({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = GlobalAppControllerCW.of(context);
    final theme = FlutterFlowTheme.of(context);

    // Nothing to show
    if (controller.isOnline && !controller.hasOfflineItems) {
      return const SizedBox.shrink();
    }

    Color bg;
    String text;
    Widget? action;

    if (!controller.isOnline) {
      bg = Colors.orange.shade700;
      text = "Offline — changes will sync automatically";
    } else {
      bg = Colors.blue.shade700;
      text = "Sync pending (${controller.offlineQueue.length})";
      action = TextButton(
        onPressed: controller.syncNow,
        child: const Text(
          "SYNC NOW",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: bg,
      child: Row(
        children: [
          const Icon(Icons.sync, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.bodyMedium.copyWith(color: Colors.white),
            ),
          ),
          if (action != null) action,
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
