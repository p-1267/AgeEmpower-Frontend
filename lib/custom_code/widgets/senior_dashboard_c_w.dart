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

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

/// Senior Dashboard Custom Widget
class SeniorDashboardCW extends StatefulWidget {
  const SeniorDashboardCW({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<SeniorDashboardCW> createState() => _SeniorDashboardCWState();
}

class _SeniorDashboardCWState extends State<SeniorDashboardCW> {
  String? userId;
  bool loading = true;

  GeoPoint? lastLocation;
  List<Map<String, dynamic>> safeZones = [];
  List<Map<String, dynamic>> wanderingEvents = [];

  List<Map<String, dynamic>> medications = [];
  Map<String, dynamic>? nextAppointment;
  Map<String, dynamic>? todaysMood;
  Map<String, dynamic>? dailyPlan;
  Map<String, dynamic>? vitalsSnapshot;
  Map<String, dynamic>? wellnessSummary;

  gmaps.GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    if (userId == null) {
      setState(() => loading = false);
      return;
    }
    await Future.wait([
      _loadLocationData(),
      _loadMedications(),
      _loadAppointments(),
      _loadMood(),
      _loadDailyPlan(),
      _loadVitals(),
      _loadWellnessSummary(),
    ]);
    setState(() => loading = false);
  }

  Future<void> _loadLocationData() async {
    try {
      final locSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('location')
          .doc('lastKnown')
          .get();

      if (locSnap.exists) {
        lastLocation = locSnap.data()?['position'] as GeoPoint?;
      }

      final zonesSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('safeZones')
          .get();
      safeZones = zonesSnap.docs.map((d) => d.data()).toList();

      final since = Timestamp.fromDate(
        DateTime.now().subtract(const Duration(hours: 48)),
      );

      final wanderSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('wanderingEvents')
          .where('timestamp', isGreaterThan: since)
          .get();

      wanderingEvents = wanderSnap.docs.map((d) => d.data()).toList();
    } catch (_) {}
  }

  Future<void> _loadMedications() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('medications')
          .where('active', isEqualTo: true)
          .get();
      medications = snap.docs.map((d) => d.data()).toList();
    } catch (_) {
      medications = [];
    }
  }

  Future<void> _loadAppointments() async {
    try {
      final now = Timestamp.now();
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('appointments')
          .where('time', isGreaterThan: now)
          .orderBy('time')
          .limit(1)
          .get();
      if (snap.docs.isNotEmpty) {
        nextAppointment = snap.docs.first.data();
      }
    } catch (_) {}
  }

  Future<void> _loadMood() async {
    try {
      final d = DateTime.now();
      final id = '${d.year}-${d.month}-${d.day}';
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('mood')
          .doc(id)
          .get();
      if (snap.exists) todaysMood = snap.data();
    } catch (_) {}
  }

  Future<void> _loadDailyPlan() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dailyPlan')
          .doc('aiPlan')
          .get();
      if (snap.exists) dailyPlan = snap.data();
    } catch (_) {}
  }

  Future<void> _loadVitals() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('vitals')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
      if (snap.docs.isNotEmpty) vitalsSnapshot = snap.docs.first.data();
    } catch (_) {}
  }

  Future<void> _loadWellnessSummary() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('wellnessAI')
          .doc('report')
          .get();
      if (snap.exists) wellnessSummary = snap.data();
    } catch (_) {}
  }

  Widget _buildMap() {
    if (lastLocation == null) {
      return const SizedBox(height: 200);
    }

    return SizedBox(
      height: 200,
      child: gmaps.GoogleMap(
        initialCameraPosition: gmaps.CameraPosition(
          target: gmaps.LatLng(
            lastLocation!.latitude,
            lastLocation!.longitude,
          ),
          zoom: 15,
        ),
        onMapCreated: (c) => _mapController = c,
        markers: _buildMarkers(),
        circles: _buildCircles(),
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
      ),
    );
  }

  Set<gmaps.Marker> _buildMarkers() {
    final markers = <gmaps.Marker>{};

    if (lastLocation != null) {
      markers.add(
        gmaps.Marker(
          markerId: const gmaps.MarkerId('last'),
          position: gmaps.LatLng(
            lastLocation!.latitude,
            lastLocation!.longitude,
          ),
        ),
      );
    }

    return markers;
  }

  Set<gmaps.Circle> _buildCircles() {
    final circles = <gmaps.Circle>{};

    for (var i = 0; i < safeZones.length; i++) {
      final z = safeZones[i];
      final c = z['center'] as GeoPoint?;
      final r = (z['radius'] as num?)?.toDouble() ?? 0;
      if (c == null || r <= 0) continue;

      circles.add(
        gmaps.Circle(
          circleId: gmaps.CircleId('zone_$i'),
          center: gmaps.LatLng(c.latitude, c.longitude),
          radius: r,
          strokeColor: Colors.green,
          fillColor: Colors.green.withOpacity(0.15),
        ),
      );
    }
    return circles;
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMap(),
          const SizedBox(height: 12),
          const Text(
            'Senior Dashboard',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _buildDashboard(),
    );
  }
}
