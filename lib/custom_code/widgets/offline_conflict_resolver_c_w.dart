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

class OfflineConflictResolverCW extends StatefulWidget {
  final double? width;
  final double? height;

  /// Local (offline) version of the document
  final Map<String, dynamic> localData;

  /// Server (online) version of the document
  final Map<String, dynamic> serverData;

  /// Callback: user chooses "local" or "server"
  final Function(String choice)? onResolve;

  const OfflineConflictResolverCW({
    super.key,
    this.width,
    this.height,
    required this.localData,
    required this.serverData,
    this.onResolve,
  });

  @override
  State<OfflineConflictResolverCW> createState() =>
      _OfflineConflictResolverCWState();
}

class _OfflineConflictResolverCWState extends State<OfflineConflictResolverCW> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sync Conflict Detected",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "Choose which version you want to keep:",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          _buildComparisonCard("Local Version", widget.localData, "local"),
          const SizedBox(height: 12),
          _buildComparisonCard("Server Version", widget.serverData, "server"),
        ],
      ),
    );
  }

  Widget _buildComparisonCard(
      String title, Map<String, dynamic> data, String keyChoice) {
    return GestureDetector(
      onTap: () => widget.onResolve?.call(keyChoice),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              data.toString(),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
