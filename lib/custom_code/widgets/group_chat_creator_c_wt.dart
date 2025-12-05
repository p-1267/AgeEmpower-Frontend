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
/// GROUP CHAT CREATOR
/// ---------------------------------------------------------------------------
/// Allows:
///   - Selecting members
///   - Setting group name
///   - Optional avatar
///   - Creates Firestore conversation:
///
///     /conversations/{conversationId}
///        members: [list]
///        isGroup: true
///        groupName: ""
///        groupAvatar: ""
///        lastMessage: ""
///        lastTimestamp: serverTimestamp()
///
/// ---------------------------------------------------------------------------

class GroupChatCreatorCW extends StatefulWidget {
  final double? width;
  final double? height;

  /// Provide a list of selectable members
  /// Each item: {"uid": "...", "name": "...", "avatar": "..."}
  final List<Map<String, dynamic>> availableMembers;

  /// Callback when group is created
  final Function(String conversationId)? onGroupCreated;

  const GroupChatCreatorCW({
    super.key,
    this.width,
    this.height,
    required this.availableMembers,
    this.onGroupCreated,
  });

  @override
  State<GroupChatCreatorCW> createState() => _GroupChatCreatorCWState();
}

class _GroupChatCreatorCWState extends State<GroupChatCreatorCW> {
  final TextEditingController _nameCtrl = TextEditingController();
  String? _selectedAvatar;

  final List<String> _selectedMembers = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _preselectCurrentUser();
  }

  void _preselectCurrentUser() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) _selectedMembers.add(uid);
  }

  // ---------------------------------------------------------------------------
  // Create conversation in Firestore
  // ---------------------------------------------------------------------------
  Future<void> _createGroup() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a group name")),
      );
      return;
    }

    if (_selectedMembers.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select at least 1 other member")),
      );
      return;
    }

    setState(() => _loading = true);

    final convoRef =
        FirebaseFirestore.instance.collection("conversations").doc();

    await convoRef.set({
      "conversationId": convoRef.id,
      "members": _selectedMembers,
      "isGroup": true,
      "groupName": _nameCtrl.text.trim(),
      "groupAvatar": _selectedAvatar ?? "",
      "lastMessage": "",
      "lastTimestamp": FieldValue.serverTimestamp(),
    });

    setState(() => _loading = false);

    widget.onGroupCreated?.call(convoRef.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Group created!")),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // UI Layout
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create Group Chat",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 20),
            _buildGroupNameField(),
            const SizedBox(height: 20),
            _buildAvatarSelector(),
            const SizedBox(height: 20),
            _buildMemberSelector(),
            const SizedBox(height: 30),
            _buildCreateButton(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Group Name
  // ---------------------------------------------------------------------------
  Widget _buildGroupNameField() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: _nameCtrl,
        decoration: InputDecoration(
          labelText: "Group Name",
          border: InputBorder.none,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Avatar selector
  // ---------------------------------------------------------------------------
  Widget _buildAvatarSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Group Avatar",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            GestureDetector(
              onTap: () => setState(() => _selectedAvatar = null),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.group, color: Colors.blue),
              ),
            ),
            const SizedBox(width: 14),

            // Could be extended with real image picker
            if (_selectedAvatar != null)
              Text("Avatar Selected",
                  style: TextStyle(color: Colors.blue.shade700)),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Member list selector
  // ---------------------------------------------------------------------------
  Widget _buildMemberSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Members",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...widget.availableMembers.map((m) {
          final id = m["uid"];
          final name = m["name"] ?? "User";
          final avatar = m["avatar"] ?? "";

          final bool selected = _selectedMembers.contains(id);

          return GestureDetector(
            onTap: () {
              setState(() {
                if (selected) {
                  _selectedMembers.remove(id);
                } else {
                  _selectedMembers.add(id);
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: selected ? Colors.blue.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? Colors.blue.shade400 : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(Icons.person, color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Icon(
                    selected ? Icons.check_circle : Icons.circle_outlined,
                    color: selected ? Colors.blue : Colors.grey,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Create Button
  // ---------------------------------------------------------------------------
  Widget _buildCreateButton() {
    return ElevatedButton(
      onPressed: _loading ? null : _createGroup,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Colors.blue.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: _loading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              "Create Group",
              style: TextStyle(fontSize: 18),
            ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
