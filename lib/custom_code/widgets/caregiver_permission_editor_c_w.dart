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

// Additional imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// ---------------------------------------------------------------------------
/// CAREGIVER PERMISSION EDITOR
/// ---------------------------------------------------------------------------
/// Manages caregiver permissions for:
///   - Emergency response capability
///   - Chat access
///   - Vitals viewing
///   - Task & shift editing
///   - Medical records access
///
/// UI matches AgeEmpower styling.
/// Supports hybrid Firestore:
///    /users/{seniorId}/permissions/{caregiverId}
///    /agencies/{agencyId}/caregivers/{caregiverId}/permissions
/// ---------------------------------------------------------------------------

class CaregiverPermissionEditorCW extends StatefulWidget {
  final String caregiverId; // Required
  final String caregiverName; // For UI
  final String? agencyId; // If inside an agency context
  final String? seniorId; // If inside a senior’s private context

  final double? width;
  final double? height;

  const CaregiverPermissionEditorCW({
    super.key,
    required this.caregiverId,
    required this.caregiverName,
    this.agencyId,
    this.seniorId,
    this.width,
    this.height,
  });

  @override
  State<CaregiverPermissionEditorCW> createState() =>
      _CaregiverPermissionEditorCWState();
}

class _CaregiverPermissionEditorCWState
    extends State<CaregiverPermissionEditorCW> {
  bool emergencyAccess = true;
  bool chatAccess = true;
  bool vitalsAccess = true;
  bool tasksAccess = true;
  bool shiftsAccess = true;
  bool recordsAccess = false;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadPermissions();
  }

  // ---------------------------------------------------------------------------
  // Determine Firestore path
  // ---------------------------------------------------------------------------
  DocumentReference<Map<String, dynamic>> _permissionDoc() {
    if (widget.agencyId != null) {
      return FirebaseFirestore.instance
          .collection("agencies")
          .doc(widget.agencyId)
          .collection("caregivers")
          .doc(widget.caregiverId)
          .collection("permissions")
          .doc("permissions");
    }

    final sid = widget.seniorId ?? FirebaseAuth.instance.currentUser?.uid;

    return FirebaseFirestore.instance
        .collection("users")
        .doc(sid)
        .collection("permissions")
        .doc(widget.caregiverId);
  }

  // ---------------------------------------------------------------------------
  // Load permissions
  // ---------------------------------------------------------------------------
  Future<void> _loadPermissions() async {
    final doc = await _permissionDoc().get();
    final data = doc.data() ?? {};

    setState(() {
      emergencyAccess = data["emergencyAccess"] ?? true;
      chatAccess = data["chatAccess"] ?? true;
      vitalsAccess = data["vitalsAccess"] ?? true;
      tasksAccess = data["tasksAccess"] ?? true;
      shiftsAccess = data["shiftsAccess"] ?? true;
      recordsAccess = data["recordsAccess"] ?? false;
      loading = false;
    });
  }

  // ---------------------------------------------------------------------------
  // Save permissions
  // ---------------------------------------------------------------------------
  Future<void> _savePermissions() async {
    await _permissionDoc().set({
      "emergencyAccess": emergencyAccess,
      "chatAccess": chatAccess,
      "vitalsAccess": vitalsAccess,
      "tasksAccess": tasksAccess,
      "shiftsAccess": shiftsAccess,
      "recordsAccess": recordsAccess,
      "updatedAt": FieldValue.serverTimestamp(),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permissions saved")),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Permissions — ${widget.caregiverName}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTile(
                  label: "Emergency Access",
                  subtitle: "Can respond to emergencies for this senior",
                  value: emergencyAccess,
                  color: Colors.red,
                  onChanged: (v) => setState(() => emergencyAccess = v),
                ),
                _buildTile(
                  label: "Chat Access",
                  subtitle: "Can chat with senior & family",
                  value: chatAccess,
                  color: Colors.blue,
                  onChanged: (v) => setState(() => chatAccess = v),
                ),
                _buildTile(
                  label: "View Vitals",
                  subtitle: "Can view health vitals & trends",
                  value: vitalsAccess,
                  color: Colors.orange,
                  onChanged: (v) => setState(() => vitalsAccess = v),
                ),
                _buildTile(
                  label: "Manage Tasks",
                  subtitle: "Can create, edit, and complete tasks",
                  value: tasksAccess,
                  color: Colors.green,
                  onChanged: (v) => setState(() => tasksAccess = v),
                ),
                _buildTile(
                  label: "Manage Shifts",
                  subtitle: "Can edit schedule shifts",
                  value: shiftsAccess,
                  color: Colors.purple,
                  onChanged: (v) => setState(() => shiftsAccess = v),
                ),
                _buildTile(
                  label: "Medical Records Access",
                  subtitle: "Can view uploaded medical documents",
                  value: recordsAccess,
                  color: Colors.teal,
                  onChanged: (v) => setState(() => recordsAccess = v),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _savePermissions,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Save Permissions",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
    );
  }

  // ---------------------------------------------------------------------------
  // BEAUTIFUL toggle tile
  // ---------------------------------------------------------------------------
  Widget _buildTile({
    required String label,
    required String subtitle,
    required bool value,
    required Color color,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.shield, color: color, size: 30),
          const SizedBox(width: 14),

          // Label + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color.shade700,
                    )),
                Text(subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    )),
              ],
            ),
          ),

          // Toggle
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: color,
          ),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
