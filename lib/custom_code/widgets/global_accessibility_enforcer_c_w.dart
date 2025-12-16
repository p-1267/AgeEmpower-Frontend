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

class GlobalAccessibilityEnforcerCW extends StatelessWidget {
  final Widget child;

  const GlobalAccessibilityEnforcerCW({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final controller = GlobalAppControllerCW.of(context);

    final double textScale =
        controller.fontScale.clamp(1.0, 1.4); // store-safe limit

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
        boldText: controller.highContrast,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          visualDensity: controller.largeTouchTargets
              ? VisualDensity.comfortable
              : VisualDensity.standard,
        ),
        child: child,
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
