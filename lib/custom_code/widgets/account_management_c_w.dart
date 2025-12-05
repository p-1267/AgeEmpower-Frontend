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

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountManagementCW extends StatefulWidget {
  const AccountManagementCW({Key? key, this.width, this.height})
      : super(key: key);
  final double? width;
  final double? height;

  @override
  State<AccountManagementCW> createState() => _AccountManagementCWState();
}

class _AccountManagementCWState extends State<AccountManagementCW> {
  // Pref keys
  static const _kPlan = 'am_plan'; // Free | Family | Organization
  static const _kCaregivers = 'am_linked_caregivers_json'; // List<String>
  static const _kContacts = 'am_emergency_contacts_json'; // List<Map>

  bool _loading = true;
  bool _working = false;

  // Data
  String _plan = 'Free';
  List<String> _linkedCaregivers = [];
  List<Map<String, dynamic>> _contacts = [];

  User? get _user => FirebaseAuth.instance.currentUser;
  bool get _loggedIn => _user != null;

  @override
  void initState() {
    super.initState();
    _loadLocal();
  }

  Future<void> _loadLocal() async {
    final p = await SharedPreferences.getInstance();
    _plan = p.getString(_kPlan) ?? 'Free';
    _linkedCaregivers =
        List<String>.from(jsonDecode(p.getString(_kCaregivers) ?? '[]'));
    _contacts = List<Map<String, dynamic>>.from(
        jsonDecode(p.getString(_kContacts) ?? '[]'));
    setState(() => _loading = false);
  }

  Future<void> _persist() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kPlan, _plan);
    await p.setString(_kCaregivers, jsonEncode(_linkedCaregivers));
    await p.setString(_kContacts, jsonEncode(_contacts));
  }

  // --- Auth actions ---
  Future<void> _handleSignOut() async {
    setState(() => _working = true);
    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Signed out')));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sign out failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _handleDeleteAccount() async {
    if (!_loggedIn) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete account'),
        content: const Text(
            'This will permanently delete your account and data. This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _working = true);
    try {
      await _user!.delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Account deleted')));
    } on FirebaseAuthException catch (e) {
      final needsReauth = e.code == 'requires-recent-login';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(needsReauth
              ? 'Please reauthenticate before deleting your account.'
              : 'Delete failed: ${e.message}'),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Delete failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  // --- Profile ---
  Future<void> _editProfile() async {
    if (!_loggedIn) return;
    final nameCtrl = TextEditingController(text: _user!.displayName ?? '');
    final res = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Display name')),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel')),
                const SizedBox(width: 8),
                ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Save')),
              ]),
            ]),
      ),
    );
    if (res == true) {
      await _user!.updateDisplayName(nameCtrl.text.trim());
      if (mounted) setState(() {});
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Profile updated')));
    }
  }

  // --- Caregiver links ---
  Future<void> _addCaregiver() async {
    final nameCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Link Caregiver'),
        content: TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Caregiver name')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Link')),
        ],
      ),
    );
    if (ok == true) {
      setState(() => _linkedCaregivers.add(nameCtrl.text.trim()));
      await _persist();
    }
  }

  void _removeCaregiver(int i) async {
    setState(() => _linkedCaregivers.removeAt(i));
    await _persist();
  }

  // --- Subscription ---
  Future<void> _changePlan() async {
    final plan = await showDialog<String>(
      context: context,
      builder: (_) =>
          SimpleDialog(title: const Text('Choose plan'), children: const [
        SimpleDialogOption(child: Text('Free'), key: ValueKey('Free')),
        SimpleDialogOption(child: Text('Family'), key: ValueKey('Family')),
        SimpleDialogOption(
            child: Text('Organization'), key: ValueKey('Organization')),
      ]),
    );
    // Flutter’s SimpleDialogOption lacks built-in return; emulate via keys
    // We'll capture tap using GestureDetector wrapper instead
    // (Workaround below)
    // Instead implement a custom dialog:
  }

  Future<void> _selectPlan() async {
    String? selected = _plan;
    final res = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Plan'),
        content: StatefulBuilder(builder: (context, setS) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            RadioListTile<String>(
                title: const Text('Free'),
                value: 'Free',
                groupValue: selected,
                onChanged: (v) => setS(() => selected = v)),
            RadioListTile<String>(
                title: const Text('Family'),
                value: 'Family',
                groupValue: selected,
                onChanged: (v) => setS(() => selected = v)),
            RadioListTile<String>(
                title: const Text('Organization'),
                value: 'Organization',
                groupValue: selected,
                onChanged: (v) => setS(() => selected = v)),
          ]);
        }),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, selected),
              child: const Text('Apply')),
        ],
      ),
    );
    if (res != null) {
      setState(() => _plan = res);
      await _persist();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Plan set to $_plan')));
    }
  }

  // --- Emergency Contacts ---
  Future<void> _addOrEditContact({int? index}) async {
    final isEdit = index != null;
    final name =
        TextEditingController(text: isEdit ? _contacts[index!]['name'] : '');
    final relation = TextEditingController(
        text: isEdit ? _contacts[index!]['relation'] : '');
    final phone =
        TextEditingController(text: isEdit ? _contacts[index!]['phone'] : '');

    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isEdit ? 'Edit Contact' : 'Add Contact',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Full name')),
              const SizedBox(height: 8),
              TextField(
                  controller: relation,
                  decoration: const InputDecoration(labelText: 'Relationship')),
              const SizedBox(height: 8),
              TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone')),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel')),
                const SizedBox(width: 8),
                ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Save')),
              ])
            ]),
      ),
    );
    if (ok == true) {
      final item = {
        'name': name.text.trim(),
        'relation': relation.text.trim(),
        'phone': phone.text.trim()
      };
      setState(() {
        if (isEdit) {
          _contacts[index!] = item;
        } else {
          _contacts.add(item);
        }
      });
      await _persist();
    }
  }

  Future<void> _removeContact(int i) async {
    setState(() => _contacts.removeAt(i));
    await _persist();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return SizedBox(
          width: widget.width,
          height: widget.height,
          child: const Center(child: CircularProgressIndicator()));
    }

    if (!_loggedIn) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(mainAxisSize: MainAxisSize.min, children: const [
                Icon(Icons.lock_outline, size: 48, color: Colors.grey),
                SizedBox(height: 12),
                Text('Please sign in to manage your account'),
              ]),
            ),
          ),
        ),
      );
    }

    final displayName = _user!.displayName ?? 'User';
    final email = _user!.email ?? '—';

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionCard(
            'Profile',
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CircleAvatar(
                    radius: 28,
                    child: Text(
                        displayName.isNotEmpty
                            ? displayName.substring(0, 1).toUpperCase()
                            : '?',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold))),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(displayName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(email,
                          style: TextStyle(color: Colors.grey.shade700)),
                    ])),
                TextButton.icon(
                    onPressed: _editProfile,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit')),
              ]),
            ]),
          ),
          const SizedBox(height: 12),
          _sectionCard(
            'Linked Caregivers',
            Column(children: [
              if (_linkedCaregivers.isEmpty)
                const ListTile(title: Text('No caregivers linked.')),
              ..._linkedCaregivers.asMap().entries.map((e) => ListTile(
                    leading: const Icon(Icons.people_outline),
                    title: Text(e.value),
                    trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _removeCaregiver(e.key)),
                  )),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                    onPressed: _addCaregiver,
                    icon: const Icon(Icons.person_add_alt_1),
                    label: const Text('Link caregiver')),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          _sectionCard(
            'Subscription',
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.workspace_premium_outlined),
                const SizedBox(width: 8),
                Text('Current plan: $_plan',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                OutlinedButton(
                    onPressed: _selectPlan, child: const Text('Change plan')),
              ]),
              const SizedBox(height: 8),
              const Text('Manage billing via Stripe integration (stubbed).'),
            ]),
          ),
          const SizedBox(height: 12),
          _sectionCard(
            'Emergency Contacts',
            Column(children: [
              if (_contacts.isEmpty)
                const ListTile(title: Text('No emergency contacts.')),
              ..._contacts.asMap().entries.map((e) => ListTile(
                    leading: const Icon(Icons.contact_phone_outlined),
                    title: Text(e.value['name'] ?? ''),
                    subtitle: Text(
                        '${e.value['relation'] ?? ''} • ${e.value['phone'] ?? ''}'),
                    trailing: Wrap(spacing: 8, children: [
                      IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _addOrEditContact(index: e.key)),
                      IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _removeContact(e.key)),
                    ]),
                  )),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                    onPressed: () => _addOrEditContact(),
                    icon: const Icon(Icons.add_ic_call),
                    label: const Text('Add contact')),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          _sectionCard(
            'Security',
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              ElevatedButton.icon(
                  onPressed: _working ? null : _handleSignOut,
                  icon: _working
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.logout),
                  label: const Text('Sign out')),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                  onPressed: _working ? null : _handleDeleteAccount,
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Delete account'),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red))),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(String title, Widget child) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          child,
        ]),
      ),
    );
  }
}
