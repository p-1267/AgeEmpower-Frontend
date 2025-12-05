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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// ---------------------------------------------------------------------------
///  CHAT LIST WIDGET
/// ---------------------------------------------------------------------------
///  Firestore Structure (Option C Hybrid):
///  /conversations/{conversationId}
///        members: [uid1, uid2, uid3]
///        isGroup: true/false
///        groupName: ""
///        groupAvatar: ""
///        lastMessage: ""
///        lastTimestamp: ts
///
///  Subcollection:
///  /conversations/{conversationId}/messages/{msgId}
///
///  This widget:
///   - Shows all conversations for current user
///   - Supports group + individual chats
///   - Beautiful Material UI matching your 72 custom widgets
///   - Unread indicators
///   - Timestamps
/// ---------------------------------------------------------------------------

class ChatListCW extends StatefulWidget {
  final double? width;
  final double? height;

  /// Callback when user taps a conversation
  final Function(String conversationId)? onConversationSelected;

  const ChatListCW({
    super.key,
    this.width,
    this.height,
    this.onConversationSelected,
  });

  @override
  State<ChatListCW> createState() => _ChatListCWState();
}

class _ChatListCWState extends State<ChatListCW> {
  String? uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      return const Center(child: Text("Not signed in"));
    }

    final stream = FirebaseFirestore.instance
        .collection("conversations")
        .where("members", arrayContains: uid)
        .orderBy("lastTimestamp", descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snap.data!.docs;

        if (docs.isEmpty) {
          return const Center(
            child: Text(
              "No conversations yet",
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: docs.length,
          itemBuilder: (c, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            final convoId = docs[i].id;

            return _buildConversationTile(convoId, data);
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Conversation Tile UI
  // ---------------------------------------------------------------------------
  Widget _buildConversationTile(
      String conversationId, Map<String, dynamic> data) {
    final bool isGroup = data["isGroup"] == true;
    final String name =
        isGroup ? (data["groupName"] ?? "Group Chat") : _partnerName(data);
    final String avatar = data["groupAvatar"] ?? "";
    final String lastMsg = data["lastMessage"] ?? "";

    final Timestamp? ts = data["lastTimestamp"];
    final DateTime? dt = ts?.toDate();
    final String timeLabel = dt != null ? _formatTime(dt) : "";

    final bool unread = _isUnread(conversationId, data);

    return GestureDetector(
      onTap: () => widget.onConversationSelected?.call(conversationId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: unread ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: unread ? Colors.blue.shade300 : Colors.grey.shade300,
          ),
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
            _buildAvatar(isGroup, avatar),
            const SizedBox(width: 14),

            // Text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    lastMsg.isEmpty ? "No messages yet" : lastMsg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(timeLabel,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.black54)),
                if (unread)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.shade700,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Avatar builder
  // ---------------------------------------------------------------------------
  Widget _buildAvatar(bool isGroup, String avatarUrl) {
    if (isGroup) {
      return CircleAvatar(
        radius: 28,
        backgroundColor: Colors.blue.shade300,
        child: const Icon(Icons.group, color: Colors.white, size: 28),
      );
    }

    return CircleAvatar(
      radius: 28,
      backgroundColor: Colors.blue.shade100,
      child: const Icon(Icons.person, color: Colors.blue, size: 28),
    );
  }

  // ---------------------------------------------------------------------------
  // Determine partner name (for 1-to-1 conversation)
  // ---------------------------------------------------------------------------
  String _partnerName(Map<String, dynamic> convoData) {
    final members = (convoData["members"] ?? []) as List<dynamic>;
    final partnerId = members.firstWhere((m) => m != uid, orElse: () => "");

    // For now, placeholder. You can replace with Firestore lookup.
    return partnerId.isEmpty ? "Chat" : "User ${partnerId.substring(0, 4)}";
  }

  // ---------------------------------------------------------------------------
  // Format timestamps
  // ---------------------------------------------------------------------------
  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inDays == 0) {
      return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } else if (diff.inDays == 1) {
      return "Yesterday";
    } else if (diff.inDays < 7) {
      return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][dt.weekday - 1];
    }

    return "${dt.month}/${dt.day}/${dt.year}";
  }

  // ---------------------------------------------------------------------------
  // Determine unread state
  // ---------------------------------------------------------------------------
  bool _isUnread(String conversationId, Map<String, dynamic> data) {
    // Placeholder logic (FF can replace with unread tracking collection)
    return (data["lastSenderId"] ?? "") != uid;
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
