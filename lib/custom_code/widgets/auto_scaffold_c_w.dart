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

class AutoScaffoldCW extends StatelessWidget {
  final Widget content;
  final String? title;
  final bool showBack;

  const AutoScaffoldCW({
    super.key,
    required this.content,
    this.title,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = GlobalAppControllerCW.of(context);
    final engine = ResponsiveLayoutEngineCW.of(context);

    return AppThemeCW(
      role: controller.role,
      themeSettings: controller.themeSettings,
      child: ResponsiveLayoutEngineCW(
        child: MultiDeviceAppShellCW(
          content: Column(
            children: [
              AutoHeaderCW(
                title: title,
                showBack: showBack,
              ),
              Expanded(
                child: Container(
                  width: engine.safeWidth,
                  padding: const EdgeInsets.all(16),
                  child: content,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
