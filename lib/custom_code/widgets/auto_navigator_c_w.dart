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

class AutoNavigatorCW {
  static void navigate(BuildContext context, String route) {
    final c = GlobalAppControllerCW.of(context);

    switch (route) {
      case "home":
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => c.buildHomeForUser()),
        );
        break;

      case "chat":
        c.openChatList(context);
        break;

      case "health":
        c.openReports(context);
        break;

      case "appointments":
        c.openAppointments(context);
        break;

      case "reports":
        c.openReports(context);
        break;

      case "device":
        c.openDeviceIntegrations(context);
        break;

      case "security":
        c.openSecurityCenter(context);
        break;

      case "voice":
        c.openVoiceSettings(context);
        break;

      default:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => c.buildHomeForUser()),
        );
    }
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
