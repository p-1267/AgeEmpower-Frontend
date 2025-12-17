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

class EmergencyHeatmapCW extends StatefulWidget {
  const EmergencyHeatmapCW({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<EmergencyHeatmapCW> createState() => _EmergencyHeatmapCWState();
}

class _EmergencyHeatmapCWState extends State<EmergencyHeatmapCW> {
  gmaps.GoogleMapController? mapController;
  String? agencyId;

  List<gmaps.LatLng> points = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    agencyId = FirebaseAuth.instance.currentUser?.uid;
    _loadEmergencyLocations();
  }

  // ------------------------------------------------------------
  // LOAD ALL EMERGENCY LOCATIONS FOR THIS AGENCY
  // ------------------------------------------------------------
  Future<void> _loadEmergencyLocations() async {
    if (agencyId == null) {
      setState(() => loading = false);
      return;
    }

    try {
      final snap =
          await FirebaseFirestore.instance.collection('emergencies').get();

      final List<gmaps.LatLng> result = [];

      for (final doc in snap.docs) {
        final data = doc.data();
        final userId = data['userId'];
        final loc = data['location'];

        if (userId == null || loc == null || loc is! GeoPoint) continue;

        final userSnap = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        final userData = userSnap.data();
        if (userData == null) continue;

        if (userData['agency'] == agencyId) {
          result.add(gmaps.LatLng(loc.latitude, loc.longitude));
        }
      }

      setState(() {
        points = result;
        loading = false;
      });
    } catch (_) {
      setState(() => loading = false);
    }
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          gmaps.GoogleMap(
            initialCameraPosition: const gmaps.CameraPosition(
              target: gmaps.LatLng(37.7749, -122.4194),
              zoom: 11,
            ),
            onMapCreated: (c) => mapController = c,
            markers: const <gmaps.Marker>{},
            circles: _buildCircleOverlays(),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          if (points.isEmpty)
            const Center(
              child: Text(
                'No emergency locations found.',
                style: TextStyle(fontSize: 18),
              ),
            ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // HEATMAP USING CIRCLE OVERLAYS
  // ------------------------------------------------------------
  Set<gmaps.Circle> _buildCircleOverlays() {
    final Set<gmaps.Circle> circles = {};
    int index = 0;

    for (final p in points) {
      circles.add(
        gmaps.Circle(
          circleId: gmaps.CircleId('heat_$index'),
          center: p,
          radius: 200,
          strokeColor: Colors.transparent,
          fillColor: Colors.red.withOpacity(0.25),
        ),
      );

      circles.add(
        gmaps.Circle(
          circleId: gmaps.CircleId('heat2_$index'),
          center: p,
          radius: 100,
          strokeColor: Colors.transparent,
          fillColor: Colors.red.withOpacity(0.35),
        ),
      );

      circles.add(
        gmaps.Circle(
          circleId: gmaps.CircleId('heat3_$index'),
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
