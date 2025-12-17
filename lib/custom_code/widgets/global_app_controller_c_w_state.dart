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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math';

/// ✅ Backward-compatible alias (some files still reference this)
typedef GlobalAppControllerCWState = _GlobalAppControllerCWState;

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

class _GlobalAppControllerCWState extends State<GlobalAppControllerCW> {
  // ----------------------------
  // AUTH / USER
  // ----------------------------
  String? uid;
  Map<String, dynamic> userData = {};
  String userRole = "senior";
  bool loadingUser = true;

  bool get isLoggedIn => uid != null;

  /// ✅ These are expected by other widgets
  String get role => userRole;
  Map<String, dynamic> get profile => userData;

  // ----------------------------
  // ROUTE KEY NAV
  // ----------------------------
  String currentRouteKey = "home";
  int activeTab = 0;

  void setRouteKey(String routeKey, {int? tabIndex}) {
    currentRouteKey = routeKey;
    if (tabIndex != null) activeTab = tabIndex;
    if (mounted) setState(() {});
  }

  // ----------------------------
  // Responsive flags (optional)
  // ----------------------------
  bool isMobile = true;
  bool isTablet = false;
  bool isDesktop = false;
  bool isUltraWide = false;
  double deviceWidth = 0;

  void _updateResponsiveEngine(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    isMobile = deviceWidth < 600;
    isTablet = deviceWidth >= 600 && deviceWidth < 1024;
    isDesktop = deviceWidth >= 1024 && deviceWidth < 1440;
    isUltraWide = deviceWidth >= 1440;
  }

  // ----------------------------
  // Streams & caches
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
  // Settings / theme
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
  // Offline queue
  // ----------------------------
  bool isOnline = true;
  List<Map<String, dynamic>> offlineQueue = [];

  bool get hasOfflineItems => offlineQueue.isNotEmpty;

  // ----------------------------
  // Timers
  // ----------------------------
  Timer? emergencyEscalationTimer;

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
  // Bootstrap + auth changes
  // ----------------------------
  void _listenAuthChanges() {
    authSub = FirebaseAuth.instance.authStateChanges().listen((user) async {
      final newUid = user?.uid;
      if (newUid == uid) return;

      uid = newUid;

      // reset caches
      userData = {};
      userRole = "senior";
      emergencyEvents = [];
      unreadMessages = [];
      notifications = [];
      healthSnapshot = {};
      caregiverTasks = [];

      // stop listeners
      await emergencySub?.cancel();
      await chatSub?.cancel();
      await notificationSub?.cancel();
      await caregiverTaskSub?.cancel();
      await healthSub?.cancel();

      if (uid == null) {
        loadingUser = false;
        currentRouteKey = "login";
        if (mounted) setState(() {});
        return;
      }

      loadingUser = true;
      if (mounted) setState(() {});

      await _loadUserProfile();
      await loadSettings();

      _initEmergencyListener();
      _initNotificationListener();
      _initChatListener();
      _initHealthListener();
      _initCaregiverTaskListener();

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
      if (mounted) setState(() {});
      return;
    }

    await _loadUserProfile();
    await loadSettings();

    _initEmergencyListener();
    _initNotificationListener();
    _initChatListener();
    _initHealthListener();
    _initCaregiverTaskListener();

    startEmergencyEscalationLoop();

    loadingUser = false;
    if (mounted) setState(() {});
  }

  Future<void> _loadUserProfile() async {
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    userData = doc.data() ?? {};
    userRole = (userData["role"] ?? "senior").toString();

    if (!isLoggedIn) {
      currentRouteKey = "login";
    } else {
      currentRouteKey = (currentRouteKey == "login") ? "home" : currentRouteKey;
    }
  }

  // ----------------------------
  // Settings loader (required by errors)
  // ----------------------------
  Future<void> loadSettings() async {
    if (uid == null) return;

    try {
      final langDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("settings")
          .doc("language")
          .get();

      if (langDoc.exists) {
        languageCode = (langDoc.data()?["code"] ?? "en").toString();
      }

      final accDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("settings")
          .doc("accessibility")
          .get();

      if (accDoc.exists) {
        final d = accDoc.data() ?? {};
        fontScale = (d["fontScale"] ?? 1.0).toDouble();
        highContrast = d["highContrast"] ?? false;
        largeTouchTargets = d["largeTouchTargets"] ?? false;
      }
    } catch (_) {
      // keep defaults
    }

    if (mounted) setState(() {});
  }

  // ----------------------------
  // Firestore listeners
  // ----------------------------
  void _initEmergencyListener() {
    if (uid == null) return;
    emergencySub = FirebaseFirestore.instance
        .collection("emergencies")
        .where("userId", isEqualTo: uid)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .listen((snapshot) {
      emergencyEvents = snapshot.docs.map((e) => e.data()).toList();
      if (mounted) setState(() {});
    });
  }

  void _initNotificationListener() {
    if (uid == null) return;
    notificationSub = FirebaseFirestore.instance
        .collection("notifications")
        .where("toUser", isEqualTo: uid)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .listen((snapshot) {
      notifications = snapshot.docs.map((e) => e.data()).toList();
      if (mounted) setState(() {});
    });
  }

  void _initChatListener() {
    if (uid == null) return;
    chatSub = FirebaseFirestore.instance
        .collection("messages")
        .where("receiverId", isEqualTo: uid)
        .where("read", isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      unreadMessages = snapshot.docs.map((e) => e.data()).toList();
      if (mounted) setState(() {});
    });
  }

  void _initHealthListener() {
    if (uid == null) return;
    healthSub = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("health")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .snapshots()
        .listen((snap) {
      if (snap.docs.isNotEmpty) {
        healthSnapshot = snap.docs.first.data();
      }
      if (mounted) setState(() {});
    });
  }

  void _initCaregiverTaskListener() {
    if (uid == null) return;
    caregiverTaskSub = FirebaseFirestore.instance
        .collection("tasks")
        .where("assignedTo", isEqualTo: uid)
        .snapshots()
        .listen((snap) {
      caregiverTasks = snap.docs.map((e) => e.data()).toList();
      if (mounted) setState(() {});
    });
  }

  // ----------------------------
  // Required helpers for other widgets
  // ----------------------------
  int get unreadChatCount => unreadMessages.length;

  int get unreadNotifications =>
      notifications.where((n) => n["status"] != "read").length;

  List<Map<String, dynamic>> get recentNotifications => notifications;

  bool get hasActiveEmergency =>
      emergencyEvents.any((e) => e["resolved"] == false);

  Map<String, dynamic>? get latestEmergency =>
      emergencyEvents.isEmpty ? null : emergencyEvents.first;

  Map<String, dynamic> get latestHealth => healthSnapshot;

  int get latestHeartRate => (healthSnapshot["heartRate"] ?? 0) as int;
  int get latestSteps => (healthSnapshot["steps"] ?? 0) as int;
  double get latestSleepHours => (healthSnapshot["sleepHours"] ?? 0).toDouble();

  int get healthRiskScore {
    int score = 0;
    if (latestHeartRate < 50 || latestHeartRate > 110) score += 40;
    if (latestSteps < 2000) score += 25;
    if (latestSleepHours < 6) score += 20;
    return min(score, 100);
  }

  // ----------------------------
  // Offline sync (required by GlobalSyncStatus)
  // ----------------------------
  void updateOnlineStatus(bool online) {
    isOnline = online;
    if (mounted) setState(() {});
  }

  void queueOfflineWrite({
    required String type,
    required String path,
    Map<String, dynamic>? payload,
  }) {
    offlineQueue.add({
      "type": type,
      "path": path,
      "payload": payload ?? {},
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });
    if (mounted) setState(() {});
  }

  Future<void> syncNow() async {
    if (uid == null || offlineQueue.isEmpty) return;

    final pending = List<Map<String, dynamic>>.from(offlineQueue);
    for (final op in pending) {
      try {
        if (op["type"] == "set") {
          await FirebaseFirestore.instance.doc(op["path"]).set(op["payload"]);
        } else if (op["type"] == "update") {
          await FirebaseFirestore.instance
              .doc(op["path"])
              .update(op["payload"]);
        } else if (op["type"] == "delete") {
          await FirebaseFirestore.instance.doc(op["path"]).delete();
        }
        offlineQueue.remove(op);
      } catch (_) {}
    }

    if (mounted) setState(() {});
  }

  // ----------------------------
  // Escalation engine (safe to keep)
  // ----------------------------
  void startEmergencyEscalationLoop() {
    emergencyEscalationTimer?.cancel();
    emergencyEscalationTimer =
        Timer.periodic(const Duration(seconds: 15), (_) async {
      if (emergencyEvents.isEmpty || uid == null) return;

      for (final e in emergencyEvents) {
        if (e["resolved"] == true) continue;

        final ts = (e["timestamp"] as Timestamp?)?.toDate();
        if (ts == null) continue;

        final elapsed = DateTime.now().difference(ts).inSeconds;
        final eventId = (e["eventId"] ?? "").toString();
        if (eventId.isEmpty) continue;

        if (elapsed > 120 && e["agencyStatus"] != "sent") {
          await _sendEscalationTo("agency", eventId);
        } else if (elapsed > 60 && e["familyStatus"] != "sent") {
          await _sendEscalationTo("family", eventId);
        } else if (elapsed > 30 && e["caregiverStatus"] != "sent") {
          await _sendEscalationTo("caregiver", eventId);
        }
      }
    });
  }

  Future<void> _sendEscalationTo(String target, String eventId) async {
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    final data = doc.data() ?? {};

    final caregivers = (data["caregivers"] ?? []) as List;
    final family = (data["family"] ?? []) as List;
    final agency = data["agency"];

    List recipients = [];
    if (target == "caregiver") recipients = caregivers;
    if (target == "family") recipients = family;
    if (target == "agency" && agency != null) recipients = [agency];

    for (final r in recipients) {
      await FirebaseFirestore.instance.collection("notifications").add({
        "toUser": r,
        "eventId": eventId,
        "type": "emergency_escalation",
        "target": target,
        "timestamp": FieldValue.serverTimestamp(),
        "status": "sent",
      });
    }

    await FirebaseFirestore.instance
        .collection("emergencies")
        .doc(eventId)
        .update({"${target}Status": "sent"});

    if (mounted) setState(() {});
  }

  // ----------------------------
  // Routing (safe fallback)
  // ----------------------------
  Widget buildForRouteKey() {
    if (!isLoggedIn) {
      return widget.child ?? const SizedBox.shrink();
    }
    return widget.child ?? const SizedBox.shrink();
  }

  // ----------------------------
  // Build
  // ----------------------------
  @override
  Widget build(BuildContext context) {
    _updateResponsiveEngine(context);

    if (loadingUser) {
      return const Center(
        child:
            SizedBox(width: 60, height: 60, child: CircularProgressIndicator()),
      );
    }

    return widget.child ?? buildForRouteKey();
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
