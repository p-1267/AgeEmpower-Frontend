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

/// ---------------------------------------------------------------------------
/// ResponsiveLayoutEngineCW
/// ---------------------------------------------------------------------------
/// Single source of truth for responsive layout decisions.
/// This replaces all previous ad-hoc ResponsiveEngine variants.
/// ---------------------------------------------------------------------------

class ResponsiveLayoutEngineCW extends InheritedWidget {
  final double width;
  final double height;

  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final bool isUltraWide;

  final EdgeInsets safePadding;

  const ResponsiveLayoutEngineCW({
    super.key,
    required Widget child,
    required this.width,
    required this.height,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    required this.isUltraWide,
    required this.safePadding,
  }) : super(child: child);

  /// Factory constructor – always use this
  factory ResponsiveLayoutEngineCW.build({
    required BuildContext context,
    required Widget child,
  }) {
    final media = MediaQuery.of(context);
    final w = media.size.width;
    final h = media.size.height;

    final bool mobile = w < 600;
    final bool tablet = w >= 600 && w < 1024;
    final bool desktop = w >= 1024 && w < 1440;
    final bool ultraWide = w >= 1440;

    return ResponsiveLayoutEngineCW(
      width: w,
      height: h,
      isMobile: mobile,
      isTablet: tablet,
      isDesktop: desktop,
      isUltraWide: ultraWide,
      safePadding: media.padding,
      child: child,
    );
  }

  /// Access helper
  static ResponsiveLayoutEngineCW of(BuildContext context) {
    final engine =
        context.dependOnInheritedWidgetOfExactType<ResponsiveLayoutEngineCW>();
    if (engine == null) {
      throw Exception(
        'ResponsiveLayoutEngineCW not found in widget tree. '
        'Wrap your app or shell with ResponsiveLayoutEngineCW.build().',
      );
    }
    return engine;
  }

  /// -------------------------------------------------------------------------
  /// Derived helpers (SAFE replacements for old broken fields)
  /// -------------------------------------------------------------------------

  /// Max readable content width
  double get contentMaxWidth {
    if (isUltraWide) return 1200;
    if (isDesktop) return 1100;
    if (isTablet) return 900;
    return width;
  }

  /// Horizontal padding recommendation
  double get horizontalPadding {
    if (isMobile) return 16;
    if (isTablet) return 20;
    return 24;
  }

  /// Recommended column count
  int get columns {
    if (isUltraWide) return 4;
    if (isDesktop) return 3;
    if (isTablet) return 2;
    return 1;
  }

  /// Whether side navigation should be visible
  bool get showSideNav => isDesktop || isUltraWide;

  /// Whether bottom navigation should be used
  bool get useBottomNav => isMobile || isTablet;

  @override
  bool updateShouldNotify(covariant ResponsiveLayoutEngineCW oldWidget) {
    return width != oldWidget.width ||
        height != oldWidget.height ||
        isMobile != oldWidget.isMobile ||
        isTablet != oldWidget.isTablet ||
        isDesktop != oldWidget.isDesktop ||
        isUltraWide != oldWidget.isUltraWide;
  }
}

// DO NOT REMOVE ABOVE
