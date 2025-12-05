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

// DO NOT REMOVE ABOVE

class OfflineChangeQueueCW extends StatefulWidget {
  final double? width;
  final double? height;

  /// Inject your pending write queue here (via FF local state or app state)
  final List<Map<String, dynamic>> pendingChanges;

  const OfflineChangeQueueCW({
    super.key,
    this.width,
    this.height,
    required this.pendingChanges,
  });

  @override
  State<OfflineChangeQueueCW> createState() => _OfflineChangeQueueCWState();
}

class _OfflineChangeQueueCWState extends State<OfflineChangeQueueCW> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pending Offline Changes",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          if (widget.pendingChanges.isEmpty)
            const Text(
              "No pending operations. Everything is synced.",
              style: TextStyle(fontSize: 16),
            ),
          for (var op in widget.pendingChanges) _buildChangeTile(op)
        ],
      ),
    );
  }

  Widget _buildChangeTile(Map<String, dynamic> op) {
    final type = op["type"] ?? "unknown";
    final path = op["path"] ?? "unknown";
    final payload = op["payload"] ?? {};

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade200),
        color: Colors.blue.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(type.toUpperCase(),
              style: TextStyle(
                  color: Colors.blue.shade800, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text("Path: $path"),
          const SizedBox(height: 4),
          Text("Data: ${payload.toString()}"),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
