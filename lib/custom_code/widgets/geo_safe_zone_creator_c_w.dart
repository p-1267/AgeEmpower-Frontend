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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

class GeoSafeZoneCreatorCW extends StatefulWidget {
  const GeoSafeZoneCreatorCW({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<GeoSafeZoneCreatorCW> createState() => _GeoSafeZoneCreatorCWState();
}

class _GeoSafeZoneCreatorCWState extends State<GeoSafeZoneCreatorCW> {
  gmaps.GoogleMapController? mapController;
  gmaps.LatLng? center;
  double radius = 150;

  final TextEditingController nameCtrl = TextEditingController();
  bool saving = false;

  void _onMapTap(gmaps.LatLng pos) {
    setState(() {
      center = pos;
    });
  }

  Future<void> _save() async {
    if (center == null) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => saving = true);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('safeZones')
        .add({
      'name': nameCtrl.text.trim(),
      'center': GeoPoint(center!.latitude, center!.longitude),
      'radius': radius,
      'createdAt': FieldValue.serverTimestamp(),
    });

    setState(() => saving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Safe Zone Created')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.width ?? MediaQuery.of(context).size.width;
    final h = widget.height ?? 500;

    return SizedBox(
      width: w,
      height: h,
      child: Column(
        children: [
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Zone Name (e.g., Home)',
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: gmaps.GoogleMap(
              initialCameraPosition: const gmaps.CameraPosition(
                target: gmaps.LatLng(37.4219999, -122.0840575),
                zoom: 15,
              ),
              myLocationEnabled: true,
              onMapCreated: (c) => mapController = c,
              onTap: _onMapTap,
              circles: center == null
                  ? <gmaps.Circle>{}
                  : {
                      gmaps.Circle(
                        circleId: const gmaps.CircleId('zone'),
                        center: center!,
                        fillColor: Colors.blue.withOpacity(0.1),
                        strokeColor: Colors.blue,
                        strokeWidth: 2,
                        radius: radius,
                      )
                    },
              markers: center == null
                  ? <gmaps.Marker>{}
                  : {
                      gmaps.Marker(
                        markerId: const gmaps.MarkerId('center'),
                        position: center!,
                      )
                    },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Radius: '),
              Expanded(
                child: Slider(
                  value: radius,
                  min: 50,
                  max: 500,
                  divisions: 10,
                  label: '${radius.toInt()} m',
                  onChanged: (v) => setState(() => radius = v),
                ),
              ),
            ],
          ),
          saving
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _save,
                  child: const Text('Save Zone'),
                ),
        ],
      ),
    );
  }
}
