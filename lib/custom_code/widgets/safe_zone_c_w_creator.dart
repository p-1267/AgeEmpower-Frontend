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
import 'package:location/location.dart';
import 'SafeZoneCWFirestoreService.dart';

class SafeZoneCWCreator extends StatefulWidget {
  const SafeZoneCWCreator({
    super.key,
    this.zoneId,
    this.initialName,
    this.initialCenter,
    this.initialRadius,
  });

  final String? zoneId;
  final String? initialName;
  final GeoPoint? initialCenter;
  final double? initialRadius;

  @override
  State<SafeZoneCWCreator> createState() => _SafeZoneCWCreatorState();
}

class _SafeZoneCWCreatorState extends State<SafeZoneCWCreator> {
  GoogleMapController? mapController;

  LatLng? mapCenter;
  double radius = 150; // default radius in meters
  final nameController = TextEditingController();

  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _initCreator();
  }

  // ---------------------------------------------------------------------
  // INITIALIZE CREATOR
  // ---------------------------------------------------------------------
  Future<void> _initCreator() async {
    final service = SafeZoneCWFirestoreService.of(context);
    if (service == null) return;

    // If editing existing zone
    if (widget.zoneId != null &&
        widget.initialCenter != null &&
        widget.initialRadius != null) {
      mapCenter = LatLng(
        widget.initialCenter!.latitude,
        widget.initialCenter!.longitude,
      );
      radius = widget.initialRadius!;
      nameController.text = widget.initialName ?? "";
      setState(() => loading = false);
      return;
    }

    // If creating new zone → start at user's current location
    final loc = await service.getUserLocation();
    if (loc != null) {
      mapCenter = LatLng(loc.latitude, loc.longitude);
    } else {
      mapCenter = const LatLng(37.7749, -122.4194); // fallback SF
    }

    setState(() => loading = false);
  }

  // ---------------------------------------------------------------------
  // SAVE ZONE TO FIRESTORE
  // ---------------------------------------------------------------------
  Future<void> _saveZone() async {
    final service = SafeZoneCWFirestoreService.of(context);
    if (service == null || mapCenter == null) return;

    setState(() => saving = true);

    final center = GeoPoint(mapCenter!.latitude, mapCenter!.longitude);
    final zoneName = nameController.text.trim().isEmpty
        ? "Safe Zone"
        : nameController.text.trim();

    if (widget.zoneId == null) {
      // CREATE NEW ZONE
      await service.createZone(
        name: zoneName,
        center: center,
        radius: radius,
      );
    } else {
      // UPDATE EXISTING ZONE
      await service.updateZone(
        zoneId: widget.zoneId!,
        name: zoneName,
        center: center,
        radius: radius,
      );
    }

    setState(() => saving = false);

    if (mounted) Navigator.of(context).pop();
  }

  // ---------------------------------------------------------------------
  // UI BUILD
  // ---------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (loading || mapCenter == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // ZONE NAME FIELD
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Zone Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),

        // GOOGLE MAP
        Expanded(
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: mapCenter!,
                  zoom: 16,
                ),
                onMapCreated: (controller) => mapController = controller,
                onCameraMove: (position) {
                  setState(() {
                    mapCenter = position.target;
                  });
                },
                markers: {
                  Marker(
                    markerId: const MarkerId("center"),
                    position: mapCenter!,
                  ),
                },
                circles: {
                  Circle(
                    circleId: const CircleId("safeZone"),
                    center: mapCenter!,
                    radius: radius,
                    strokeWidth: 2,
                    strokeColor: Colors.green.shade700,
                    fillColor: Colors.green.withOpacity(0.25),
                  ),
                },
              ),

              // STATIC CROSSHAIR
              const Center(
                child: Icon(
                  Icons.location_on,
                  size: 40,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),

        // RADIUS SLIDER
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Text(
                "Radius: ${radius.toStringAsFixed(0)} meters",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Slider(
                value: radius,
                min: 50,
                max: 1000,
                divisions: 19,
                label: "${radius.toStringAsFixed(0)}m",
                onChanged: (v) => setState(() => radius = v),
              ),
            ],
          ),
        ),

        // SAVE BUTTON
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: saving ? null : _saveZone,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: Colors.green.shade700,
            ),
            child: saving
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Save Safe Zone",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }
}
