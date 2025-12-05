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

import '/custom_code/widgets/index.dart';

class AppThemeCW extends StatelessWidget {
  final Widget child;
  final Map<String, dynamic> themeSettings;
  final String role; // senior, family, caregiver, agency

  const AppThemeCW({
    super.key,
    required this.child,
    required this.themeSettings,
    required this.role,
  });

  // -----------------------------------------------------------
  // GLOBAL COLOR PALETTE (Material + Dashboard Hybrid)
  // -----------------------------------------------------------
  Color getPrimary() {
    switch (role) {
      case "senior":
        return Colors.blue.shade700;
      case "family":
        return Colors.green.shade700;
      case "caregiver":
        return Colors.purple.shade700;
      case "agency":
        return Colors.indigo.shade800;
      default:
        return Colors.blue.shade700;
    }
  }

  Color getAccent() {
    switch (role) {
      case "senior":
        return Colors.blueAccent;
      case "family":
        return Colors.tealAccent.shade400;
      case "caregiver":
        return Colors.deepPurpleAccent;
      case "agency":
        return Colors.indigoAccent.shade400;
      default:
        return Colors.blueAccent;
    }
  }

  // -----------------------------------------------------------
  // TEXT STYLES WITH ACCESSIBILITY SCALING
  // -----------------------------------------------------------
  TextStyle scale(TextStyle style, double factor) {
    final fs = themeSettings["fontScale"] ?? 1.0;
    return style.copyWith(fontSize: style.fontSize! * fs * factor);
  }

  TextStyle get header => scale(
        const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        1.0,
      );

  TextStyle get sectionTitle => scale(
        const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        1.0,
      );

  TextStyle get normal => scale(
        const TextStyle(
          fontSize: 16,
        ),
        1.0,
      );

  TextStyle get bold => scale(
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        1.0,
      );

  // -----------------------------------------------------------
  // CARD STYLE SYSTEM
  // -----------------------------------------------------------
  BoxDecoration get cardDecoration {
    final highContrast = themeSettings["highContrast"] ?? false;

    return BoxDecoration(
      color: highContrast ? Colors.white : Colors.grey.shade50,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: highContrast ? Colors.black : getPrimary().withOpacity(0.25),
        width: highContrast ? 2 : 1.4,
      ),
      boxShadow: [
        if (!highContrast)
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
      ],
    );
  }

  // -----------------------------------------------------------
  // BUTTON STYLE
  // -----------------------------------------------------------
  ButtonStyle get primaryButton => ElevatedButton.styleFrom(
        backgroundColor: getPrimary(),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      );

  ButtonStyle get accentButton => ElevatedButton.styleFrom(
        backgroundColor: getAccent(),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      );

  // -----------------------------------------------------------
  // ACCESSIBILITY TOUCH AREAS
  // -----------------------------------------------------------
  EdgeInsets get cardPadding {
    final large = themeSettings["largeTouchTargets"] ?? false;
    return EdgeInsets.all(large ? 24 : 16);
  }

  // -----------------------------------------------------------
  // PROVIDER FOR CHILDREN (Inherited-style)
  // -----------------------------------------------------------
  static AppThemeCW of(BuildContext context) {
    final widget = context.findAncestorWidgetOfExactType<AppThemeCW>();
    if (widget == null) {
      throw Exception("AppThemeCW not found in widget tree");
    }
    return widget;
  }

  // -----------------------------------------------------------
  // BUILD WRAPPER
  // -----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return child;
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
