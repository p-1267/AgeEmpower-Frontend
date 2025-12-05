// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// ===== Extra packages for this action =====
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens a maps site in a new tab on web, with fallbacks if Google is blocked.
Future<void> _openMapsWithFallback({
  required double? lat,
  required double? lng,
}) async {
  Uri google = (lat != null && lng != null)
      ? Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng')
      : Uri.parse('https://www.google.com/maps/');
  Uri bing = (lat != null && lng != null)
      ? Uri.parse('https://www.bing.com/maps?cp=${lat}~${lng}&lvl=16')
      : Uri.parse('https://www.bing.com/maps');
  Uri osm = (lat != null && lng != null)
      ? Uri.parse(
          'https://www.openstreetmap.org/?mlat=$lat&mlon=$lng#map=16/$lat/$lng')
      : Uri.parse('https://www.openstreetmap.org/');

  Future<bool> _try(Uri url) async {
    try {
      return await launchUrl(url, webOnlyWindowName: '_blank');
    } catch (_) {
      return false;
    }
  }

  if (await _try(google)) return;
  if (await _try(bing)) return;
  await _try(osm);
}

/// Returns the composed share text so you can view it in a Snackbar on web.
///
/// On Android/iOS it also opens the native share sheet.
Future<String?> shareCurrentLocation() async {
  try {
    // 1) Services/permissions (mobile only)
    if (!kIsWeb) {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return 'Location services are off. Please enable them and try again.';
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return 'Location permission denied.';
        }
      }
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return 'Location permission permanently denied. Enable it in Settings.';
      }
    }

    // 2) GPS (mobile; on web we try too—browser may ask permission)
    Position? pos;
    try {
      pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (_) {
      pos = null; // OK, we can still share/open a maps site
    }

    // 3) Reverse-geocode (best-effort)
    String address = '';
    if (pos != null) {
      try {
        final placemarks =
            await placemarkFromCoordinates(pos.latitude, pos.longitude);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = <String>[
            if ((p.street ?? '').trim().isNotEmpty) p.street!,
            if ((p.subLocality ?? '').trim().isNotEmpty) p.subLocality!,
            if ((p.locality ?? '').trim().isNotEmpty) p.locality!,
            if ((p.administrativeArea ?? '').trim().isNotEmpty)
              p.administrativeArea!,
            if ((p.postalCode ?? '').trim().isNotEmpty) p.postalCode!,
            if ((p.country ?? '').trim().isNotEmpty) p.country!,
          ];
          address = parts.join(', ');
        }
      } catch (_) {/* ignore */}
    }

    // 4) Compose the message
    final g = (pos != null)
        ? 'https://www.google.com/maps/search/?api=1&query=${pos.latitude},${pos.longitude}'
        : 'https://www.google.com/maps/';
    final b = (pos != null)
        ? 'https://www.bing.com/maps?cp=${pos.latitude}~${pos.longitude}&lvl=16'
        : 'https://www.bing.com/maps';
    final o = (pos != null)
        ? 'https://www.openstreetmap.org/?mlat=${pos.latitude}&mlon=${pos.longitude}#map=16/${pos.latitude}/${pos.longitude}'
        : 'https://www.openstreetmap.org/';

    final text = (pos != null && address.isNotEmpty)
        ? 'I need help. Here is my location:\n$address\n\nGoogle Maps: $g\nBing Maps: $b\nOpenStreetMap: $o'
        : (pos != null)
            ? 'I need help. My location:\nGoogle Maps: $g\nBing Maps: $b\nOpenStreetMap: $o'
            : 'I need help. Open one of these and share my live location:\nGoogle Maps: $g\nBing Maps: $b\nOpenStreetMap: $o';

    // 5) Web vs. mobile behavior
    if (kIsWeb) {
      await _openMapsWithFallback(lat: pos?.latitude, lng: pos?.longitude);
      return text; // <- so you can show it in a Snackbar/Dialog
    }

    // Native share sheet on Android/iOS
    await Share.share(text, subject: 'My current location');
    return text;
  } catch (e) {
    debugPrint('shareCurrentLocation error: $e');
    return 'Error: $e';
  }
}
