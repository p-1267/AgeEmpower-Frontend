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

class ResponsiveLayoutEngineCW extends StatelessWidget {
  final Widget child;

  const ResponsiveLayoutEngineCW({
    super.key,
    required this.child,
  });

  // ---------------------------------------------------------------
  // BREAKPOINTS
  // ---------------------------------------------------------------
  static const double mobileMax = 600;
  static const double tabletMin = 600;
  static const double tabletMax = 1024;
  static const double desktopMin = 1024;
  static const double desktopMax = 1440;
  static const double ultraMin = 1440;

  // ---------------------------------------------------------------
  // ACCESSOR: get engine from context
  // ---------------------------------------------------------------
  static ResponsiveEngine of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_ResponsiveInherited>();
    if (inherited == null) {
      throw Exception(
          "ResponsiveLayoutEngineCW not found above in widget tree.");
    }
    return inherited.engine;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final engine = ResponsiveEngine.fromWidth(width);

    return _ResponsiveInherited(
      engine: engine,
      child: child,
    );
  }
}

// ===================================================================
// RESPONSIVE ENGINE MODEL — Pure logic, reusable by any widget
// ===================================================================
class ResponsiveEngine {
  final bool isMobile;
  final bool isTablet;
  final bool isTabletLarge;
  final bool isDesktop;
  final bool isUltraWide;

  final int columnCount;
  final double safeWidth;

  final String deviceType;

  const ResponsiveEngine({
    required this.isMobile,
    required this.isTablet,
    required this.isTabletLarge,
    required this.isDesktop,
    required this.isUltraWide,
    required this.columnCount,
    required this.safeWidth,
    required this.deviceType,
  });

  factory ResponsiveEngine.fromWidth(double width) {
    if (width < ResponsiveLayoutEngineCW.mobileMax) {
      return ResponsiveEngine(
        isMobile: true,
        isTablet: false,
        isTabletLarge: false,
        isDesktop: false,
        isUltraWide: false,
        columnCount: 1,
        safeWidth: width,
        deviceType: "mobile",
      );
    }

    if (width >= ResponsiveLayoutEngineCW.tabletMin &&
        width < ResponsiveLayoutEngineCW.tabletMax) {
      return ResponsiveEngine(
        isMobile: false,
        isTablet: true,
        isTabletLarge: width > 800,
        isDesktop: false,
        isUltraWide: false,
        columnCount: width > 800 ? 2 : 1,
        safeWidth: width * 0.95,
        deviceType: "tablet",
      );
    }

    if (width >= ResponsiveLayoutEngineCW.desktopMin &&
        width < ResponsiveLayoutEngineCW.desktopMax) {
      return ResponsiveEngine(
        isMobile: false,
        isTablet: false,
        isTabletLarge: false,
        isDesktop: true,
        isUltraWide: false,
        columnCount: 2,
        safeWidth: 900,
        deviceType: "desktop",
      );
    }

    return ResponsiveEngine(
      isMobile: false,
      isTablet: false,
      isTabletLarge: false,
      isDesktop: false,
      isUltraWide: true,
      columnCount: 3,
      safeWidth: 1200,
      deviceType: "ultra",
    );
  }
}

// ===================================================================
// INHERITED WIDGET TO PROVIDE RESPONSIVE ENGINE TO CHILDREN
// ===================================================================
class _ResponsiveInherited extends InheritedWidget {
  final ResponsiveEngine engine;

  const _ResponsiveInherited({
    required this.engine,
    required super.child,
  });

  @override
  bool updateShouldNotify(_ResponsiveInherited oldWidget) =>
      engine.deviceType != oldWidget.engine.deviceType;
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
