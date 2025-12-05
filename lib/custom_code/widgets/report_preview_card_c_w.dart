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

// Automatic FF imports…

class ReportPreviewCardCW extends StatelessWidget {
  final Map<String, dynamic> reportData;
  final double? width;
  final double? height;

  final VoidCallback? onDownload;
  final VoidCallback? onShare;

  const ReportPreviewCardCW({
    super.key,
    required this.reportData,
    this.width,
    this.height,
    this.onDownload,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final type = reportData["type"] ?? "Unknown";
    final summary = reportData["summary"] ?? "";
    final ts = (reportData["timestamp"] as Timestamp?)?.toDate();

    return Container(
      width: width ?? double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blue.shade200),
        boxShadow: const [
          BoxShadow(
              color: Color(0x22000000), blurRadius: 10, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(type,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          if (ts != null)
            Text(ts.toLocal().toString(),
                style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 14),
          Text(
            summary,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: onDownload,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700),
                icon: const Icon(Icons.download, color: Colors.white),
                label: const Text("Download"),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: onShare,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700),
                icon: const Icon(Icons.share, color: Colors.white),
                label: const Text("Share"),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
