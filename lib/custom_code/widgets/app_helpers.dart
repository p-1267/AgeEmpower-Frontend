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

/// A no-UI widget so this file parses. You don't need to place it on any page.
class AppHelpers extends StatelessWidget {
  const AppHelpers({Key? key, this.width, this.height}) : super(key: key);
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// ---- Shared helper functions you can call from any Custom Widget ----

Future<void> scheduleMorningBundle(
  BuildContext context, {
  TimeOfDay? medsTime,
  TimeOfDay? hydrateTime,
  TimeOfDay? breakfastTime,
}) async {
  debugPrint(
    'scheduleMorningBundle: meds=$medsTime, water=$hydrateTime, breakfast=$breakfastTime',
  );
}

Future<void> applyLocalizationAndUnits(
  BuildContext context, {
  required String languageCode,
  required bool useMetric,
  String? timeZone,
}) async {
  debugPrint(
    'applyLocalizationAndUnits(lang=$languageCode, metric=$useMetric, tz=$timeZone)',
  );
}

Future<void> registerPushTopicsFromSettings(
  BuildContext context, {
  required bool criticalAlerts,
  required int snoozeMinutes,
}) async {
  debugPrint(
    'registerPushTopicsFromSettings(critical=$criticalAlerts, snooze=$snoozeMinutes)',
  );
}
