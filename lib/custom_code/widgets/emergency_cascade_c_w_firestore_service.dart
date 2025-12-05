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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

///  -------------------------------------------------------------------------
///  EmergencyCascadeCWFirestoreService
///  Provides shared Firestore logic to all emergency sub-widgets.
///  This widget wraps child widgets and exposes the Firestore service
///  via an inherited widget.
///  -------------------------------------------------------------------------

class EmergencyCascadeCWFirestoreService extends StatefulWidget {
  const EmergencyCascadeCWFirestoreService({
    super.key,
    required this.child,
  });

  /// Any widget that needs emergency Firestore access will be placed inside this.
  final Widget child;

  @override
  State<EmergencyCascadeCWFirestoreService> createState() =>
      _EmergencyCascadeCWFirestoreServiceState();

  /// Helper to access the Firestore service from any descendant widget
  static _EmergencyFirestoreService? of(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<_EmergencyFirestoreInherited>();
    return inherited?.service;
  }
}

/// --------------------------------------------------------------------------
/// INTERNAL SERVICE CLASS — This is where Firestore logic lives.
/// --------------------------------------------------------------------------

class _EmergencyFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get the signed-in user ID
  String? get uid => _auth.currentUser?.uid;

  /// Load user emergency configuration: caregivers, family, agency
  Future<Map<String, dynamic>?> loadUser() async {
    if (uid == null) return null;

    final snap = await _db.collection('users').doc(uid).get();
    return snap.data();
  }

  /// Create a new emergency event in Firestore
  Future<String> createEmergencyEvent({
    required bool autoDetected,
    GeoPoint? location,
  }) async {
    final id = _db.collection('emergencies').doc().id;

    await _db.collection('emergencies').doc(id).set({
      "eventId": id,
      "userId": uid,
      "timestamp": FieldValue.serverTimestamp(),
      "location": location,
      "autoDetected": autoDetected,
      "caregiverStatus": "pending",
      "familyStatus": "pending",
      "agencyStatus": "pending",
      "platform": "mobile",
      "resolved": false,
    });

    return id;
  }

  /// Update any field on the emergency event
  Future<void> updateEmergencyField({
    required String eventId,
    required String field,
    required dynamic value,
  }) async {
    await _db.collection('emergencies').doc(eventId).update({field: value});
  }

  /// Send notifications to a list of users
  Future<void> sendNotifications({
    required List<dynamic> recipients,
    required String eventId,
  }) async {
    if (recipients.isEmpty) return;

    for (var user in recipients) {
      await _db.collection('notifications').add({
        "toUser": user,
        "eventId": eventId,
        "type": "emergency",
        "timestamp": FieldValue.serverTimestamp(),
        "status": "sent",
      });
    }
  }

  /// Mark emergency as resolved
  Future<void> resolveEmergency(String eventId) async {
    await _db.collection('emergencies').doc(eventId).update({
      "resolved": true,
      "resolvedAt": FieldValue.serverTimestamp(),
    });
  }
}

/// --------------------------------------------------------------------------
/// INHERITED WIDGET — Makes the Firestore service accessible to children.
/// --------------------------------------------------------------------------

class _EmergencyFirestoreInherited extends InheritedWidget {
  final _EmergencyFirestoreService service;

  const _EmergencyFirestoreInherited({
    required this.service,
    required super.child,
  });

  @override
  bool updateShouldNotify(_) => false;
}

/// --------------------------------------------------------------------------
/// STATEFUL WRAPPER — Instantiates service once and provides it.
/// --------------------------------------------------------------------------

class _EmergencyCascadeCWFirestoreServiceState
    extends State<EmergencyCascadeCWFirestoreService> {
  late final _EmergencyFirestoreService _service;

  @override
  void initState() {
    super.initState();
    _service = _EmergencyFirestoreService();
  }

  @override
  Widget build(BuildContext context) {
    return _EmergencyFirestoreInherited(
      service: _service,
      child: widget.child,
    );
  }
}
