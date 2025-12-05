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

import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

class AboutCW extends StatelessWidget {
  const AboutCW({Key? key, this.width, this.height}) : super(key: key);

  final double? width;
  final double? height;

  // TODO: wire this to real app version later (e.g., PackageInfo or remote config)
  static const String _version = '0.1.0';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('About This App',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              'AgeEmpower helps you track your health, medications, and daily habits with ease. '
              'Stay organized, stay informed, and take control of your well-being.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 24),
            const Text('Version',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text(_version),
            const SizedBox(height: 24),
            const Divider(),
            const Text('Acknowledgements',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Text(
              'Built with Flutter and Firebase. Icons from Material Icons. '
              'Built with ❤️ by the AgeEmpower team.',
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.center,
              child: Text(
                '© 2025 AgeEmpower Inc.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
