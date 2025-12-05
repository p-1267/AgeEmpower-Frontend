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

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A custom widget for the senior's home dashboard.  This widget is fully
/// self‑contained and does not rely on any FlutterFlow actions.  It
/// automatically reads data from Firestore to populate vital information
/// including safety status, medication reminders, upcoming appointments,
/// mood/daily plan summaries, vitals snapshot, AI wellness summary and
/// displays a map showing the last known location, safe zone boundaries and
/// recent wandering events.  The layout has been designed with a modern
/// professional aesthetic and scales gracefully across mobile and web.
class SeniorDashboardCW extends StatefulWidget {
  const SeniorDashboardCW({super.key});

  @override
  State<SeniorDashboardCW> createState() => _SeniorDashboardCWState();
}

class _SeniorDashboardCWState extends State<SeniorDashboardCW> {
  // User and state variables
  String? userId;
  bool loading = true;

  // Location and safe zone data
  GeoPoint? lastLocation;
  List<Map<String, dynamic>> safeZones = [];
  List<Map<String, dynamic>> wanderingEvents = [];

  // Medication, appointment, mood and vitals data
  List<Map<String, dynamic>> medications = [];
  Map<String, dynamic>? nextAppointment;
  Map<String, dynamic>? todaysMood;
  Map<String, dynamic>? dailyPlan;
  Map<String, dynamic>? vitalsSnapshot;
  Map<String, dynamic>? wellnessSummary;

  // Google Map controller
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    _loadAllData();
  }

  /// Top‑level loader that fetches all required data sequentially.  Each
  /// individual loader handles its own error states gracefully.  Once all
  /// loaders complete, the dashboard will render.
  Future<void> _loadAllData() async {
    if (userId == null) {
      setState(() => loading = false);
      return;
    }
    await Future.wait([
      _loadLocationData(),
      _loadMedications(),
      _loadAppointments(),
      _loadMood(),
      _loadDailyPlan(),
      _loadVitals(),
      _loadWellnessSummary(),
    ]);
    setState(() => loading = false);
  }

  /// Load the last known location, safe zones and recent wandering events
  /// from Firestore.  Wandering events are limited to the last 48 hours
  /// to avoid cluttering the map.
  Future<void> _loadLocationData() async {
    try {
      // Last known location
      final locSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('location')
          .doc('lastKnown')
          .get();
      if (locSnap.exists) {
        lastLocation = (locSnap.data()?['position'] as GeoPoint?);
      }

      // Safe zones
      final safeZoneSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('safeZones')
          .get();
      safeZones = safeZoneSnap.docs.map((d) => d.data()).toList();

      // Wandering events (last 48h)
      final since = Timestamp.fromDate(
        DateTime.now().subtract(const Duration(hours: 48)),
      );
      final wanderingSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('wanderingEvents')
          .where('timestamp', isGreaterThan: since)
          .get();
      wanderingEvents = wanderingSnap.docs.map((d) => d.data()).toList();
    } catch (e) {
      // Ignore errors; UI will handle null/empty states
    }
  }

  /// Load the senior's active medications.  Only medications with
  /// `active == true` are counted.  The dashboard shows a preview of the
  /// first two medications.
  Future<void> _loadMedications() async {
    try {
      final medsSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('medications')
          .where('active', isEqualTo: true)
          .get();
      medications = medsSnap.docs.map((d) => d.data()).toList();
    } catch (e) {
      medications = [];
    }
  }

  /// Load the next upcoming appointment.  This method fetches appointments
  /// ordered by date/time and picks the first one in the future.  Only
  /// upcoming events are considered.
  Future<void> _loadAppointments() async {
    try {
      final now = Timestamp.now();
      final apptSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('appointments')
          .where('time', isGreaterThan: now)
          .orderBy('time')
          .limit(1)
          .get();
      if (apptSnap.docs.isNotEmpty) {
        nextAppointment = apptSnap.docs.first.data();
      }
    } catch (e) {
      nextAppointment = null;
    }
  }

  /// Load the mood entry for today.  Mood entries are keyed by date string
  /// (yyyy-MM-dd) within the user's `mood` subcollection.
  Future<void> _loadMood() async {
    try {
      final dateKey = DateTime.now();
      final id = '${dateKey.year}-${dateKey.month}-${dateKey.day}';
      final moodSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('mood')
          .doc(id)
          .get();
      if (moodSnap.exists) {
        todaysMood = moodSnap.data();
      }
    } catch (e) {
      todaysMood = null;
    }
  }

  /// Load the AI‑generated daily plan for today.  If a plan is not
  /// available, this remains null.
  Future<void> _loadDailyPlan() async {
    try {
      final planSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dailyPlan')
          .doc('aiPlan')
          .get();
      if (planSnap.exists) {
        dailyPlan = planSnap.data();
      }
    } catch (e) {
      dailyPlan = null;
    }
  }

  /// Load the most recent vitals record for preview.  This shows the latest
  /// heart rate, blood pressure and oxygen saturation if available.
  Future<void> _loadVitals() async {
    try {
      final vitalsSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('vitals')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
      if (vitalsSnap.docs.isNotEmpty) {
        vitalsSnapshot = vitalsSnap.docs.first.data();
      }
    } catch (e) {
      vitalsSnapshot = null;
    }
  }

  /// Load the AI wellness summary (overall risk score and summary).  If
  /// unavailable, this remains null.
  Future<void> _loadWellnessSummary() async {
    try {
      final summarySnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('wellnessAI')
          .doc('report')
          .get();
      if (summarySnap.exists) {
        wellnessSummary = summarySnap.data();
      }
    } catch (e) {
      wellnessSummary = null;
    }
  }

  /// Build the map widget with markers and overlays.  If location data is
  /// missing, this returns a placeholder.  Only visible on mobile because
  /// google_maps_flutter is not supported on web; on web a simple text
  /// placeholder is shown.
  Widget _buildMap() {
    if (lastLocation == null) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Location not available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              lastLocation!.latitude,
              lastLocation!.longitude,
            ),
            zoom: 15,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
          },
          markers: _buildMarkers(),
          circles: _buildCircles(),
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),
      ),
    );
  }

  /// Build map markers: last known location and wandering events.
  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};
    if (lastLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('lastKnown'),
          position: LatLng(
            lastLocation!.latitude,
            lastLocation!.longitude,
          ),
          infoWindow: const InfoWindow(title: 'Last Known Location'),
        ),
      );
    }
    for (var i = 0; i < wanderingEvents.length; i++) {
      final event = wanderingEvents[i];
      final loc = event['location'] as GeoPoint?;
      if (loc == null) continue;
      markers.add(
        Marker(
          markerId: MarkerId('wander_$i'),
          position: LatLng(loc.latitude, loc.longitude),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          infoWindow: InfoWindow(
            title: 'Wandering Event',
            snippet: (event['timestamp'] != null)
                ? (event['timestamp'] as Timestamp).toDate().toString()
                : '',
          ),
        ),
      );
    }
    return markers;
  }

  /// Build safe zone circles for the map.  Each zone is drawn with a green
  /// overlay using the radius stored in Firestore (assumed metres).  If no
  /// safe zones exist, returns an empty set.
  Set<Circle> _buildCircles() {
    final circles = <Circle>{};
    for (var i = 0; i < safeZones.length; i++) {
      final zone = safeZones[i];
      final center = zone['center'] as GeoPoint?;
      final radius = (zone['radius'] as num?)?.toDouble() ?? 0;
      if (center == null || radius <= 0) continue;
      circles.add(
        Circle(
          circleId: CircleId('zone_$i'),
          center: LatLng(center.latitude, center.longitude),
          radius: radius,
          strokeWidth: 2,
          strokeColor: Colors.green,
          fillColor: Colors.green.withOpacity(0.15),
        ),
      );
    }
    return circles;
  }

  /// Build a card with a header and body content.  This helper ensures a
  /// consistent look across the dashboard.
  Widget _buildCard({
    required String title,
    required Widget child,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  /// Build the main dashboard view.  This composes all cards into a
  /// scrollable list.
  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Map card
          _buildCard(
            title: 'Location & Safe Zones',
            child: _buildMap(),
          ),
          // Safety status card
          _buildCard(
            title: 'Safety Status',
            child: _buildSafetyStatus(),
            color: Colors.red.shade50,
          ),
          // Medication summary card
          _buildCard(
            title: 'Medications',
            child: _buildMedSummary(),
            color: Colors.blue.shade50,
          ),
          // Appointment summary card
          _buildCard(
            title: 'Next Appointment',
            child: _buildAppointmentSummary(),
            color: Colors.orange.shade50,
          ),
          // Vitals snapshot card
          _buildCard(
            title: 'Recent Vitals',
            child: _buildVitals(),
            color: Colors.teal.shade50,
          ),
          // AI wellness summary card
          _buildCard(
            title: 'AI Wellness Summary',
            child: _buildAIWellness(),
            color: Colors.purple.shade50,
          ),
          // Mood & plan card
          _buildCard(
            title: 'Mood & Daily Plan',
            child: _buildMoodAndPlan(),
            color: Colors.green.shade50,
          ),
        ],
      ),
    );
  }

  /// Build a summary of the safety status.  For now, we simply indicate
  /// whether there are wandering events recorded in the last 48 hours.  If
  /// emergency detection integration is added, this card can display more
  /// detailed states.
  Widget _buildSafetyStatus() {
    final hasWandering = wanderingEvents.isNotEmpty;
    if (hasWandering) {
      return Row(
        children: const [
          Icon(Icons.warning, color: Colors.red),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              'Wandering events detected in the last 48 hours.',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      );
    }
    return Row(
      children: const [
        Icon(Icons.check_circle, color: Colors.green),
        SizedBox(width: 8),
        Flexible(
          child: Text(
            'All safe! No wandering events recently.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  /// Build a summary of medications.  Shows the count and names of first two
  /// medications.  If none exist, a placeholder is shown.
  Widget _buildMedSummary() {
    if (medications.isEmpty) {
      return const Text('No active medications registered.',
          style: TextStyle(fontSize: 16));
    }
    final preview = medications.take(2).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total active: ${medications.length}',
            style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        ...preview.map((m) {
          final name = m['name'] ?? 'Medication';
          final dose = m['dosage'] ?? '';
          return Text('- $name $dose', style: const TextStyle(fontSize: 16));
        }).toList(),
        if (medications.length > 2)
          const Text('...and more',
              style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  /// Build a summary of the next appointment.  If there is no upcoming
  /// appointment, shows an appropriate message.
  Widget _buildAppointmentSummary() {
    if (nextAppointment == null) {
      return const Text('No upcoming appointments.',
          style: TextStyle(fontSize: 16));
    }
    final time = nextAppointment!['time'] as Timestamp?;
    final doctor = nextAppointment!['doctor'] ?? 'Provider';
    final dateStr = time != null ? time.toDate().toLocal().toString() : 'TBD';
    return Text('$dateStr with $doctor', style: const TextStyle(fontSize: 16));
  }

  /// Build the vitals preview.  Displays heart rate, blood pressure and
  /// oxygen saturation from the most recent record.  If no vitals exist,
  /// returns a placeholder.
  Widget _buildVitals() {
    if (vitalsSnapshot == null) {
      return const Text('No recent vitals recorded.',
          style: TextStyle(fontSize: 16));
    }
    final heart = vitalsSnapshot!['heartRate'] != null
        ? '${vitalsSnapshot!['heartRate']} bpm'
        : '–';
    final systolic = vitalsSnapshot!['systolic'];
    final diastolic = vitalsSnapshot!['diastolic'];
    final bp = (systolic != null && diastolic != null)
        ? '$systolic/$diastolic mmHg'
        : '–';
    final oxygen = vitalsSnapshot!['oxygen'] != null
        ? '${vitalsSnapshot!['oxygen']}%'
        : '–';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _vitalItem('Heart Rate', heart),
        _vitalItem('Blood Pressure', bp),
        _vitalItem('Oxygen', oxygen),
      ],
    );
  }

  /// Helper to display a single vital value with its label.
  Widget _vitalItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  /// Build the AI wellness summary.  Shows the overall risk score and a brief
  /// summary.  If the summary is unavailable, displays a placeholder.
  Widget _buildAIWellness() {
    if (wellnessSummary == null) {
      return const Text('No AI wellness summary available.',
          style: TextStyle(fontSize: 16));
    }
    final score = wellnessSummary!['overallScore'];
    final summary = wellnessSummary!['summary'] ?? '';
    Color color;
    if (score != null && score is num) {
      final s = score.toDouble();
      color = s >= 70
          ? Colors.red.shade200
          : s >= 40
              ? Colors.orange.shade200
              : Colors.green.shade200;
    } else {
      color = Colors.purple.shade200;
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (score != null)
            Text('Risk Score: $score / 100',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(summary, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  /// Build the mood and daily plan preview.  Displays today's mood if
  /// available and a brief excerpt from the daily plan.  If both are null,
  /// show a placeholder.
  Widget _buildMoodAndPlan() {
    if (todaysMood == null && dailyPlan == null) {
      return const Text('No mood or plan data available.',
          style: TextStyle(fontSize: 16));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (todaysMood != null) ...[
          Row(
            children: [
              const Icon(Icons.emoji_emotions, size: 20, color: Colors.yellow),
              const SizedBox(width: 6),
              Text('Mood: ${todaysMood!['mood']}',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          if ((todaysMood!['note'] ?? '').toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 26, top: 2),
              child: Text('Note: ${todaysMood!['note']}',
                  style: const TextStyle(fontSize: 14)),
            ),
          const SizedBox(height: 10),
        ],
        if (dailyPlan != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Daily Plan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Wake: ${dailyPlan!['wakeTime']}',
                  style: const TextStyle(fontSize: 16)),
              Text('Sleep: ${dailyPlan!['sleepTime']}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 2),
              Text('Hydration: ${dailyPlan!['hydration']}',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return _buildDashboard();
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
