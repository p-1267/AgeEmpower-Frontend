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

import '/custom_code/widgets/index.dart'; // IMPORTANT: pulls SafeZoneCWFirestoreService
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _startMonitoring());
  }

  @override
  void dispose() {
    monitorTimer?.cancel();
    super.dispose();
  }

  Future<void> _startMonitoring() async {
    final service = SafeZoneCWFirestoreService.of(context);
    if (service == null) return;

    zones = await service.readZones();

    monitorTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (!monitoring) return;

      final userLoc = await service.getUserLocation();
      if (userLoc == null) return;
      lastKnownLocation = userLoc;

      for (final zone in zones) {
        final center = zone['center'] as GeoPoint;
        final radius = (zone['radius'] as num).toDouble();
        final zoneId = zone['zoneId'] as String;

        final inside = service.isInsideZone(
          userLocation: userLoc,
          center: center,
          radiusMeters: radius,
        );

        if (!inside) {
          await service.triggerWanderingAlert(
            zoneId: zoneId,
            lastLocation: userLoc,
          );
        }
      }
    });
  }

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
              monitoring ? 'Safe Zone Monitoring Active' : 'Monitoring Paused',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Switch(
            value: monitoring,
            onChanged: (v) => setState(() => monitoring = v),
          ),
        ],
      ),
    );
  }
}
