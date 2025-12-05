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

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';

/// ---------------------------------------------------------------------------
/// SafeZoneCWFirestoreService
/// Provides Firestore + location-powered features for Safe Zones:
/// - Create Zone
/// - Read Zones
/// - Update Zone
/// - Delete Zone
/// - Check if user is inside zone
/// - Trigger emergency alert if outside zone
/// ---------------------------------------------------------------------------

class SafeZoneCWFirestoreService extends StatefulWidget {
  const SafeZoneCWFirestoreService({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<SafeZoneCWFirestoreService> createState() =>
      _SafeZoneCWFirestoreServiceState();

  /// Allows any child widget to access this service
  static _SafeZoneService? of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_SafeZoneServiceInherited>();
    return inherited?.service;
  }
}

/// ---------------------------------------------------------------------------
/// INTERNAL SERVICE CLASS
/// ---------------------------------------------------------------------------

class _SafeZoneService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Location _location = Location();

  String? get uid => _auth.currentUser?.uid;

  // -----------------------------------------------------
  // CRUD: CREATE SAFE ZONE
  // -----------------------------------------------------
  Future<String> createZone({
    required String name,
    required GeoPoint center,
    required double radius,
  }) async {
    final id = _db.collection('zones').doc().id;

    await _db.collection('users').doc(uid).collection('safeZones').doc(id).set({
      "zoneId": id,
      "name": name,
      "center": center,
      "radius": radius,
      "createdAt": FieldValue.serverTimestamp(),
    });

    return id;
  }

  // -----------------------------------------------------
  // READ ALL SAFE ZONES
  // -----------------------------------------------------
  Future<List<Map<String, dynamic>>> readZones() async {
    final snap =
        await _db.collection('users').doc(uid).collection('safeZones').get();

    return snap.docs.map((e) => e.data()).toList();
  }

  // -----------------------------------------------------
  // UPDATE SAFE ZONE
  // -----------------------------------------------------
  Future<void> updateZone({
    required String zoneId,
    required String name,
    required GeoPoint center,
    required double radius,
  }) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('safeZones')
        .doc(zoneId)
        .update({
      "name": name,
      "center": center,
      "radius": radius,
    });
  }

  // -----------------------------------------------------
  // DELETE SAFE ZONE
  // -----------------------------------------------------
  Future<void> deleteZone(String zoneId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('safeZones')
        .doc(zoneId)
        .delete();
  }

  // -----------------------------------------------------
  // GET CURRENT USER LOCATION
  // -----------------------------------------------------
  Future<GeoPoint?> getUserLocation() async {
    bool enabled = await _location.serviceEnabled();
    if (!enabled) enabled = await _location.requestService();
    if (!enabled) return null;

    PermissionStatus perm = await _location.hasPermission();
    if (perm == PermissionStatus.denied) {
      perm = await _location.requestPermission();
    }
    if (perm != PermissionStatus.granted) return null;

    final loc = await _location.getLocation();
    return GeoPoint(loc.latitude!, loc.longitude!);
  }

  // -----------------------------------------------------
  // CHECK IF LOCATION IS INSIDE ZONE
  // Haversine distance calculation
  // -----------------------------------------------------
  bool isInsideZone({
    required GeoPoint userLocation,
    required GeoPoint center,
    required double radiusMeters,
  }) {
    const double earthRadius = 6371000;

    double toRadians(double degree) => degree * 3.141592653589793 / 180;

    final lat1 = toRadians(userLocation.latitude);
    final lon1 = toRadians(userLocation.longitude);
    final lat2 = toRadians(center.latitude);
    final lon2 = toRadians(center.longitude);

    final dlat = lat2 - lat1;
    final dlon = lon2 - lon1;

    final a = (sin(dlat / 2) * sin(dlat / 2)) +
        cos(lat1) * cos(lat2) * (sin(dlon / 2) * sin(dlon / 2));

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = earthRadius * c;

    return distance <= radiusMeters;
  }

  // -----------------------------------------------------
  // TRIGGER WANDERING ALERT
  // -----------------------------------------------------
  Future<void> triggerWanderingAlert({
    required String zoneId,
    required GeoPoint lastLocation,
  }) async {
    final alertId = _db.collection('emergencies').doc().id;

    await _db.collection('emergencies').doc(alertId).set({
      "eventId": alertId,
      "userId": uid,
      "type": "wandering_alert",
      "zoneId": zoneId,
      "location": lastLocation,
      "timestamp": FieldValue.serverTimestamp(),
      "resolved": false,
    });

    // Notify caregivers automatically
    await _db.collection('notifications').add({
      "toUser": uid,
      "type": "wandering",
      "eventId": alertId,
      "timestamp": FieldValue.serverTimestamp(),
      "status": "sent",
    });
  }
}

/// ---------------------------------------------------------------------------
/// INHERITED WIDGET WRAPPER
/// ---------------------------------------------------------------------------

class _SafeZoneServiceInherited extends InheritedWidget {
  final _SafeZoneService service;

  const _SafeZoneServiceInherited({
    required this.service,
    required super.child,
  });

  @override
  bool updateShouldNotify(_) => false;
}

/// ---------------------------------------------------------------------------
/// SERVICE PROVIDER STATE
/// ---------------------------------------------------------------------------

class _SafeZoneCWFirestoreServiceState
    extends State<SafeZoneCWFirestoreService> {
  late final _SafeZoneService _service;

  @override
  void initState() {
    super.initState();
    _service = _SafeZoneService();
  }

  @override
  Widget build(BuildContext context) {
    return _SafeZoneServiceInherited(
      service: _service,
      child: widget.child,
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
