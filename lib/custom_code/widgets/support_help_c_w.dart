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

class SupportHelpCW extends StatelessWidget {
  const SupportHelpCW({Key? key, this.width, this.height}) : super(key: key);

  final double? width;
  final double? height;

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
            const Text('Help & Support',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              'Need assistance or want to reach us? Use the links below. '
              'These will open your email or browser.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Frequently Asked Questions'),
              trailing: const Icon(Icons.open_in_new, size: 18),
              onTap: () => launchURL('https://yourwebsite.com/faq'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Contact Support'),
              trailing: const Icon(Icons.open_in_new, size: 18),
              onTap: () => launchURL(
                'mailto:support@yourapp.com?subject=Support%20Request',
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.bug_report_outlined),
              title: const Text('Report a Bug'),
              trailing: const Icon(Icons.open_in_new, size: 18),
              onTap: () => launchURL(
                'mailto:bugs@yourapp.com?subject=Bug%20Report',
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.open_in_new, size: 18),
              onTap: () => launchURL('https://yourwebsite.com/privacy'),
            ),
          ],
        ),
      ),
    );
  }
}
