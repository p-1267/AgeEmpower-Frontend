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

import 'package:age_empower/custom_code/widgets/safe_zone_c_w_firestore_service.dart';
import 'package:age_empower/custom_code/widgets/safe_zone_c_w_creator.dart';
import 'package:age_empower/custom_code/widgets/safe_zone_c_w_monitor.dart';

class SafeZoneCWMain extends StatefulWidget {
  const SafeZoneCWMain({super.key});

  @override
  State<SafeZoneCWMain> createState() => _SafeZoneCWMainState();
}

class _SafeZoneCWMainState extends State<SafeZoneCWMain> {
  bool showCreator = false;

  @override
  Widget build(BuildContext context) {
    return SafeZoneCWFirestoreService(
      child: Column(
        children: [
          // Title Bar
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                const Icon(Icons.map_rounded, size: 30),
                const SizedBox(width: 10),
                const Text(
                  "Safe Zone Management",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    showCreator ? Icons.visibility : Icons.add_circle_outline,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() => showCreator = !showCreator);
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: showCreator
                  ? const SafeZoneCWCreator()
                  : const SafeZoneCWMonitor(),
            ),
          )
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
