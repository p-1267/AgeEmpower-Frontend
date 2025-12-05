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
/// CHAT SEARCH WIDGET
/// ---------------------------------------------------------------------------
/// Supports:
///   - Global search across all conversations
///   - Search inside a single conversation
///   - Highlighting matching text
///   - Beautiful Material design consistent with AgeEmpower
///
/// Firestore (Option C Hybrid):
///   /conversations/{conversationId}/messages/{msgId}
/// ---------------------------------------------------------------------------

class ChatSearchCW extends StatefulWidget {
  final String? conversationId;
  final double? width;
  final double? height;

  /// If provided, search only inside this conversation
  /// If null → global chat search
  const ChatSearchCW({
    super.key,
    this.conversationId,
    this.width,
    this.height,
  });

  @override
  State<ChatSearchCW> createState() => _ChatSearchCWState();
}

class _ChatSearchCWState extends State<ChatSearchCW> {
  TextEditingController searchCtrl = TextEditingController();
  bool loading = false;
  List<_SearchResult> results = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 16),
          _buildResults(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Search Bar
  // ---------------------------------------------------------------------------
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchCtrl,
            decoration: InputDecoration(
              hintText: "Search messages…",
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _runSearch,
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue.shade700,
            child: const Icon(Icons.search, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Run search
  // ---------------------------------------------------------------------------
  Future<void> _runSearch() async {
    final query = searchCtrl.text.trim();
    if (query.isEmpty) return;

    setState(() {
      loading = true;
      results.clear();
    });

    if (widget.conversationId != null) {
      await _searchInsideConversation(widget.conversationId!, query);
    } else {
      await _searchGlobally(query);
    }

    setState(() => loading = false);
  }

  // ---------------------------------------------------------------------------
  // Search inside one conversation
  // ---------------------------------------------------------------------------
  Future<void> _searchInsideConversation(
      String conversationId, String query) async {
    final snap = await FirebaseFirestore.instance
        .collection("conversations")
        .doc(conversationId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .get();

    for (var doc in snap.docs) {
      final msg = doc.data();
      final text = msg["text"] ?? "";
      if (text.toLowerCase().contains(query.toLowerCase())) {
        results.add(_SearchResult(
          conversationId: conversationId,
          messageId: doc.id,
          text: text,
          timestamp: msg["timestamp"],
        ));
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Search across ALL conversations (global)
  // ---------------------------------------------------------------------------
  Future<void> _searchGlobally(String query) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Step 1: load conversations where user is a member
    final convoSnap = await FirebaseFirestore.instance
        .collection("conversations")
        .where("members", arrayContains: uid)
        .get();

    for (var convo in convoSnap.docs) {
      final convoId = convo.id;

      final msgSnap = await convo.reference
          .collection("messages")
          .orderBy("timestamp", descending: false)
          .get();

      for (var msgDoc in msgSnap.docs) {
        final msg = msgDoc.data();
        final text = msg["text"] ?? "";

        if (text.toLowerCase().contains(query.toLowerCase())) {
          results.add(_SearchResult(
            conversationId: convoId,
            messageId: msgDoc.id,
            text: text,
            timestamp: msg["timestamp"],
          ));
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Results UI
  // ---------------------------------------------------------------------------
  Widget _buildResults() {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (results.isEmpty) {
      return const Text(
        "No results",
        style: TextStyle(fontSize: 16, color: Colors.black54),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return _buildResultCard(results[index]);
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Result card (beautiful design)
  // ---------------------------------------------------------------------------
  Widget _buildResultCard(_SearchResult r) {
    final query = searchCtrl.text.trim();
    final highlighted = _highlight(r.text, query);

    final ts = r.timestamp as Timestamp?;
    final time = ts != null
        ? "${ts.toDate().month}/${ts.toDate().day} ${ts.toDate().hour}:${ts.toDate().minute.toString().padLeft(2, '0')}"
        : "";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade200),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          highlighted,
          const SizedBox(height: 6),
          Text(
            time,
            style: const TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Highlight matched text
  // ---------------------------------------------------------------------------
  Widget _highlight(String text, String query) {
    final lower = text.toLowerCase();
    final q = query.toLowerCase();

    if (!lower.contains(q)) {
      return Text(text, style: const TextStyle(fontSize: 16));
    }

    final start = lower.indexOf(q);
    final end = start + q.length;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, start),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          TextSpan(
            text: text.substring(start, end),
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: text.substring(end),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// INTERNAL MODEL
/// ---------------------------------------------------------------------------
class _SearchResult {
  final String conversationId;
  final String messageId;
  final String text;
  final dynamic timestamp;

  _SearchResult({
    required this.conversationId,
    required this.messageId,
    required this.text,
    required this.timestamp,
  });
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
