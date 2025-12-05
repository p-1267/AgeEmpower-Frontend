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
// DO NOT REMOVE ABOVE

class SubscriptionPlansCW extends StatelessWidget {
  final double? width;
  final double? height;
  final void Function(String planId)? onSelect;

  const SubscriptionPlansCW({
    super.key,
    this.width,
    this.height,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final plans = [
      {
        "id": "free",
        "price": "0",
        "label": "Free Plan",
        "features": [
          "Basic activity tracking",
          "Chat support",
        ]
      },
      {
        "id": "premium",
        "price": "9.99",
        "label": "Premium",
        "features": [
          "Emergency monitoring",
          "AI reports",
          "Caregiver dashboard",
          "Voice assistant",
        ]
      },
      {
        "id": "pro",
        "price": "19.99",
        "label": "Pro",
        "features": [
          "24/7 priority alerts",
          "Advanced analytics",
          "Agency-level dashboard",
        ]
      }
    ];

    return Container(
      width: width ?? double.infinity,
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: plans.map((p) => _card(context, p)).toList(),
      ),
    );
  }

  Widget _card(BuildContext ctx, Map<String, dynamic> plan) {
    return GestureDetector(
      onTap: () => onSelect?.call(plan["id"]),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.blue.shade200),
          boxShadow: const [
            BoxShadow(
                color: Color(0x22000000), blurRadius: 10, offset: Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(plan["label"],
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text("\$${plan['price']}/month",
                style: TextStyle(fontSize: 18, color: Colors.blue.shade700)),
            const SizedBox(height: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (plan["features"] as List)
                  .map((f) => Row(
                        children: [
                          const Icon(Icons.check, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(child: Text(f)),
                        ],
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => onSelect?.call(plan["id"]),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text(
                "Choose Plan",
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
