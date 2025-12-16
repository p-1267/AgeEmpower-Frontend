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

import '/custom_code/widgets/index.dart'; // GlobalAppControllerCW + dashboards

class AutoPageCW extends StatelessWidget {
  final double? width;
  final double? height;

  const AutoPageCW({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Access the global controller (returns the controller STATE instance)
    final controller = GlobalAppControllerCW.of(context);

    // Get role from controller (matches the upgraded GlobalAppControllerCW)
    final String role = controller.userRole;

    // Step 2 routing: controller decides which page to show by routeKey/auth/role
    // (Falls back safely if someone is not logged in)
    final Widget target = AutoContentWrapperCW(
      child: controller.buildForRouteKey(),
    );

    // Compute a safe content width (avoid depending on ResponsiveLayoutEngineCW.of)
    final double screenW = MediaQuery.of(context).size.width;
    final double safeWidth = _safeWidthFor(screenW);

    // Wrap with AppThemeCW + Responsive Layout + Shell
    // (Keeps your architecture, but makes routing controlled by controller)
    return AppThemeCW(
      role: role,
      themeSettings: controller.themeSettings,
      child: ResponsiveLayoutEngineCW(
        child: MultiDeviceAppShellCW(
          content: Center(
            child: SizedBox(
              width: safeWidth,
              child: target,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SAFE WIDTH (simple responsive clamp)
  // ---------------------------------------------------------------------------
  double _safeWidthFor(double screenW) {
    // Mobile: full width
    if (screenW < 600) return screenW;

    // Tablet: keep readable margins
    if (screenW < 1024) return 720;

    // Desktop: comfortable centered column
    if (screenW < 1440) return 960;

    // Ultra-wide: cap content width
    return 1100;
  }

  // ---------------------------------------------------------------------------
  // ROLE-BASED PAGE RESOLUTION (kept for compatibility / fallback)
  // NOTE: Routing is now handled by controller.buildForRouteKey().
  // This method remains here so you aren't losing anything.
  // ---------------------------------------------------------------------------
  Widget _pageForRole(String role, dynamic controller) {
    switch (role) {
      case "senior":
        return HomeDashboardCW();

      case "family":
        return HomeDashboardCW();

      case "caregiver":
        return CaregiverTaskListCW();

      case "agency":
        return AgencyDashboardSummaryCW(
          userId: controller.uid,
        );

      default:
        return HomeDashboardCW();
    }
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
