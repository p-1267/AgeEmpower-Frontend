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
import 'package:location/location.dart';
import 'SafeZoneCWFirestoreService.dart';

class SafeZoneCWMonitor extends StatefulWidget {
  const SafeZoneCWMonitor({super.key});

  @override
  State<SafeZoneCWMonitor> createState() => _SafeZoneCWMonitorState();
}

class _SafeZoneCWMonitorState extends State<SafeZoneCWMonitor> {
  bool monitoring = true;
  Timer? monitorTimer;

  List<Map<String, dynamic>> zones = [];
  GeoPoint? lastKnownLocation;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  @override
  void dispose() {
    monitorTimer?.cancel();
    super.dispose();
  }

  // ------------------------------------------------------------------------
  // START MONITOR LOOP
  // Runs every 10 seconds (battery-friendly)
  // ------------------------------------------------------------------------
  Future<void> _startMonitoring() async {
    final service = SafeZoneCWFirestoreService.of(context);
    if (service == null) return;

    // initial load
    zones = await service.readZones();

    // periodic loop
    monitorTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (!monitoring) return;

      // get user location
      final userLoc = await service.getUserLocation();
      if (userLoc == null) return;
      lastKnownLocation = userLoc;

      // check each zone
      for (final zone in zones) {
        final center = zone["center"] as GeoPoint;
        final radius = (zone["radius"] as num).toDouble();
        final zoneId = zone["zoneId"];

        final inside = service.isInsideZone(
          userLocation: userLoc,
          center: center,
          radiusMeters: radius,
        );

        if (!inside) {
          // user wandering → trigger emergency alert
          await service.triggerWanderingAlert(
            zoneId: zoneId,
            lastLocation: userLoc,
          );
        }
      }
    });
  }

  // ------------------------------------------------------------------------
  // UI (Status Widget)
  // ------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: monitoring ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: monitoring ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            monitoring ? Icons.shield : Icons.shield_outlined,
            color: monitoring ? Colors.green : Colors.red,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              monitoring ? "Safe Zone Monitoring Active" : "Monitoring Paused",
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Switch(
            value: monitoring,
            onChanged: (v) {
              setState(() => monitoring = v);
            },
          ),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
