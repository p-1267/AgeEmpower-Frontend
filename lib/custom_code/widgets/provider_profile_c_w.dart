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

import 'package:cloud_firestore/cloud_firestore.dart';

/// ---------------------------------------------------------------------------
/// PROVIDER PROFILE WIDGET
/// ---------------------------------------------------------------------------
/// Shows:
///   - Provider photo/avatar
///   - Name + specialty
///   - Rating
///   - Bio / About
///   - Location
///   - Accepted insurance
///   - Experience, certifications
///   - “Book Appointment” button
///
/// Firestore Structure:
///   /providers/{providerId}
///      name, specialty, avatarUrl, bio, insurance, location, rating, etc.
///
/// This widget is used by ProviderDirectoryCW and AppointmentListCW.
/// ---------------------------------------------------------------------------

class ProviderProfileCW extends StatefulWidget {
  final String providerId;

  final double? width;
  final double? height;

  /// Callback for “Book Appointment”
  final Function(String providerId)? onBookPressed;

  const ProviderProfileCW({
    super.key,
    required this.providerId,
    this.width,
    this.height,
    this.onBookPressed,
  });

  @override
  State<ProviderProfileCW> createState() => _ProviderProfileCWState();
}

class _ProviderProfileCWState extends State<ProviderProfileCW> {
  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance
        .collection("providers")
        .doc(widget.providerId);

    return FutureBuilder<DocumentSnapshot>(
      future: docRef.get(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snap.data!.exists) {
          return const Center(child: Text("Provider not found"));
        }

        final data = snap.data!.data() as Map<String, dynamic>;

        final name = data["name"] ?? "Provider";
        final specialty = data["specialty"] ?? "General";
        final avatarUrl = data["avatarUrl"] ?? "";
        final bio = data["bio"] ?? "No biography available.";
        final rating = data["rating"] ?? 4.5;
        final insurance = (data["insurance"] ?? "").toString();
        final location = (data["location"] ?? "").toString();
        final experience = (data["experience"] ?? "").toString();
        final certifications = (data["certifications"] ?? "").toString();

        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(18),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(name, specialty, avatarUrl, rating),
                const SizedBox(height: 20),
                _sectionTitle("Biography"),
                _sectionCard(Text(bio, style: _bodyStyle())),
                const SizedBox(height: 20),
                if (experience.isNotEmpty) ...[
                  _sectionTitle("Experience"),
                  _sectionCard(Text(experience, style: _bodyStyle())),
                  const SizedBox(height: 20),
                ],
                if (certifications.isNotEmpty) ...[
                  _sectionTitle("Certifications"),
                  _sectionCard(Text(certifications, style: _bodyStyle())),
                  const SizedBox(height: 20),
                ],
                if (insurance.isNotEmpty) ...[
                  _sectionTitle("Insurance Accepted"),
                  _sectionCard(Text(insurance, style: _bodyStyle())),
                  const SizedBox(height: 20),
                ],
                if (location.isNotEmpty) ...[
                  _sectionTitle("Location"),
                  _sectionCard(
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: Colors.red.shade600, size: 22),
                        const SizedBox(width: 8),
                        Expanded(child: Text(location, style: _bodyStyle())),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                _buildBookButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Header block with avatar + name + specialty + rating
  // ---------------------------------------------------------------------------
  Widget _buildHeader(
      String name, String specialty, String avatarUrl, double rating) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blue.shade100,
          backgroundImage:
              avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
          child: avatarUrl.isEmpty
              ? Icon(Icons.person, size: 40, color: Colors.blue.shade700)
              : null,
        ),
        const SizedBox(width: 18),

        // Info block
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 6),
              Text(
                specialty,
                style: TextStyle(fontSize: 18, color: Colors.blue.shade700),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.orange.shade600, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    rating.toString(),
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Section Builder
  // ---------------------------------------------------------------------------
  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ));
  }

  Widget _sectionCard(Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: child,
    );
  }

  // ---------------------------------------------------------------------------
  // Book Appointment Button
  // ---------------------------------------------------------------------------
  Widget _buildBookButton() {
    return ElevatedButton(
      onPressed: () => widget.onBookPressed?.call(widget.providerId),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        backgroundColor: Colors.blue.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: const Text(
        "Book Appointment",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Reusable text style
  // ---------------------------------------------------------------------------
  TextStyle _bodyStyle() {
    return const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4);
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
