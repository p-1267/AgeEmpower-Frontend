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

import '/custom_code/widgets/index.dart'; // Imports all your previously created report widgets
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';
// DO NOT REMOVE ABOVE

// Additional imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportsWrapperPageCW extends StatefulWidget {
  final double? width;
  final double? height;

  const ReportsWrapperPageCW({
    super.key,
    this.width,
    this.height,
  });

  @override
  State<ReportsWrapperPageCW> createState() => _ReportsWrapperPageCWState();
}

class _ReportsWrapperPageCWState extends State<ReportsWrapperPageCW> {
  int selectedTab = 0;
  Map<String, dynamic>? previewData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildTabs(),
          const SizedBox(height: 20),
          Expanded(child: _buildTabContent()),
          if (previewData != null) _buildPreviewDrawer(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------
  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.description, size: 36, color: Colors.blue.shade800),
        const SizedBox(width: 12),
        const Text(
          "Health Reports",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------
  // TAB SELECTOR
  // ---------------------------------------------------------------
  Widget _buildTabs() {
    final tabs = ["History", "Schedule", "Generate"];

    return Row(
      children: List.generate(tabs.length, (i) {
        final active = selectedTab == i;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => selectedTab = i),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: active ? Colors.blue.shade700 : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.blue.shade200),
              ),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                tabs[i],
                style: TextStyle(
                  color: active ? Colors.white : Colors.blue.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // ---------------------------------------------------------------
  // TAB CONTENT (switch between widgets)
  // ---------------------------------------------------------------
  Widget _buildTabContent() {
    if (selectedTab == 0) {
      return ReportsHistoryListCW(
        onReportSelected: (id, data) {
          setState(() => previewData = data);
        },
      );
    }

    if (selectedTab == 1) {
      return ReportSchedulerCW();
    }

    return ReportGeneratorCW();
  }

  // ---------------------------------------------------------------
  // PREVIEW DRAWER (Slide-up preview)
  // ---------------------------------------------------------------
  Widget _buildPreviewDrawer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blue.shade200),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, -3),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ReportPreviewCardCW(
            reportData: previewData!,
            onDownload: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Downloading report...")),
              );
            },
            onShare: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Sharing report...")),
              );
            },
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () => setState(() => previewData = null),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Close Preview",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
