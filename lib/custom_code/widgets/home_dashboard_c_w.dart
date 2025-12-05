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
// DO NOT REMOVE ABOVE

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeDashboardCW extends StatefulWidget {
  final double? width;
  final double? height;

  const HomeDashboardCW({
    super.key,
    this.width,
    this.height,
  });

  @override
  State<HomeDashboardCW> createState() => _HomeDashboardCWState();
}

class _HomeDashboardCWState extends State<HomeDashboardCW> {
  String? uid;
  String role = "senior"; // default fallback

  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
    _loadUser();
  }

  Future<void> _loadUser() async {
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    userData = doc.data() ?? {};
    role = userData["role"] ?? "senior";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoleAdaptiveHeaderCW(role: role, userData: userData),
            const SizedBox(height: 20),
            EmergencyBannerCW(userId: uid),
            const SizedBox(height: 20),
            if (role == "senior") ...[
              HealthOverviewCardCW(userId: uid),
              const SizedBox(height: 20),
              DailyQuickActionsCW(
                onSOS: () => _openSOS(),
                onChat: () => _openChat(),
                onMedication: () => _openMedication(),
                onReports: () => _openReports(),
              ),
            ],
            if (role == "family") ...[
              FamilyDashboardSummaryCW(userId: uid),
              const SizedBox(height: 20),
              NotificationsPreviewCW(userId: uid),
            ],
            if (role == "agency") ...[
              AgencyDashboardSummaryCW(userId: uid),
              const SizedBox(height: 20),
              CaregiverShiftSnapshotCW(agencyId: userData["agency"]),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // NAVIGATION CALLBACKS
  void _openSOS() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: SizedBox(
          height: 420,
          width: 360,
          child: EmergencySOSButtonCW(),
        ),
      ),
    );
  }

  void _openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(body: ChatListCW()),
      ),
    );
  }

  void _openMedication() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(body: MedicationScheduleWidget()),
      ),
    );
  }

  void _openReports() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(body: ReportsWrapperPageCW()),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
