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
    // Access the global controller
    final controller = GlobalAppControllerCW.of(context);

    // Get the correct responsive engine
    final responsive = ResponsiveLayoutEngineCW.of(context);

    // Get user role
    final role = controller.role;

    // Build the correct dashboard widget
    final Widget target = _pageForRole(role, controller);

    // Wrap with AppThemeCW + Responsive Shell
    return AppThemeCW(
      role: role,
      themeSettings: controller.themeSettings,
      child: ResponsiveLayoutEngineCW(
        child: MultiDeviceAppShellCW(
          content: Center(
            child: SizedBox(
              width: responsive.safeWidth,
              child: target,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ROLE-BASED PAGE RESOLUTION
  // ---------------------------------------------------------------------------
  Widget _pageForRole(String role, GlobalAppControllerCWState controller) {
    switch (role) {
      case "senior":
        return HomeDashboardCW();

      case "family":
        return HomeDashboardCW();

      case "caregiver":
        return CaregiverTaskListCW();

      case "agency":
        return AgencyDashboardSummaryCW(
          userId: controller.profile["userId"],
        );

      default:
        return HomeDashboardCW();
    }
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
