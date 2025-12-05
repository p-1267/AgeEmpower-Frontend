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

// AUTOMATIC FLUTTERFLOW IMPORTS — DO NOT REMOVE
import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

// CUSTOM IMPORTS
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicationsCW extends StatefulWidget {
  final double? width;
  final double? height;

  const MedicationsCW({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<MedicationsCW> createState() => _MedicationsCWState();
}

class _MedicationsCWState extends State<MedicationsCW> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _filter = 'all'; // all | active | paused | low
  bool _busy = false;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Stream<QuerySnapshot> _medsStream() {
    final uid = _uid;
    if (uid == null) {
      // empty stream
      return const Stream<QuerySnapshot>.empty();
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('medications')
        .orderBy('name')
        .snapshots();
  }

  bool _matchesSearch(Map<String, dynamic> d) {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return true;
    return (d['name'] ?? '').toString().toLowerCase().contains(q) ||
        (d['dosage'] ?? '').toString().toLowerCase().contains(q) ||
        (d['strength'] ?? '').toString().toLowerCase().contains(q);
  }

  bool _matchesFilter(Map<String, dynamic> d) {
    final active = (d['active'] ?? true) as bool;
    final remaining = (d['remaining'] ?? 0) as num;
    final lowThreshold = (d['lowThreshold'] ?? 5) as num;

    switch (_filter) {
      case 'active':
        return active;
      case 'paused':
        return !active;
      case 'low':
        return remaining <= lowThreshold;
      default:
        return true;
    }
  }

  Future<void> _toggleActive(DocumentReference ref, bool currentActive) async {
    setState(() => _busy = true);
    try {
      await ref.update({
        'active': !currentActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteMed(DocumentReference ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Medication'),
        content: const Text('Are you sure you want to delete this medication?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    setState(() => _busy = true);
    try {
      await ref.delete();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openForm({String? medId}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(medId == null ? 'Add Medication' : 'Edit Medication'),
          ),
          body: MedicationFormCW(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            medId: medId,
          ),
        ),
      ),
    );
  }

  Future<void> _openInteractions() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.7,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: DrugInteractionCheckerCW(
                  width: MediaQuery.of(ctx).size.width,
                  height: MediaQuery.of(ctx).size.height,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_uid == null) {
      return const Center(child: Text('Please sign in to view medications.'));
    }

    final w = widget.width ?? MediaQuery.of(context).size.width;

    return SizedBox(
      width: w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),

          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search medications...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                if (_busy)
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Filters
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _filterChip('All', 'all'),
                _filterChip('Active', 'active'),
                _filterChip('Paused', 'paused'),
                _filterChip('Low refill', 'low'),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Check Interactions button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.health_and_safety),
              label: const Text('Check Interactions'),
              onPressed: _openInteractions,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 46),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // AI Safety Summary panel
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MedicationSafetySummaryCW(
              width: w - 32,
              height: 220,
            ),
          ),

          const SizedBox(height: 12),

          // Main list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _medsStream(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2));
                }

                if (!snap.hasData) {
                  return const Center(child: Text('No medications.'));
                }

                final docs = snap.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>? ?? {};
                  return _matchesFilter(data) && _matchesSearch(data);
                }).toList();

                if (docs.isEmpty) {
                  return const Center(
                      child: Text('No medications match your filters.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final d = docs[i];
                    final data = d.data() as Map<String, dynamic>? ?? {};
                    return _medCard(d.reference, data);
                  },
                );
              },
            ),
          ),

          // Add button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: ElevatedButton.icon(
              onPressed: () => _openForm(),
              icon: const Icon(Icons.add),
              label: const Text('Add Medication'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String key) {
    final selected = _filter == key;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: Colors.blue.withOpacity(.2),
        onSelected: (_) => setState(() => _filter = key),
      ),
    );
  }

  Widget _medCard(DocumentReference ref, Map<String, dynamic> d) {
    final name = (d['name'] ?? '').toString();
    final dosage = (d['dosage'] ?? '').toString();
    final remaining = (d['remaining'] ?? 0) as num;
    final lowThreshold = (d['lowThreshold'] ?? 5) as num;
    final active = (d['active'] ?? true) as bool;
    final isLow = remaining <= lowThreshold;

    final iconColor = active ? Colors.green : Colors.grey;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Icon(
              Icons.medication_rounded,
              size: 32,
              color: iconColor,
            ),
            if (isLow)
              const Icon(
                Icons.warning_amber_rounded,
                size: 16,
                color: Colors.orange,
              ),
          ],
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          remaining > 0 ? '$dosage • $remaining left' : '$dosage • none left',
        ),
        onTap: () => _openForm(medId: ref.id),
        trailing: PopupMenuButton<String>(
          onSelected: (v) {
            if (v == 'toggle') {
              _toggleActive(ref, active);
            } else if (v == 'delete') {
              _deleteMed(ref);
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'toggle',
              child: ListTile(
                leading: Icon(
                  active ? Icons.pause_circle : Icons.play_circle,
                ),
                title: Text(active ? 'Pause' : 'Resume'),
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
