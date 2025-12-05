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

// FF Imports
// DO NOT REMOVE ABOVE

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AgencyDashboardCW extends StatelessWidget {
  final double? width;
  final double? height;

  const AgencyDashboardCW({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final me = FirebaseAuth.instance.currentUser;
    if (me == null) return const Text("Login required");

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection("users").doc(me.uid).get(),
      builder: (c, snap) {
        if (!snap.hasData) return const CircularProgressIndicator();

        final data = snap.data!.data() as Map<String, dynamic>;
        if (data["role"] != "agencyAdmin") {
          return const Text("Access denied");
        }

        final agencyId = data["agencyId"];
        return _overview(agencyId);
      },
    );
  }

  Widget _overview(String agencyId) {
    final caregivers = FirebaseFirestore.instance
        .collection("users")
        .where("agencyId", isEqualTo: agencyId)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: caregivers,
      builder: (c, snap) {
        if (!snap.hasData) return const CircularProgressIndicator();

        final caregiverDocs = snap.data!.docs;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text("Agency Dashboard",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _heading("Caregivers Assigned"),
            for (final cg in caregiverDocs) _caregiverTile(cg),
            const SizedBox(height: 20),
            _heading("Active Patient Alerts"),
            _alertsSection(caregiverDocs),
            const SizedBox(height: 20),
            _heading("Emergencies"),
            _emergencySection(caregiverDocs),
          ],
        );
      },
    );
  }

  Widget _heading(String t) {
    return Text(
      t,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    );
  }

  Widget _caregiverTile(DocumentSnapshot cg) {
    final data = cg.data() as Map<String, dynamic>;
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(data["name"] ?? ""),
        subtitle: Text("Linked to patient: ${data["linkedTo"]}"),
      ),
    );
  }

  Widget _alertsSection(List<QueryDocumentSnapshot> caregivers) {
    final List<String> patientIds = caregivers
        .map((c) => (c.data() as Map)["linkedTo"]?.toString())
        .where((id) => id != null)
        .cast<String>()
        .toList();

    if (patientIds.isEmpty) return const Text("No patients");

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collectionGroup("alerts").snapshots(),
      builder: (c, snap) {
        if (!snap.hasData) return const CircularProgressIndicator();

        final docs = snap.data!.docs.where((d) {
          return patientIds.contains(d.reference.parent.parent!.id);
        }).toList();

        return Column(
          children: docs.map((d) {
            final a = d.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(a["message"] ?? ""),
              subtitle: Text(
                  (a["createdAt"] as Timestamp?)?.toDate().toString() ?? ""),
              leading: const Icon(Icons.warning),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _emergencySection(List<QueryDocumentSnapshot> caregivers) {
    final patientIds = caregivers
        .map((c) => (c.data() as Map)["linkedTo"]?.toString())
        .where((id) => id != null)
        .cast<String>()
        .toList();

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collectionGroup("emergencies").snapshots(),
      builder: (c, snap) {
        if (!snap.hasData) return const CircularProgressIndicator();

        final docs = snap.data!.docs.where((d) {
          return patientIds.contains(d.reference.parent.parent!.id);
        }).toList();

        if (docs.isEmpty) return const Text("No emergencies.");

        return Column(
          children: docs.map((d) {
            final e = d.data() as Map<String, dynamic>;
            return Card(
              child: ListTile(
                title: Text(e["message"] ?? ""),
                subtitle: Text(
                    (e["createdAt"] as Timestamp?)?.toDate().toString() ?? ""),
                leading: const Icon(Icons.emergency),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
