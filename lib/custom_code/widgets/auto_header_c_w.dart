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

class AutoHeaderCW extends StatelessWidget {
  final String? title;
  final bool showBack;

  const AutoHeaderCW({
    super.key,
    this.title,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = GlobalAppControllerCW.of(context);
    final r = ResponsiveLayoutEngineCW.of(context);

    final String displayTitle = title ??
        (c.profile["name"] != null
            ? "Welcome, ${c.profile["name"]}"
            : "Dashboard");

    return Container(
      height: r.isMobile ? 56 : 72,
      padding: EdgeInsets.symmetric(
        horizontal: r.isMobile ? 16 : 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.pop(context),
            ),

          // TITLE
          Expanded(
            child: Text(
              displayTitle,
              style: TextStyle(
                fontSize: r.isMobile ? 20 : 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // NOTIFICATION ICON
          Stack(
            children: [
              Icon(Icons.notifications_none_rounded,
                  size: r.isMobile ? 26 : 30),
              if (c.unreadNotifications > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: r.isMobile ? 8 : 10,
                    height: r.isMobile ? 8 : 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(width: 20),

          // CHAT ICON
          Stack(
            children: [
              Icon(Icons.chat_bubble_outline_rounded,
                  size: r.isMobile ? 26 : 30),
              if (c.unreadChatCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: r.isMobile ? 8 : 10,
                    height: r.isMobile ? 8 : 10,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
