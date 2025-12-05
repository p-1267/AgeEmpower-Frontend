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
// DO NOT REMOVE ABOVE

// Core imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math';

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
  String? uid;
  Map<String, dynamic> userData = {};
  String userRole = "senior";
  bool loadingUser = true;

  // Responsive flags
  bool isMobile = true;
  bool isTablet = false;
  bool isDesktop = false;
  bool isUltraWide = false;
  double deviceWidth = 0;

  // Global streams & caches
  StreamSubscription? emergencySub;
  StreamSubscription? chatSub;
  StreamSubscription? notificationSub;
  StreamSubscription? caregiverTaskSub;
  StreamSubscription? healthSub;

  List<Map<String, dynamic>> emergencyEvents = [];
  List<Map<String, dynamic>> unreadMessages = [];
  List<Map<String, dynamic>> notifications = [];
  Map<String, dynamic> healthSnapshot = {};
  List<Map<String, dynamic>> caregiverTasks = [];

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      loadingUser = false;
      setState(() {});
      return;
    }

    await _loadUserProfile();
    _initEmergencyListener();
    _initNotificationListener();
    _initChatListener();
    _initHealthListener();
    _initCaregiverTaskListener();

    loadingUser = false;
    if (mounted) setState(() {});
  }

  Future<void> _loadUserProfile() async {
    final doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    userData = doc.data() ?? {};
    userRole = userData["role"] ?? "senior";
  }

  void _updateResponsiveEngine(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;

    isMobile = deviceWidth < 600;
    isTablet = deviceWidth >= 600 && deviceWidth < 1024;
    isDesktop = deviceWidth >= 1024 && deviceWidth < 1440;
    isUltraWide = deviceWidth >= 1440;
  }

  // Listeners ------------------------------------------------------

  void _initEmergencyListener() {
    emergencySub = FirebaseFirestore.instance
        .collection("emergencies")
        .where("userId", isEqualTo: uid)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .listen((snapshot) {
      emergencyEvents = snapshot.docs.map((e) => e.data()).toList();
      setState(() {});
    });
  }

  void _initNotificationListener() {
    notificationSub = FirebaseFirestore.instance
        .collection("notifications")
        .where("toUser", isEqualTo: uid)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .listen((snapshot) {
      notifications = snapshot.docs.map((e) => e.data()).toList();
      setState(() {});
    });
  }

  void _initChatListener() {
    chatSub = FirebaseFirestore.instance
        .collection("messages")
        .where("receiverId", isEqualTo: uid)
        .where("read", isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      unreadMessages = snapshot.docs.map((e) => e.data()).toList();
      setState(() {});
    });
  }

  void _initHealthListener() {
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
      setState(() {});
    });
  }

  void _initCaregiverTaskListener() {
    caregiverTaskSub = FirebaseFirestore.instance
        .collection("tasks")
        .where("assignedTo", isEqualTo: uid)
        .snapshots()
        .listen((snap) {
      caregiverTasks = snap.docs.map((e) => e.data()).toList();
      setState(() {});
    });
  }

  // Role router ----------------------------------------------------

  Widget _routeForRole(String role) {
    switch (role) {
      case "senior":
        return MultiDeviceAppShellCW(content: HomeDashboardCW());
      case "family":
        return MultiDeviceAppShellCW(content: HomeDashboardCW());
      case "caregiver":
        return MultiDeviceAppShellCW(content: CaregiverTaskListCW());
      case "agency":
        return MultiDeviceAppShellCW(
            content: AgencyDashboardSummaryCW(userId: uid));
      default:
        return MultiDeviceAppShellCW(content: HomeDashboardCW());
    }
  }

  Widget buildHomeForUser() => _routeForRole(userRole);

  // Navigation helpers --------------------------------------------

  void openChatThread(BuildContext context, String partnerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => Scaffold(body: ChatThreadCW(partnerId: partnerId))),
    );
  }

  void openChatList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Scaffold(body: ChatListCW())),
    );
  }

  void openEmergencyHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => Scaffold(body: FamilyEmergencyMonitorCW())),
    );
  }

  void openAppointments(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Scaffold(body: AppointmentListCW())),
    );
  }

  void openReports(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Scaffold(body: ReportsWrapperPageCW())),
    );
  }

  void openDeviceIntegrations(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => Scaffold(body: DeviceIntegrationDashboardCW())),
    );
  }

  void openSecurityCenter(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Column(
                  children: [
                    SecuritySessionsListCW(),
                    SecurityActivityLogCW(),
                    SecurityRemoteWipeCW(),
                    SecurityDataExportCW(),
                  ],
                ),
              )),
    );
  }

  void openVoiceSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Column(
                  children: [
                    VoiceSettingsMainCW(),
                    VoiceKeywordEditorCW(),
                    VoiceLanguageSelectorCW(),
                  ],
                ),
              )),
    );
  }

  // Emergency helpers ---------------------------------------------

  bool get hasActiveEmergency =>
      emergencyEvents.any((e) => e["resolved"] == false);

  Map<String, dynamic>? get latestEmergency =>
      emergencyEvents.isEmpty ? null : emergencyEvents.first;

  List<Map<String, dynamic>> get allEmergencies => emergencyEvents;

  // Chat helpers ---------------------------------------------------

  int get unreadChatCount => unreadMessages.length;

  List<Map<String, dynamic>> get unreadChats => unreadMessages;

  // Notification helpers -------------------------------------------

  int get unreadNotifications =>
      notifications.where((n) => n["status"] != "read").length;

  List<Map<String, dynamic>> get recentNotifications => notifications;

  // Caregiver helpers ----------------------------------------------

  int get openTaskCount =>
      caregiverTasks.where((t) => t["completed"] == false).length;

  List<Map<String, dynamic>> get tasks => caregiverTasks;

  // Health helpers -------------------------------------------------

  Map<String, dynamic> get latestHealth => healthSnapshot;

  int get latestHeartRate => healthSnapshot["heartRate"] ?? 0;
  int get latestSteps => healthSnapshot["steps"] ?? 0;
  double get latestSleepHours => (healthSnapshot["sleepHours"] ?? 0).toDouble();

  int get healthRiskScore {
    int score = 0;
    if (latestHeartRate < 50 || latestHeartRate > 110) score += 40;
    if (latestSteps < 2000) score += 25;
    if (latestSleepHours < 6) score += 20;
    return min(score, 100);
  }

  String get riskCategory {
    final s = healthRiskScore;
    if (s < 20) return "Low";
    if (s < 50) return "Moderate";
    if (s < 75) return "Elevated";
    return "High";
  }

  Future<void> refreshAll() async {
    await _loadUserProfile();
  }

  // Settings / language / theme -----------------------------------

  String languageCode = "en";
  double fontScale = 1.0;
  bool highContrast = false;
  bool largeTouchTargets = false;

  Future<void> loadSettings() async {
    if (uid == null) return;

    final langDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("settings")
        .doc("language")
        .get();

    if (langDoc.exists) languageCode = langDoc.data()?["code"] ?? "en";

    final accDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("settings")
        .doc("accessibility")
        .get();

    if (accDoc.exists) {
      fontScale = (accDoc.data()?["fontScale"] ?? 1.0).toDouble();
      highContrast = accDoc.data()?["highContrast"] ?? false;
      largeTouchTargets = accDoc.data()?["largeTouchTargets"] ?? false;
    }

    setState(() {});
  }

  Map<String, dynamic> get themeSettings => {
        "fontScale": fontScale,
        "highContrast": highContrast,
        "largeTouchTargets": largeTouchTargets,
      };

  String get currentLanguage => languageCode;

  String t(String key) {
    final translations = {
      "en": {"emergency": "Emergency", "health": "Health"},
      "es": {"emergency": "Emergencia", "health": "Salud"},
      "sv": {"emergency": "Nödsituation", "health": "Hälsa"},
      "fi": {"emergency": "Hätätila", "health": "Terveys"},
      "ar": {"emergency": "طارئ", "health": "الصحة"},
    };

    return translations[languageCode]?[key] ?? translations["en"]?[key] ?? key;
  }

  // Offline sync ---------------------------------------------------

  List<Map<String, dynamic>> offlineQueue = [];

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
    setState(() {});
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

    setState(() {});
  }

  bool get hasOfflineItems => offlineQueue.isNotEmpty;

  bool isOnline = true;

  void updateOnlineStatus(bool online) {
    isOnline = online;
    setState(() {});
  }

  Future<void> reloadUserEverything() async {
    await _loadUserProfile();
    await loadSettings();
    await refreshAll();
    setState(() {});
  }

  // Device integrations -------------------------------------------

  bool fitbitConnected = false;
  bool googleFitConnected = false;
  bool appleHealthConnected = false;

  Future<void> connectFitbit() async {
    fitbitConnected = true;
    setState(() {});
  }

  Future<void> connectGoogleFit() async {
    googleFitConnected = true;
    setState(() {});
  }

  Future<void> connectAppleHealth() async {
    appleHealthConnected = true;
    setState(() {});
  }

  Map<String, dynamic> get deviceIntegrationStatus => {
        "fitbit": fitbitConnected,
        "googleFit": googleFitConnected,
        "appleHealth": appleHealthConnected,
      };

  // Escalation engine ----------------------------------------------

  Timer? emergencyEscalationTimer;

  void startEmergencyEscalationLoop() {
    emergencyEscalationTimer?.cancel();

    emergencyEscalationTimer =
        Timer.periodic(const Duration(seconds: 15), (_) async {
      if (emergencyEvents.isEmpty) return;

      for (final e in emergencyEvents) {
        if (e["resolved"] == true) continue;

        final ts = (e["timestamp"] as Timestamp?)?.toDate();
        if (ts == null) continue;

        final elapsed = DateTime.now().difference(ts).inSeconds;

        if (elapsed > 120 && e["agencyStatus"] != "sent") {
          await _sendEscalationTo("agency", e["eventId"]);
        } else if (elapsed > 60 && e["familyStatus"] != "sent") {
          await _sendEscalationTo("family", e["eventId"]);
        } else if (elapsed > 30 && e["caregiverStatus"] != "sent") {
          await _sendEscalationTo("caregiver", e["eventId"]);
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

    setState(() {});
  }

  // AI engine -------------------------------------------------------

  String generateAIRiskExplanation() {
    final score = healthRiskScore;

    if (score < 20) {
      return "Your current health indicators appear stable.";
    } else if (score < 50) {
      return "Some metrics show mild irregularity.";
    } else if (score < 75) {
      return "Your readings suggest elevated risk.";
    } else {
      return "High risk detected. Consider seeking assistance.";
    }
  }

  String generateAIHealthSummary() {
    return """
Health Summary:
- Heart Rate: $latestHeartRate bpm
- Steps: $latestSteps steps
- Sleep: $latestSleepHours hours
- Risk Level: $riskCategory

Interpretation:
${generateAIRiskExplanation()}
""";
  }

  String generateAIChatAssist(String userMessage) {
    final msg = userMessage.toLowerCase();
    if (msg.contains("help")) {
      return "It sounds like you may need help. Should I alert a caregiver?";
    }
    if (msg.contains("pain")) {
      return "I'm detecting concern about pain. Do you want to notify your family?";
    }
    return "How can I support you?";
  }

  // Remote agency actions ------------------------------------------

  Future<void> agencyRequestCheckIn(String targetUserId) async {
    await FirebaseFirestore.instance.collection("notifications").add({
      "toUser": targetUserId,
      "type": "agency_checkin_request",
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  Future<void> triggerRemoteWipe() async {
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({"remoteWipeRequested": true});
  }

  // Final build renderer -------------------------------------------

  @override
  Widget build(BuildContext context) {
    _updateResponsiveEngine(context);

    if (loadingUser) {
      return const Center(
        child: SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(),
        ),
      );
    }

    return _GlobalExports(
      controller: this,
      child: widget.child ?? home,
    );
  }
}

// Inherited Widget for global access --------------------------------

class _GlobalExports extends InheritedWidget {
  final _GlobalAppControllerCWState controller;

  const _GlobalExports({
    required Widget child,
    required this.controller,
  }) : super(child: child);

  @override
  bool updateShouldNotify(_) => true;

  static _GlobalAppControllerCWState of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<_GlobalExports>();
    if (result == null) {
      throw Exception("GlobalAppControllerCW not found in widget tree.");
    }
    return result.controller;
  }
}
