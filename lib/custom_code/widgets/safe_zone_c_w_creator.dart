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

import '/custom_code/widgets/index.dart'; // pulls SafeZoneCWFirestoreService
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

class SafeZoneCWCreator extends StatefulWidget {
  const SafeZoneCWCreator({
    super.key,
    this.zoneId,
    this.initialName,
    this.initialCenter,
    this.initialRadius,
    this.width,
    this.height,
  });

  final String? zoneId;
  final String? initialName;
  final GeoPoint? initialCenter;
  final double? initialRadius;
  final double? width;
  final double? height;

  @override
  State<SafeZoneCWCreator> createState() => _SafeZoneCWCreatorState();
}

class _SafeZoneCWCreatorState extends State<SafeZoneCWCreator> {
  gmaps.GoogleMapController? mapController;

  gmaps.LatLng? mapCenter;
  double radius = 150;
  final TextEditingController nameController = TextEditingController();

  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initCreator());
  }

  Future<void> _initCreator() async {
    final service = SafeZoneCWFirestoreService.of(context);
    if (service == null) return;

    // Edit existing zone
    if (widget.zoneId != null &&
        widget.initialCenter != null &&
        widget.initialRadius != null) {
      mapCenter = gmaps.LatLng(
        widget.initialCenter!.latitude,
        widget.initialCenter!.longitude,
      );
      radius = widget.initialRadius!;
      nameController.text = widget.initialName ?? '';
      setState(() => loading = false);
      return;
    }

    // New zone → use current location
    final loc = await service.getUserLocation();
    mapCenter = loc != null
        ? gmaps.LatLng(loc.latitude, loc.longitude)
        : const gmaps.LatLng(37.7749, -122.4194);

    setState(() => loading = false);
  }

  Future<void> _saveZone() async {
    final service = SafeZoneCWFirestoreService.of(context);
    if (service == null || mapCenter == null) return;

    setState(() => saving = true);

    final center = GeoPoint(mapCenter!.latitude, mapCenter!.longitude);
    final zoneName = nameController.text.trim().isEmpty
        ? 'Safe Zone'
        : nameController.text.trim();

    if (widget.zoneId == null) {
      await service.createZone(
        name: zoneName,
        center: center,
        radius: radius,
      );
    } else {
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

  @override
  Widget build(BuildContext context) {
    if (loading || mapCenter == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Zone Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                gmaps.GoogleMap(
                  initialCameraPosition: gmaps.CameraPosition(
                    target: mapCenter!,
                    zoom: 16,
                  ),
                  onMapCreated: (c) => mapController = c,
                  onCameraMove: (pos) => setState(() => mapCenter = pos.target),
                  markers: {
                    gmaps.Marker(
                      markerId: const gmaps.MarkerId('center'),
                      position: mapCenter!,
                    ),
                  },
                  circles: {
                    gmaps.Circle(
                      circleId: const gmaps.CircleId('safeZone'),
                      center: mapCenter!,
                      radius: radius,
                      strokeWidth: 2,
                      strokeColor: Colors.green,
                      fillColor: Colors.green.withOpacity(0.25),
                    ),
                  },
                ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Text(
                  'Radius: ${radius.toStringAsFixed(0)} meters',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Slider(
                  value: radius,
                  min: 50,
                  max: 1000,
                  divisions: 19,
                  onChanged: (v) => setState(() => radius = v),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: saving ? null : _saveZone,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: Colors.green,
              ),
              child: saving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Save Safe Zone',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
