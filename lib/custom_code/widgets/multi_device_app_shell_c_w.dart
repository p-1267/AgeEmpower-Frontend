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

import '/custom_code/widgets/index.dart'; // AppThemeCW + ResponsiveLayoutEngineCW + dashboards
import 'package:cloud_firestore/cloud_firestore.dart';

class MultiDeviceAppShellCW extends StatelessWidget {
  final Widget content;

  const MultiDeviceAppShellCW({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    // Get responsive engine from parent
    final engine = ResponsiveLayoutEngineCW.of(context);

    if (engine.isMobile) return _buildMobileShell(context, engine);
    if (engine.isTablet) return _buildTabletShell(context, engine);
    if (engine.isDesktop) return _buildDesktopShell(context, engine);
    return _buildUltraWideShell(context, engine);
  }

  // ---------------------------------------------------------------------------
  // MOBILE SHELL (BOTTOM NAVIGATION)
  // ---------------------------------------------------------------------------
  Widget _buildMobileShell(BuildContext context, ResponsiveEngine engine) {
    final controller = GlobalAppControllerCW.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: content,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndexForContent(content),
        onTap: (i) => _handleNavTap(context, i),
        selectedItemColor: controller.themeSettings["highContrast"] == true
            ? Colors.black
            : controller.isMobile
                ? controller.themeSettings["highContrast"] == true
                    ? Colors.black
                    : Colors.blue.shade700
                : Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded), label: "Chat"),
          BottomNavigationBarItem(
              icon: Icon(Icons.health_and_safety), label: "Health"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded), label: "Settings"),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TABLET SHELL (LEFT SIDE NAV)
  // ---------------------------------------------------------------------------
  Widget _buildTabletShell(BuildContext context, ResponsiveEngine engine) {
    final controller = GlobalAppControllerCW.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Row(
        children: [
          _buildSideNav(context, controller),
          Expanded(
            child: SafeArea(
              child: Center(
                child: Container(
                  width: engine.safeWidth,
                  child: content,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DESKTOP SHELL (SIDEBAR + HEADER)
  // ---------------------------------------------------------------------------
  Widget _buildDesktopShell(BuildContext context, ResponsiveEngine engine) {
    final controller = GlobalAppControllerCW.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Row(
        children: [
          _buildSideNav(context, controller, wide: true),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(context, controller),
                Expanded(
                  child: Center(
                    child: Container(
                      width: engine.safeWidth,
                      child: content,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ULTRA-WIDE SHELL (dashboard-style two/three-column layout)
  // ---------------------------------------------------------------------------
  Widget _buildUltraWideShell(BuildContext context, ResponsiveEngine engine) {
    final controller = GlobalAppControllerCW.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Row(
        children: [
          _buildSideNav(context, controller, wide: true),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(context, controller),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: content),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildSecondaryPanel(controller),
                      ),
                      if (engine.columnCount == 3) ...[
                        const SizedBox(width: 20),
                        Expanded(child: _buildTertiaryPanel(controller)),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SIDE NAVIGATION
  // ---------------------------------------------------------------------------
  Widget _buildSideNav(BuildContext context, GlobalAppControllerCWState c,
      {bool wide = false}) {
    return Container(
      width: wide ? 240 : 80,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Icon(Icons.apps_rounded,
              size: wide ? 48 : 32,
              color: c.themeSettings["highContrast"] == true
                  ? Colors.black
                  : c.role == "agency"
                      ? Colors.indigo.shade800
                      : Colors.blue.shade700),
          const SizedBox(height: 40),
          _sideNavItem(context, Icons.home_rounded, "Home", 0, wide),
          _sideNavItem(context, Icons.chat_bubble_rounded, "Chat", 1, wide),
          _sideNavItem(context, Icons.health_and_safety, "Health", 2, wide),
          _sideNavItem(context, Icons.settings_rounded, "Settings", 3, wide),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _sideNavItem(
      BuildContext context, IconData icon, String label, int index, bool wide) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: () => _handleNavTap(context, index),
        child: Row(
          mainAxisAlignment:
              wide ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.grey.shade700),
            if (wide) ...[
              const SizedBox(width: 12),
              Text(label,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ]
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TOP BAR FOR DESKTOP / ULTRA-WIDE
  // ---------------------------------------------------------------------------
  Widget _buildTopBar(BuildContext context, GlobalAppControllerCWState c) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        children: [
          Text(
            c.profile["name"] != null
                ? "Welcome, ${c.profile["name"]}"
                : "Dashboard",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          _topIcon(Icons.notifications, c.unreadNotifications > 0),
          const SizedBox(width: 24),
          _topIcon(Icons.chat_bubble_rounded, c.unreadChatCount > 0),
        ],
      ),
    );
  }

  Widget _topIcon(IconData icon, bool highlight) {
    return Stack(
      children: [
        Icon(icon, size: 28),
        if (highlight)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          )
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // ULTRA-WIDE SECONDARY/TERTIARY PANELS
  // ---------------------------------------------------------------------------
  Widget _buildSecondaryPanel(GlobalAppControllerCWState c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (c.hasActiveEmergency)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red)),
            child: const Text("Active Emergency Detected!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  Widget _buildTertiaryPanel(GlobalAppControllerCWState c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Notifications",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        for (var n in c.recentNotifications.take(5))
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              n["type"] ?? "Notification",
              style: const TextStyle(fontSize: 16),
            ),
          )
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // NAV MAP
  // ---------------------------------------------------------------------------
  int _navIndexForContent(Widget widget) {
    final name = widget.runtimeType.toString();
    if (name.contains("HomeDashboard")) return 0;
    if (name.contains("Chat")) return 1;
    if (name.contains("Health")) return 2;
    return 3;
  }

  void _handleNavTap(BuildContext context, int index) {
    final c = GlobalAppControllerCW.of(context);

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => c.buildHomeForUser()),
        );
        break;
      case 1:
        c.openChatList(context);
        break;
      case 2:
        c.openReports(context);
        break;
      case 3:
        c.openVoiceSettings(context);
        break;
    }
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
