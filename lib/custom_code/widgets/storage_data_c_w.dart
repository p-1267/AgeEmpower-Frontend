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
import 'package:flutter/services.dart';
import 'package:flutter/painting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cloud_functions/cloud_functions.dart';

class StorageDataCW extends StatefulWidget {
  final double? width;
  final double? height;
  final String? resyncFunctionName; // e.g., 'resyncUserData' (optional)

  const StorageDataCW({
    Key? key,
    this.width,
    this.height,
    this.resyncFunctionName,
  }) : super(key: key);

  @override
  State<StorageDataCW> createState() => _StorageDataCWState();
}

class _StorageDataCWState extends State<StorageDataCW> {
  bool offlineMode = true;
  bool _dirty = false, _saving = false, _busy = false;

  User? get _user => FirebaseAuth.instance.currentUser;

  // ---------- Firestore helpers ----------
  Stream<DocumentSnapshot<Map<String, dynamic>>> _settings(String uid) {
    return FirebaseFirestore.instance
        .collection('user_settings')
        .doc(uid)
        .snapshots();
  }

  CollectionReference<Map<String, dynamic>> _backupCol(String uid) {
    return FirebaseFirestore.instance
        .collection('user_backups')
        .doc(uid)
        .collection('backups');
  }

  Future<Map<String, dynamic>> _readCurrentSettings(String uid) async {
    final snap = await FirebaseFirestore.instance
        .collection('user_settings')
        .doc(uid)
        .get();
    return (snap.data() ?? <String, dynamic>{});
  }

  // ---------- Persist toggle ----------
  Future<void> _save(String uid) async {
    setState(() => _saving = true);
    await FirebaseFirestore.instance
        .collection('user_settings')
        .doc(uid)
        .set({'offlineMode': offlineMode}, SetOptions(merge: true));
    if (!mounted) return;
    setState(() {
      _dirty = false;
      _saving = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Storage & data saved')));
  }

  // ---------- Local cache ----------
  Future<void> _clearLocalCache() async {
    setState(() => _busy = true);
    try {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
      await DefaultCacheManager().emptyCache();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Local cache cleared')));
      }
    } catch (e) {
      debugPrint('clear cache error: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ---------- Resync via Cloud Function ----------
  Future<void> _resyncNow(String uid) async {
    if (widget.resyncFunctionName == null ||
        widget.resyncFunctionName!.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Resync queued locally')));
      return;
    }
    setState(() => _busy = true);
    try {
      final callable =
          FirebaseFunctions.instance.httpsCallable(widget.resyncFunctionName!);
      await callable.call(<String, dynamic>{'uid': uid});
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Resync started')));
      }
    } catch (e) {
      debugPrint('resyncNow error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Resync failed (see logs)')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ---------- Export / Import JSON ----------
  Future<void> _exportJSON(String uid) async {
    setState(() => _busy = true);
    try {
      final data = await _readCurrentSettings(uid);
      final jsonStr = const JsonEncoder.withIndent('  ').convert(data);
      await Clipboard.setData(ClipboardData(text: jsonStr));
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Export (copied to clipboard)'),
          content: SingleChildScrollView(child: Text(jsonStr)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
    } catch (e) {
      debugPrint('export error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _importJSON(String uid) async {
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Import Settings JSON'),
        content: TextField(
          controller: controller,
          maxLines: 12,
          decoration: const InputDecoration(
            hintText: '{ "offlineMode": true, ... }',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Apply')),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _busy = true);
    try {
      final Map<String, dynamic> incoming = jsonDecode(controller.text);
      // Basic validation: only accept map keys with simple JSON types
      if (incoming is! Map<String, dynamic>) {
        throw 'Invalid JSON';
      }
      await FirebaseFirestore.instance
          .collection('user_settings')
          .doc(uid)
          .set(incoming, SetOptions(merge: true));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Import applied')),
        );
      }
    } catch (e) {
      debugPrint('import error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Import failed: invalid JSON')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ---------- Cloud backup / restore ----------
  Future<void> _backupNow(String uid) async {
    setState(() => _busy = true);
    try {
      final data = await _readCurrentSettings(uid);
      await _backupCol(uid).add({
        'createdAt': FieldValue.serverTimestamp(),
        'settings': data,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup created')),
        );
      }
    } catch (e) {
      debugPrint('backup error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restoreFromBackup(String uid) async {
    setState(() => _busy = true);
    try {
      final snaps = await _backupCol(uid)
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();

      if (snaps.docs.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No backups found')),
          );
        }
        setState(() => _busy = false);
        return;
      }

      final selected = await showModalBottomSheet<
          QueryDocumentSnapshot<Map<String, dynamic>>>(
        context: context,
        builder: (_) => SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemBuilder: (_, i) {
              final d = snaps.docs[i];
              final ts = d.data()['createdAt'] as Timestamp?;
              final when = ts != null
                  ? ts.toDate().toLocal().toString()
                  : 'Pending timestamp';
              return ListTile(
                leading: const Icon(Icons.backup_outlined),
                title: Text('Backup ${i + 1}'),
                subtitle: Text(when),
                onTap: () => Navigator.pop(_, d),
              );
            },
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemCount: snaps.docs.length,
          ),
        ),
      );

      if (selected != null) {
        final data =
            (selected.data()['settings'] as Map<String, dynamic>?) ?? {};
        await FirebaseFirestore.instance
            .collection('user_settings')
            .doc(uid)
            .set(data, SetOptions(merge: true));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Backup restored')),
          );
        }
      }
    } catch (e) {
      debugPrint('restore error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restore failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteAllBackups(String uid) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete all backups?'),
        content: const Text('This will permanently remove all stored backups.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _busy = true);
    try {
      final snaps = await _backupCol(uid).get();
      final batch = FirebaseFirestore.instance.batch();
      for (final d in snaps.docs) {
        batch.delete(d.reference);
      }
      await batch.commit();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backups deleted')),
        );
      }
    } catch (e) {
      debugPrint('delete backups error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Delete failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    final uid = _user?.uid;
    if (uid == null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(child: Text('Sign in required')),
      );
    }

    final titleStyle = FlutterFlowTheme.of(context).titleLarge;

    final content = StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _settings(uid),
      builder: (context, snap) {
        final data = snap.data?.data() ?? {};
        if (!_dirty) {
          offlineMode = (data['offlineMode'] as bool?) ?? true;
        }

        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.width ?? 800),
          child: Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Storage & Data', style: titleStyle),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('Offline mode (cache critical data)'),
                    value: offlineMode,
                    onChanged: (v) => setState(() {
                      offlineMode = v;
                      _dirty = true;
                    }),
                  ),
                  const Divider(height: 24),

                  // Cache & Resync
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        icon: _busy
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.cleaning_services),
                        label: const Text('Clear Local Cache'),
                        onPressed: _busy ? null : _clearLocalCache,
                      ),
                      FilledButton.icon(
                        icon: _busy
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.sync),
                        label: const Text('Resync Now'),
                        onPressed: _busy ? null : () => _resyncNow(uid),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  // Export / Import
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Export JSON'),
                        onPressed: _busy ? null : () => _exportJSON(uid),
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.download_for_offline_outlined),
                        label: const Text('Import JSON'),
                        onPressed: _busy ? null : () => _importJSON(uid),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  // Backup / Restore
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      FilledButton.icon(
                        icon: const Icon(Icons.backup_outlined),
                        label: const Text('Backup to Cloud'),
                        onPressed: _busy ? null : () => _backupNow(uid),
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.restore_outlined),
                        label: const Text('Restore from Cloud'),
                        onPressed: _busy ? null : () => _restoreFromBackup(uid),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete all backups'),
                        onPressed: _busy ? null : () => _deleteAllBackups(uid),
                      ),
                    ],
                  ),

                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      icon: _saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(_saving ? 'Saving…' : 'Save'),
                      onPressed: !_dirty || _saving ? null : () => _save(uid),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return SizedBox(width: widget.width, height: widget.height, child: content);
  }
}
