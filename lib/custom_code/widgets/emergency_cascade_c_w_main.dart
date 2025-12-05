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

import 'package:flutter/foundation.dart' show kIsWeb;

// IMPORT YOUR OTHER CUSTOM WIDGETS
// Make sure these names match exactly the widgets you created in FlutterFlow
import 'package:your_project/custom_code/widgets/EmergencyCascadeCWFirestoreService.dart';
import 'package:your_project/custom_code/widgets/EmergencyCascadeCWMobileEngine.dart';
import 'package:your_project/custom_code/widgets/EmergencyCascadeCWWebEngine.dart';

class EmergencyCascadeCWMain extends StatelessWidget {
  const EmergencyCascadeCWMain({super.key});

  @override
  Widget build(BuildContext context) {
    return EmergencyCascadeCWFirestoreService(
      child: kIsWeb
          ? const EmergencyCascadeCWWebEngine()
          : const EmergencyCascadeCWMobileEngine(),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
