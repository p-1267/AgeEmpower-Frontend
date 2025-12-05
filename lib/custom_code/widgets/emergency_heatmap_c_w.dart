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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui' as ui;

class EmergencyHeatmapCW extends StatefulWidget {
  const EmergencyHeatmapCW({super.key});

  @override
  State<EmergencyHeatmapCW> createState() => _EmergencyHeatmapCWState();
}

class _EmergencyHeatmapCWState extends State<EmergencyHeatmapCW> {
  GoogleMapController? mapController;
  String? agencyId;

  List<LatLng> points = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    agencyId = FirebaseAuth.instance.currentUser?.uid;
    _loadEmergencyLocations();
  }

  // -------------------------------------------------------------------
  // LOAD ALL EMERGENCY LOCATIONS FOR THIS AGENCY
  // -------------------------------------------------------------------
  Future<void> _loadEmergencyLocations() async {
    if (agencyId == null) return;

    final snap =
        await FirebaseFirestore.instance.collection("emergencies").get();

    List<LatLng> result = [];

    for (final doc in snap.docs) {
      final e = doc.data();
      final userId = e["userId"];
      final loc = e["location"];
      if (userId == null || loc == null) continue;

      final userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      final userData = userSnap.data();
      if (userData == null) continue;

      // Only show seniors belonging to this agency
      if (userData["agency"] == agencyId) {
        result.add(LatLng(loc.latitude, loc.longitude));
      }
    }

    setState(() {
      points = result;
      loading = false;
    });
  }

  // -------------------------------------------------------------------
  // UI
  // -------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(37.7749, -122.4194), // default center
            zoom: 11,
          ),
          onMapCreated: (c) => mapController = c,
          markers: {},
          circles: _buildCircleOverlays(),
        ),
        if (points.isEmpty)
          const Center(
            child: Text(
              "No emergency locations found.",
              style: TextStyle(fontSize: 18),
            ),
          ),
      ],
    );
  }

  // -------------------------------------------------------------------
  // HEATMAP USING CIRCLE OVERLAYS
  // -------------------------------------------------------------------
  Set<Circle> _buildCircleOverlays() {
    final Set<Circle> circles = {};

    int index = 0;

    for (final p in points) {
      circles.add(
        Circle(
          circleId: CircleId("heat_$index"),
          center: p,
          radius: 200, // meters
          strokeColor: Colors.transparent,
          fillColor: Colors.red.withOpacity(0.25),
        ),
      );

      circles.add(
        Circle(
          circleId: CircleId("heat2_$index"),
          center: p,
          radius: 100, // inner stronger zone
          strokeColor: Colors.transparent,
          fillColor: Colors.red.withOpacity(0.35),
        ),
      );

      circles.add(
        Circle(
          circleId: CircleId("heat3_$index"),
          center: p,
          radius: 40,
          strokeColor: Colors.transparent,
          fillColor: Colors.red.withOpacity(0.45),
        ),
      );

      index++;
    }

    return circles;
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
