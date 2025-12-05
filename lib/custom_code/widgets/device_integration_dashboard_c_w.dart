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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceIntegrationDashboardCW extends StatefulWidget {
  final double? width;
  final double? height;

  const DeviceIntegrationDashboardCW({super.key, this.width, this.height});

  @override
  State<DeviceIntegrationDashboardCW> createState() =>
      _DeviceIntegrationDashboardCWState();
}

class _DeviceIntegrationDashboardCWState
    extends State<DeviceIntegrationDashboardCW> {
  String? uid;

  Map<String, dynamic> status = {
    "fitbit": false,
    "googleFit": false,
    "appleHealth": false,
    "bluetooth": false,
  };

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("integrations")
        .doc("devices")
        .get();

    final data = doc.data() ?? {};

    setState(() {
      status["fitbit"] = data["fitbit"] ?? false;
      status["googleFit"] = data["googleFit"] ?? false;
      status["appleHealth"] = data["appleHealth"] ?? false;
      status["bluetooth"] = data["bluetooth"] ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _sectionTitle("Connected Devices"),
        const SizedBox(height: 20),
        _integrationCard(
          label: "Fitbit",
          icon: Icons.watch,
          connected: status["fitbit"],
          onTap: () => _openFitbit(),
        ),
        _integrationCard(
          label: "Google Fit",
          icon: Icons.favorite,
          connected: status["googleFit"],
          onTap: () => _openGoogleFit(),
        ),
        _integrationCard(
          label: "Apple Health",
          icon: Icons.health_and_safety,
          connected: status["appleHealth"],
          onTap: () => _openAppleHealth(),
        ),
        _integrationCard(
          label: "Bluetooth Devices",
          icon: Icons.bluetooth,
          connected: status["bluetooth"],
          onTap: () => _openBluetooth(),
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Row(
      children: [
        Icon(Icons.devices, size: 34, color: Colors.blue.shade800),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _integrationCard({
    required String label,
    required IconData icon,
    required bool connected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: connected ? Colors.green : Colors.blue.shade200),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 36,
                color:
                    connected ? Colors.green.shade700 : Colors.blue.shade700),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              connected ? "Connected" : "Tap to Connect",
              style: TextStyle(
                  fontSize: 16,
                  color: connected ? Colors.green : Colors.blue.shade600),
            ),
          ],
        ),
      ),
    );
  }

  void _openFitbit() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: SizedBox(height: 420, width: 360, child: FitbitConnectCW()),
      ),
    );
  }

  void _openGoogleFit() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: SizedBox(height: 420, width: 360, child: GoogleFitConnectCW()),
      ),
    );
  }

  void _openAppleHealth() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: SizedBox(height: 420, width: 360, child: AppleHealthConnectCW()),
      ),
    );
  }

  void _openBluetooth() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: SizedBox(height: 420, width: 360, child: BluetoothPairingCW()),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
