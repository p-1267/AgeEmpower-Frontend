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

class GlobalNavigationInterceptorCW extends StatelessWidget {
  final Widget child;

  const GlobalNavigationInterceptorCW({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        // Intercept old push routes
        final controller = GlobalAppControllerCW.of(context);

        if (settings.name != null) {
          final route = settings.name!.toLowerCase();

          if (route.contains("chat")) {
            controller.setRouteKey("messages");
          } else if (route.contains("appointment")) {
            controller.setRouteKey("appointments");
          } else if (route.contains("report")) {
            controller.setRouteKey("reports");
          } else if (route.contains("emergency")) {
            controller.setRouteKey("emergency");
          } else if (route.contains("device")) {
            controller.setRouteKey("devices");
          } else {
            controller.setRouteKey("home");
          }
        }

        // Always stay on same page
        return MaterialPageRoute(
          builder: (_) => child,
          settings: settings,
        );
      },
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
