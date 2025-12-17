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

// Core imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math';
import 'package:age_empower/custom_code/widgets/global_app_controller_c_w.dart';

class GlobalAppControllerCW extends StatefulWidget {
  final Widget? child;

  const GlobalAppControllerCW({super.key, this.child});

  static _GlobalAppControllerCWState of(BuildContext context) {
    final state =
        context.findAncestorStateOfType<_GlobalAppControllerCWState>();
    if (state == null) {
      throw Exception("GlobalAppControllerCW not found in widget tree");
    }
    return state;
  }

  @override
  State<GlobalAppControllerCW> createState() => _GlobalAppControllerCWState();
}

/// ✅ REQUIRED PUBLIC ALIAS — DO NOT DELETE
typedef GlobalAppControllerCWState = _GlobalAppControllerCWState;

class _GlobalAppControllerCWState extends State<GlobalAppControllerCW> {
  // ----------------------------
  // AUTH / USER
  // ----------------------------
  String? uid;
  Map<String, dynamic> userData = {};
  String userRole = "senior";
  bool loadingUser = true;

  bool get isLoggedIn => uid != null;

  // ----------------------------
  // ROUTING
  // ----------------------------
  String currentRouteKey = "home";
  int activeTab = 0;

  void setRouteKey(String routeKey, {int? tabIndex}) {
    currentRouteKey = routeKey;
    if (tabIndex != null) activeTab = tabIndex;
    if (mounted) setState(() {});
  }

  // ----------------------------
  // RESPONSIVE FLAGS
  // ----------------------------
  bool isMobile = true;
  bool isTablet = false;
  bool isDesktop = false;
  bool isUltraWide = false;
  double deviceWidth = 0;

  // ----------------------------
  // STREAMS
  // ----------------------------
  StreamSubscription? emergencySub;
  StreamSubscription? chatSub;
  StreamSubscription? notificationSub;
  StreamSubscription? caregiverTaskSub;
  StreamSubscription? healthSub;
  StreamSubscription<User?>? authSub;

  List<Map<String, dynamic>> emergencyEvents = [];
  List<Map<String, dynamic>> unreadMessages = [];
  List<Map<String, dynamic>> notifications = [];
  Map<String, dynamic> healthSnapshot = {};
  List<Map<String, dynamic>> caregiverTasks = [];

  // ----------------------------
  // SETTINGS
  // ----------------------------
  String languageCode = "en";
  double fontScale = 1.0;
  bool highContrast = false;
  bool largeTouchTargets = false;

  Map<String, dynamic> get themeSettings => {
        "fontScale": fontScale,
        "highContrast": highContrast,
        "largeTouchTargets": largeTouchTargets,
      };

  // ----------------------------
  // OFFLINE
  // ----------------------------
  bool isOnline = true;
  List<Map<String, dynamic>> offlineQueue = [];

  bool get hasOfflineItems => offlineQueue.isNotEmpty;

  // ----------------------------
  // INIT / DISPOSE
  // ----------------------------
  @override
  void initState() {
    super.initState();
    _bootstrap();
    _listenAuthChanges();
  }

  @override
  void dispose() {
    emergencySub?.cancel();
    chatSub?.cancel();
    notificationSub?.cancel();
    caregiverTaskSub?.cancel();
    healthSub?.cancel();
    authSub?.cancel();
    emergencyEscalationTimer?.cancel();
    super.dispose();
  }

  // ----------------------------
  // AUTH
  // ----------------------------
  void _listenAuthChanges() {
    authSub = FirebaseAuth.instance.authStateChanges().listen((user) async {
      uid = user?.uid;

      emergencyEvents.clear();
      unreadMessages.clear();
      notifications.clear();
      caregiverTasks.clear();
      healthSnapshot = {};

      await emergencySub?.cancel();
      await chatSub?.cancel();
      await notificationSub?.cancel();
      await caregiverTaskSub?.cancel();
      await healthSub?.cancel();

      if (uid == null) {
        currentRouteKey = "login";
        loadingUser = false;
        if (mounted) setState(() {});
        return;
      }

      loadingUser = true;
      if (mounted) setState(() {});

      await _loadUserProfile();
      await loadSettings();

      _initListeners();
      startEmergencyEscalationLoop();

      currentRouteKey = "home";
      loadingUser = false;
      if (mounted) setState(() {});
    });
  }

  Future<void> _bootstrap() async {
    uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      loadingUser = false;
      currentRouteKey = "login";
      setState(() {});
      return;
    }

    await _loadUserProfile();
    await loadSettings();
    _initListeners();
    startEmergencyEscalationLoop();

    loadingUser = false;
    if (mounted) setState(() {});
  }

  Future<void> _loadUserProfile() async {
    if (uid == null) return;
    final doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    userData = doc.data() ?? {};
    userRole = userData["role"] ?? "senior";
  }

  // ----------------------------
  // LISTENERS
  // ----------------------------
  void _initListeners() {
    _initEmergencyListener();
    _initNotificationListener();
    _initChatListener();
    _initHealthListener();
    _initCaregiverTaskListener();
  }

  void _initEmergencyListener() {
    emergencySub = FirebaseFirestore.instance
        .collection("emergencies")
        .where("userId", isEqualTo: uid)
        .snapshots()
        .listen((s) {
      emergencyEvents = s.docs.map((e) => e.data()).toList();
      if (mounted) setState(() {});
    });
  }

  void _initNotificationListener() {
    notificationSub = FirebaseFirestore.instance
        .collection("notifications")
        .where("toUser", isEqualTo: uid)
        .snapshots()
        .listen((s) {
      notifications = s.docs.map((e) => e.data()).toList();
      if (mounted) setState(() {});
    });
  }

  void _initChatListener() {
    chatSub = FirebaseFirestore.instance
        .collection("messages")
        .where("receiverId", isEqualTo: uid)
        .where("read", isEqualTo: false)
        .snapshots()
        .listen((s) {
      unreadMessages = s.docs.map((e) => e.data()).toList();
      if (mounted) setState(() {});
    });
  }

  void _initHealthListener() {
    healthSub = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("health")
        .limit(1)
        .snapshots()
        .listen((s) {
      if (s.docs.isNotEmpty) {
        healthSnapshot = s.docs.first.data();
      }
      if (mounted) setState(() {});
    });
  }

  void _initCaregiverTaskListener() {
    caregiverTaskSub = FirebaseFirestore.instance
        .collection("tasks")
        .where("assignedTo", isEqualTo: uid)
        .snapshots()
        .listen((s) {
      caregiverTasks = s.docs.map((e) => e.data()).toList();
      if (mounted) setState(() {});
    });
  }

  // ----------------------------
  // ROUTER
  // ----------------------------
  Widget buildHomeForUser() {
    switch (userRole) {
      case "caregiver":
        return MultiDeviceAppShellCW(content: CaregiverTaskListCW());
      case "agency":
        return MultiDeviceAppShellCW(
            content: AgencyDashboardSummaryCW(userId: uid));
      default:
        return MultiDeviceAppShellCW(content: HomeDashboardCW());
    }
  }

  Widget buildForRouteKey() {
    if (!isLoggedIn) {
      return MultiDeviceAppShellCW(content: LoginSignupCW());
    }

    switch (currentRouteKey) {
      case "health":
        return MultiDeviceAppShellCW(
            content: HealthOverviewCardCW(userId: uid));
      case "messages":
        return MultiDeviceAppShellCW(content: ChatListCW());
      case "emergency":
        return MultiDeviceAppShellCW(content: FamilyEmergencyMonitorCW());
      default:
        return buildHomeForUser();
    }
  }

  // ----------------------------
  // ESCALATION
  // ----------------------------
  Timer? emergencyEscalationTimer;

  void startEmergencyEscalationLoop() {
    emergencyEscalationTimer?.cancel();
    emergencyEscalationTimer =
        Timer.periodic(const Duration(seconds: 15), (_) {});
  }

  // ----------------------------
  // BUILD
  // ----------------------------
  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    isMobile = deviceWidth < 600;
    isTablet = deviceWidth >= 600 && deviceWidth < 1024;
    isDesktop = deviceWidth >= 1024;

    if (loadingUser) {
      return const Center(child: CircularProgressIndicator());
    }

    return _GlobalExports(
      controller: this,
      child: widget.child ?? buildForRouteKey(),
    );
  }
}

// ----------------------------
// INHERITED EXPORT
// ----------------------------
class _GlobalExports extends InheritedWidget {
  final GlobalAppControllerCWState controller;

  const _GlobalExports({
    required super.child,
    required this.controller,
  });

  static GlobalAppControllerCWState of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<_GlobalExports>();
    if (result == null) {
      throw Exception("GlobalAppControllerCW not found.");
    }
    return result.controller;
  }

  @override
  bool updateShouldNotify(_) => true;
}
