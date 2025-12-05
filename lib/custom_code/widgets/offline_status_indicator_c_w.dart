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

// DO NOT REMOVE ABOVE

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineStatusIndicatorCW extends StatefulWidget {
  final double? width;
  final double? height;

  const OfflineStatusIndicatorCW({super.key, this.width, this.height});

  @override
  State<OfflineStatusIndicatorCW> createState() =>
      _OfflineStatusIndicatorCWState();
}

class _OfflineStatusIndicatorCWState extends State<OfflineStatusIndicatorCW> {
  bool online = true;

  late StreamSubscription connectivitySub;

  @override
  void initState() {
    super.initState();

    connectivitySub = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        online = (result != ConnectivityResult.none);
      });
    });
  }

  @override
  void dispose() {
    connectivitySub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = online ? Colors.green.shade600 : Colors.red.shade600;
    final text = online ? "Online" : "Offline — Changes queued";

    return Container(
      width: widget.width ?? double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: online ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(
            online ? Icons.cloud_done : Icons.cloud_off,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
