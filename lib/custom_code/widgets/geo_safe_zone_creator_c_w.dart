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
// DO NOT REMOVE ABOVE

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GeoSafeZoneCreatorCW extends StatefulWidget {
  final double? width;
  final double? height;

  const GeoSafeZoneCreatorCW({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<GeoSafeZoneCreatorCW> createState() => _GeoSafeZoneCreatorCWState();
}

class _GeoSafeZoneCreatorCWState extends State<GeoSafeZoneCreatorCW> {
  GoogleMapController? mapController;
  LatLng? center;
  double radius = 150;

  final nameCtrl = TextEditingController();
  bool saving = false;

  void _onMapTap(LatLng pos) {
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
        .collection("users")
        .doc(uid)
        .collection("safeZones")
        .add({
      "name": nameCtrl.text.trim(),
      "lat": center!.latitude,
      "lng": center!.longitude,
      "radius": radius,
      "createdAt": FieldValue.serverTimestamp(),
    });

    setState(() => saving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Safe Zone Created")),
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
          // Input
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(
              labelText: "Zone Name (e.g., Home)",
            ),
          ),
          const SizedBox(height: 6),

          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                  target: LatLng(37.4219999, -122.0840575), zoom: 15),
              myLocationEnabled: true,
              onMapCreated: (c) => mapController = c,
              onTap: _onMapTap,
              circles: center == null
                  ? {}
                  : {
                      Circle(
                        circleId: const CircleId("zone"),
                        center: center!,
                        fillColor: Colors.blue.withOpacity(0.1),
                        strokeColor: Colors.blue,
                        strokeWidth: 2,
                        radius: radius,
                      )
                    },
              markers: center == null
                  ? {}
                  : {
                      Marker(
                          markerId: const MarkerId("center"), position: center!)
                    },
            ),
          ),

          const SizedBox(height: 10),

          // Radius Slider
          Row(
            children: [
              const Text("Radius: "),
              Expanded(
                child: Slider(
                  value: radius,
                  min: 50,
                  max: 500,
                  divisions: 10,
                  label: "${radius.toInt()} m",
                  onChanged: (v) => setState(() => radius = v),
                ),
              ),
            ],
          ),

          saving
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _save,
                  child: const Text("Save Zone"),
                ),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
