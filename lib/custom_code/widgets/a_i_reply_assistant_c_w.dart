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
import 'package:firebase_auth/firebase_auth.dart';

/// ---------------------------------------------------------------------------
/// AI REPLY ASSISTANT WIDGET
/// ---------------------------------------------------------------------------
/// This widget:
///   - Watches last N messages from Firestore
///   - Calls your AI function to generate reply suggestions
///   - Shows 1–3 beautiful suggestion chips
///   - Sends chosen suggestion back to parent widget
///
/// Integrates with:
///   ChatThreadCW (Widget 2)
///   Conversation Structure (Option C Hybrid)
/// ---------------------------------------------------------------------------

class AIReplyAssistantCW extends StatefulWidget {
  final String conversationId;

  /// Called when the user taps a suggestion
  final Function(String replyText)? onReplySelected;

  /// Optional custom AI provider (if you prefer internal logic)
  final Future<List<String>> Function(List<Map<String, dynamic>> messages)?
      aiSuggestionProvider;

  final double? width;
  final double? height;

  const AIReplyAssistantCW({
    super.key,
    required this.conversationId,
    this.onReplySelected,
    this.aiSuggestionProvider,
    this.width,
    this.height,
  });

  @override
  State<AIReplyAssistantCW> createState() => _AIReplyAssistantCWState();
}

class _AIReplyAssistantCWState extends State<AIReplyAssistantCW> {
  bool loading = false;
  List<String> suggestions = [];
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _listenToMessages();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Listen for last messages
  // ---------------------------------------------------------------------------
  void _listenToMessages() {
    final ref = FirebaseFirestore.instance
        .collection("conversations")
        .doc(widget.conversationId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(10);

    _sub = ref.snapshots().listen((snap) async {
      final msgs = snap.docs.map((d) {
        final m = d.data() as Map<String, dynamic>;
        return {
          "text": m["text"] ?? "",
          "senderId": m["senderId"] ?? "",
          "timestamp": m["timestamp"],
        };
      }).toList();

      _generateSuggestions(msgs);
    });
  }

  // ---------------------------------------------------------------------------
  // Call AI provider
  // ---------------------------------------------------------------------------
  Future<void> _generateSuggestions(
      List<Map<String, dynamic>> recentMessages) async {
    if (widget.aiSuggestionProvider == null) {
      // fallback simple suggestions
      setState(() {
        suggestions = ["Okay", "Thanks!", "Let me check."];
      });
      return;
    }

    setState(() => loading = true);

    try {
      final result = await widget.aiSuggestionProvider!(recentMessages);
      setState(() => suggestions = result.take(3).toList());
    } catch (_) {
      setState(() => suggestions = ["Yes", "No", "Understood."]);
    }

    setState(() => loading = false);
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: const [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text("Thinking…"),
          ],
        ),
      );
    }

    if (suggestions.isEmpty) return const SizedBox();

    return Container(
      width: widget.width ?? double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Wrap(
        spacing: 10,
        children: suggestions
            .map(
              (text) => GestureDetector(
                onTap: () => widget.onReplySelected?.call(text),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade700,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
