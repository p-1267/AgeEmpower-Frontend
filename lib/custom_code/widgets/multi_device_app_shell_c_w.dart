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

import 'responsive_layout_engine_c_w.dart';
import 'global_app_controller_c_w.dart';

class MultiDeviceAppShellCW extends StatelessWidget {
  final Widget content;

  const MultiDeviceAppShellCW({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure engine exists (safe even if parent already wrapped)
    return ResponsiveLayoutEngineCW.build(
      context: context,
      child: Builder(
        builder: (context) {
          final engine = ResponsiveLayoutEngineCW.of(context);

          // IMPORTANT: do NOT type this as GlobalAppControllerCWState (private/removed)
          final c = GlobalAppControllerCW.of(context);

          if (engine.useBottomNav) {
            return _MobileShell(
              engine: engine,
              controller: c,
              content: content,
            );
          }

          return _DesktopShell(
            engine: engine,
            controller: c,
            content: content,
          );
        },
      ),
    );
  }
}

/// ----------------------------
/// Mobile / Tablet shell
/// ----------------------------
class _MobileShell extends StatelessWidget {
  final ResponsiveLayoutEngineCW engine;
  final dynamic controller;
  final Widget content;

  const _MobileShell({
    required this.engine,
    required this.controller,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: engine.contentMaxWidth),
            child: content,
          ),
        ),
      ),
      bottomNavigationBar: _BottomNav(
        controller: controller,
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final dynamic controller;

  const _BottomNav({required this.controller});

  int _indexForRouteKey(String key) {
    switch (key) {
      case 'home':
        return 0;
      case 'health':
        return 1;
      case 'medications':
        return 2;
      case 'messages':
        return 3;
      case 'emergency':
        return 4;
      default:
        return 0;
    }
  }

  String _routeKeyForIndex(int index) {
    switch (index) {
      case 0:
        return 'home';
      case 1:
        return 'health';
      case 2:
        return 'medications';
      case 3:
        return 'messages';
      case 4:
        return 'emergency';
      default:
        return 'home';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentKey = (controller.currentRouteKey ?? 'home') as String;
    final currentIndex = _indexForRouteKey(currentKey);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) {
        final key = _routeKeyForIndex(i);
        // Preferred: routeKey navigation (no pushNamed issues)
        controller.setRouteKey(key, tabIndex: i);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety_rounded), label: 'Health'),
        BottomNavigationBarItem(
            icon: Icon(Icons.medication_rounded), label: 'Meds'),
        BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_rounded), label: 'Chat'),
        BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber_rounded), label: 'SOS'),
      ],
    );
  }
}

/// ----------------------------
/// Desktop / UltraWide shell
/// ----------------------------
class _DesktopShell extends StatelessWidget {
  final ResponsiveLayoutEngineCW engine;
  final dynamic controller;
  final Widget content;

  const _DesktopShell({
    required this.engine,
    required this.controller,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Row(
          children: [
            _SideNav(controller: controller),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: engine.contentMaxWidth),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: engine.horizontalPadding),
                    child: content,
                  ),
                ),
              ),
            ),

            // Optional right panel only for ultra wide
            if (engine.isUltraWide)
              SizedBox(
                width: 320,
                child: _RightPanel(controller: controller),
              ),
          ],
        ),
      ),
    );
  }
}

class _SideNav extends StatelessWidget {
  final dynamic controller;

  const _SideNav({required this.controller});

  bool _isSelected(String key) =>
      ((controller.currentRouteKey ?? 'home') as String) == key;

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String routeKey,
  }) {
    final selected = _isSelected(routeKey);

    return InkWell(
      onTap: () => controller.setRouteKey(routeKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? FlutterFlowTheme.of(context).secondaryBackground
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: selected
                  ? FlutterFlowTheme.of(context).primaryText
                  : FlutterFlowTheme.of(context).secondaryText,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                    color: selected
                        ? FlutterFlowTheme.of(context).primaryText
                        : FlutterFlowTheme.of(context).secondaryText,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // role/profile fields may exist or not depending on controller version
    final String role =
        (controller.userRole ?? controller.role ?? 'senior') as String;

    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        border: Border(
          right: BorderSide(color: FlutterFlowTheme.of(context).alternate),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.shield_rounded),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Age Empower',
                  style: FlutterFlowTheme.of(context)
                      .titleMedium
                      .copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _item(context,
              icon: Icons.home_rounded, label: 'Home', routeKey: 'home'),
          const SizedBox(height: 8),
          _item(context,
              icon: Icons.health_and_safety_rounded,
              label: 'Health',
              routeKey: 'health'),
          const SizedBox(height: 8),
          _item(context,
              icon: Icons.medication_rounded,
              label: 'Medications',
              routeKey: 'medications'),
          const SizedBox(height: 8),
          _item(context,
              icon: Icons.chat_bubble_rounded,
              label: 'Messages',
              routeKey: 'messages'),
          const SizedBox(height: 8),
          _item(context,
              icon: Icons.warning_amber_rounded,
              label: 'Emergency',
              routeKey: 'emergency'),
          const Spacer(),
          if (role == 'agency')
            _item(context,
                icon: Icons.apartment_rounded,
                label: 'Agency',
                routeKey: 'agency'),
          const SizedBox(height: 8),
          _item(context,
              icon: Icons.settings_rounded,
              label: 'Settings',
              routeKey: 'settings'),
        ],
      ),
    );
  }
}

class _RightPanel extends StatelessWidget {
  final dynamic controller;

  const _RightPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    final int unreadNoti = (controller.unreadNotifications ?? 0) is int
        ? controller.unreadNotifications
        : 0;
    final int unreadChat = (controller.unreadChatCount ?? 0) is int
        ? controller.unreadChatCount
        : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        border: Border(
          left: BorderSide(color: FlutterFlowTheme.of(context).alternate),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Status',
              style: FlutterFlowTheme.of(context)
                  .titleSmall
                  .copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          _statRow(context, Icons.notifications_rounded, 'Notifications',
              unreadNoti),
          const SizedBox(height: 10),
          _statRow(
              context, Icons.chat_bubble_rounded, 'Unread Chats', unreadChat),
          const SizedBox(height: 18),
          Divider(color: FlutterFlowTheme.of(context).alternate),
          const SizedBox(height: 12),
          Text(
            'Tip: use the left menu to navigate.',
            style: FlutterFlowTheme.of(context).bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _statRow(
      BuildContext context, IconData icon, String label, int count) {
    return Row(
      children: [
        Icon(icon, size: 18, color: FlutterFlowTheme.of(context).secondaryText),
        const SizedBox(width: 10),
        Expanded(
            child: Text(label, style: FlutterFlowTheme.of(context).bodyMedium)),
        if (count > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: FlutterFlowTheme.of(context).primary,
            ),
            child: Text(
              '$count',
              style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          )
        else
          Text('0', style: FlutterFlowTheme.of(context).bodySmall),
      ],
    );
  }
}
