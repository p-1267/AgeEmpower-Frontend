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

// Additional imports
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

/// ---------------------------------------------------------------------------
/// PROVIDER DIRECTORY (Hybrid: Search + Filters + List)
/// ---------------------------------------------------------------------------
/// Firestore structure:
///   /providers/{providerId}
///      name
///      specialty
///      avatarUrl
///      location
///      insurance
///      rating
///
/// This widget handles:
///   - Search bar
///   - Specialty filter
///   - Insurance filter
///   - Provider list
///   - Beautiful AgeEmpower design
/// ---------------------------------------------------------------------------

class ProviderDirectoryCW extends StatefulWidget {
  final double? width;
  final double? height;

  /// Callback when user selects a provider card
  final Function(String providerId, Map<String, dynamic> providerData)?
      onProviderSelected;

  const ProviderDirectoryCW({
    super.key,
    this.width,
    this.height,
    this.onProviderSelected,
  });

  @override
  State<ProviderDirectoryCW> createState() => _ProviderDirectoryCWState();
}

class _ProviderDirectoryCWState extends State<ProviderDirectoryCW> {
  TextEditingController searchCtrl = TextEditingController();
  String selectedSpecialty = "All";
  String selectedInsurance = "All";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 14),
          _buildFilters(),
          const SizedBox(height: 14),
          Expanded(child: _buildProviderStream()),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Search Bar
  // ---------------------------------------------------------------------------
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: searchCtrl,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Search providers…",
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Filters Row
  // ---------------------------------------------------------------------------
  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
            child: _dropdown("Specialty", selectedSpecialty, [
          "All",
          "Cardiology",
          "Neurology",
          "Primary Care",
          "Geriatrics"
        ], (v) {
          setState(() => selectedSpecialty = v);
        })),
        const SizedBox(width: 10),
        Expanded(
            child: _dropdown("Insurance", selectedInsurance,
                ["All", "Medicare", "BlueCross", "Kaiser", "Aetna"], (v) {
          setState(() => selectedInsurance = v);
        })),
      ],
    );
  }

  Widget _dropdown(String label, String currentValue, List<String> items,
      Function(String) onSelect) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        value: currentValue,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down),
        isExpanded: true,
        items: items.map((i) {
          return DropdownMenuItem(
            value: i,
            child: Text(i),
          );
        }).toList(),
        onChanged: (v) => onSelect(v!),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Firestore provider query
  // ---------------------------------------------------------------------------
  Stream<QuerySnapshot> _providerStream() {
    return FirebaseFirestore.instance
        .collection("providers")
        .orderBy("name")
        .snapshots();
  }

  // ---------------------------------------------------------------------------
  // Provider List
  // ---------------------------------------------------------------------------
  Widget _buildProviderStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: _providerStream(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snap.data!.docs;

        final results = docs.where((d) {
          final data = d.data() as Map<String, dynamic>;
          final name = (data["name"] ?? "").toString().toLowerCase();
          final specialty = (data["specialty"] ?? "").toString();
          final insurance = (data["insurance"] ?? "").toString();

          final query = searchCtrl.text.trim().toLowerCase();

          final matchesQuery = query.isEmpty || name.contains(query);

          final matchesSpecialty =
              selectedSpecialty == "All" || specialty == selectedSpecialty;

          final matchesInsurance =
              selectedInsurance == "All" || insurance == selectedInsurance;

          return matchesQuery && matchesSpecialty && matchesInsurance;
        }).toList();

        if (results.isEmpty) {
          return const Center(
            child: Text(
              "No providers found",
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (c, i) {
            final doc = results[i];
            final data = doc.data() as Map<String, dynamic>;
            final providerId = doc.id;

            return _buildProviderCard(providerId, data);
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Provider Card
  // ---------------------------------------------------------------------------
  Widget _buildProviderCard(String providerId, Map<String, dynamic> data) {
    final name = data["name"] ?? "Provider";
    final specialty = data["specialty"] ?? "General";
    final avatar = data["avatarUrl"] ?? "";
    final rating = data["rating"] ?? 4.5;

    return GestureDetector(
      onTap: () => widget.onProviderSelected?.call(providerId, data),
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.blue.shade200),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blue.shade100,
              backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
              child: avatar.isEmpty
                  ? Icon(Icons.person, color: Colors.blue.shade700, size: 28)
                  : null,
            ),
            const SizedBox(width: 14),

            // Info block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    specialty,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange.shade600, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, size: 28),
          ],
        ),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
