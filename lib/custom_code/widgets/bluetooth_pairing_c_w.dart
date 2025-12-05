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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BluetoothPairingCW extends StatefulWidget {
  @override
  State<BluetoothPairingCW> createState() => _BluetoothPairingCWState();
}

class _BluetoothPairingCWState extends State<BluetoothPairingCW> {
  bool scanning = false;
  List<String> fakeDevices = [
    "Heart Monitor A1",
    "Step Tracker S3",
    "Sleep Sensor X7",
  ];

  String? selectedDevice;
  String? uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> _saveSelection() async {
    if (uid == null || selectedDevice == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("integrations")
        .doc("devices")
        .set({
      "bluetooth": true,
      "deviceName": selectedDevice,
    }, SetOptions(merge: true));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildDialog();
  }

  Widget _buildDialog() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text("Bluetooth Devices",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text(
            "Select a nearby health sensor to connect.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: fakeDevices.length,
              itemBuilder: (context, i) {
                final name = fakeDevices[i];
                final selected = name == selectedDevice;

                return GestureDetector(
                  onTap: () => setState(() => selectedDevice = name),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.blue.shade100
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected
                            ? Colors.blue.shade700
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.bluetooth,
                            color: selected
                                ? Colors.blue.shade700
                                : Colors.grey.shade700),
                        const SizedBox(width: 14),
                        Text(name, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: selectedDevice == null ? null : _saveSelection,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              minimumSize: const Size(double.infinity, 52),
            ),
            child: const Text("Connect Device",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
