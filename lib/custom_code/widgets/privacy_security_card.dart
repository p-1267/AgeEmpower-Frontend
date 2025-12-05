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
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

/// Privacy & Security settings card Includes: biometric toggle, app lock PIN
/// (set/change/remove), 2FA enable + method, analytics/diagnostics privacy
/// toggles, audit log viewer, logout-all sessions, remote wipe, data export,
/// delete account placeholders.
///
/// No Scaffold; width/height compatible.
class PrivacySecurityCard extends StatefulWidget {
  final double? width, height;
  const PrivacySecurityCard({Key? key, this.width, this.height})
      : super(key: key);
  @override
  State<PrivacySecurityCard> createState() => _PrivacySecurityCardState();
}

class _PrivacySecurityCardState extends State<PrivacySecurityCard> {
  // Pref keys
  static const _kBio = 'ps_biometric_enabled';
  static const _kPinReq = 'ps_require_pin';
  static const _kPinHash = 'ps_pin_hash_v1';
  static const _k2FA = 'ps_2fa_enabled';
  static const _k2FAMethod = 'ps_2fa_method'; // email | sms | app
  static const _kAnalytics = 'ps_analytics_opt_in';
  static const _kDiag = 'ps_share_diagnostics';
  static const _kAudit = 'ps_audit_log_json';
  static const _kSessEpoch = 'ps_sessions_epoch'; // bump to log out all

  bool _loading = true, _saving = false;
  bool _bio = false, _pinRequired = false, _twoFA = false;
  String _twoFAMethod = 'email';
  bool _analytics = false, _diagnostics = false;

  List<String> _audit = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    _bio = p.getBool(_kBio) ?? false;
    _pinRequired = p.getBool(_kPinReq) ?? false;
    _twoFA = p.getBool(_k2FA) ?? false;
    _twoFAMethod = p.getString(_k2FAMethod) ?? 'email';
    _analytics = p.getBool(_kAnalytics) ?? false;
    _diagnostics = p.getBool(_kDiag) ?? false;
    _audit = List<String>.from(jsonDecode(p.getString(_kAudit) ?? '[]'));
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kBio, _bio);
    await p.setBool(_kPinReq, _pinRequired);
    await p.setBool(_k2FA, _twoFA);
    await p.setString(_k2FAMethod, _twoFAMethod);
    await p.setBool(_kAnalytics, _analytics);
    await p.setBool(_kDiag, _diagnostics);
    await p.setString(_kAudit, jsonEncode(_audit));
    await _log('Saved privacy & security settings');
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Privacy & Security saved')));
  }

  Future<void> _log(String msg) async {
    final ts = DateTime.now().toIso8601String();
    _audit.insert(0, '[$ts] $msg');
    if (_audit.length > 50) _audit.removeRange(50, _audit.length);
    final p = await SharedPreferences.getInstance();
    await p.setString(_kAudit, jsonEncode(_audit));
  }

  // --- PIN helpers ---
  String _hashPin(String pin) {
    final bytes = utf8.encode('ageempower_salt::' + pin);
    return sha256.convert(bytes).toString();
  }

  Future<bool> _hasPin() async {
    final p = await SharedPreferences.getInstance();
    return (p.getString(_kPinHash) ?? '').isNotEmpty;
  }

  Future<void> _setOrChangePin() async {
    final hasPin = await _hasPin();
    final newVals = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final _old = TextEditingController();
        final _pin1 = TextEditingController();
        final _pin2 = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(hasPin ? 'Change PIN' : 'Set PIN',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (hasPin) ...[
              const SizedBox(height: 8),
              TextField(
                  controller: _old,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Current PIN')),
            ],
            const SizedBox(height: 8),
            TextField(
                controller: _pin1,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'New PIN (4–8 digits)')),
            const SizedBox(height: 8),
            TextField(
                controller: _pin2,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Confirm PIN')),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel')),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pop(ctx, [_old.text, _pin1.text, _pin2.text]),
                icon: const Icon(Icons.check),
                label: const Text('Save'),
              )
            ])
          ]),
        );
      },
    );

    if (newVals == null) return;
    final old = newVals[0];
    final p1 = newVals[1];
    final p2 = newVals[2];

    if (p1.length < 4 || p1.length > 8 || p1 != p2) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIN must match and be 4–8 digits')));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_kPinHash) ?? '';
    if (existing.isNotEmpty) {
      if (_hashPin(old) != existing) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Current PIN incorrect')));
        return;
      }
    }
    await prefs.setString(_kPinHash, _hashPin(p1));
    await _log(existing.isEmpty ? 'PIN set' : 'PIN changed');
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('PIN saved')));
  }

  Future<void> _removePin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kPinHash);
    await _log('PIN removed');
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('PIN removed')));
  }

  Future<void> _setup2FA() async {
    if (!_twoFA) return;
    final method = await showDialog<String>(
      context: context,
      builder: (_) =>
          SimpleDialog(title: const Text('Choose 2FA method'), children: [
        SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'email'),
            child: const Text('Email Code')),
        SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'sms'),
            child: const Text('SMS Code')),
        SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'app'),
            child: const Text('Authenticator App (TOTP)')),
      ]),
    );
    if (method == null) return;
    setState(() => _twoFAMethod = method);
    await _log('2FA enabled ($method)');
  }

  Future<void> _showAudit() async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Audit Log',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 260,
                  child: _audit.isEmpty
                      ? const Center(child: Text('No entries yet'))
                      : ListView.separated(
                          itemCount: _audit.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) => Text(_audit[i]),
                        ),
                ),
              ]),
        ),
      ),
    );
  }

  Future<void> _logoutAll() async {
    final prefs = await SharedPreferences.getInstance();
    final cur = prefs.getInt(_kSessEpoch) ?? 0;
    await prefs.setInt(_kSessEpoch, cur + 1);
    await _log('Logged out all devices');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All sessions will be signed out')));
  }

  Future<void> _remoteWipe() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remote Wipe'),
        content: const Text(
            'This will erase local preferences and cached data on this device.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Wipe')),
        ],
      ),
    );
    if (ok != true) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _log('Remote wipe executed on this device');
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Device data wiped')));
  }

  Future<void> _exportData() async {
    await _log('Requested data export');
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('Export Data'),
        content: Text(
            'A data export will be prepared (stub). Integrate backend export to generate a downloadable file.'),
      ),
    );
  }

  Future<void> _deleteAccount() async {
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Type DELETE to confirm. This action is irreversible.'),
          const SizedBox(height: 8),
          TextField(controller: controller),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(
                  context, controller.text.trim().toUpperCase() == 'DELETE'),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      await _log('Account deletion requested');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deletion requested (stub)')));
    }
  }

  // Helper to render a titled card section
  Widget _card(String title, Widget child) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = _loading
        ? const Center(child: CircularProgressIndicator())
        : Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _card(
                    'Biometric Unlock',
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SwitchListTile(
                            title: const Text('Enable Face/Touch ID'),
                            subtitle: Text(kIsWeb
                                ? 'Unavailable in Web Test. Works on iOS/Android builds.'
                                : 'Use device biometrics to unlock the app.'),
                            value: kIsWeb ? false : _bio,
                            onChanged: kIsWeb
                                ? null
                                : (v) async {
                                    setState(() => _bio = v);
                                    await _log(
                                        'Biometrics ${v ? 'enabled' : 'disabled'}');
                                  },
                          ),
                        ]),
                  ),
                  const SizedBox(height: 12),
                  _card(
                    'App Lock',
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SwitchListTile(
                            title: const Text('Require PIN on Launch'),
                            value: _pinRequired,
                            onChanged: (v) async {
                              setState(() => _pinRequired = v);
                              await _log('Require PIN ${v ? 'ON' : 'OFF'}');
                            },
                          ),
                          Row(children: [
                            ElevatedButton.icon(
                                onPressed: _setOrChangePin,
                                icon: const Icon(Icons.lock),
                                label: const Text('Set / Change PIN')),
                            const SizedBox(width: 8),
                            TextButton(
                                onPressed: _removePin,
                                child: const Text('Remove PIN')),
                          ]),
                        ]),
                  ),
                  const SizedBox(height: 12),
                  _card(
                    'Two-Factor Authentication',
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SwitchListTile(
                            title: const Text('Enable 2FA'),
                            value: _twoFA,
                            onChanged: (v) async {
                              setState(() => _twoFA = v);
                              await _log('2FA ${v ? 'enabled' : 'disabled'}');
                              if (v) await _setup2FA();
                            },
                          ),
                          if (_twoFA)
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child:
                                  Text('Method: ${_twoFAMethod.toUpperCase()}'),
                            ),
                        ]),
                  ),
                  const SizedBox(height: 12),
                  _card(
                    'Privacy Preferences',
                    Column(children: [
                      SwitchListTile(
                          title: const Text('Analytics Opt‑in'),
                          value: _analytics,
                          onChanged: (v) async {
                            setState(() => _analytics = v);
                            await _log('Analytics ${v ? 'opt‑in' : 'opt‑out'}');
                          }),
                      SwitchListTile(
                          title: const Text('Share Diagnostics (crash logs)'),
                          value: _diagnostics,
                          onChanged: (v) async {
                            setState(() => _diagnostics = v);
                            await _log(
                                'Diagnostics ${v ? 'enabled' : 'disabled'}');
                          }),
                    ]),
                  ),
                  const SizedBox(height: 12),
                  _card(
                    'Security Tools',
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(spacing: 8, runSpacing: 8, children: [
                            OutlinedButton.icon(
                                onPressed: _showAudit,
                                icon: const Icon(Icons.rule_folder_outlined),
                                label: const Text('View Audit Log')),
                            OutlinedButton.icon(
                                onPressed: _logoutAll,
                                icon: const Icon(Icons.logout),
                                label: const Text('Log out all devices')),
                            OutlinedButton.icon(
                                onPressed: _remoteWipe,
                                icon: const Icon(Icons.delete_forever),
                                label: const Text('Remote wipe this device')),
                            OutlinedButton.icon(
                                onPressed: _exportData,
                                icon: const Icon(Icons.download),
                                label: const Text('Export my data')),
                            TextButton.icon(
                                onPressed: _deleteAccount,
                                icon: const Icon(Icons.person_remove),
                                label: const Text('Delete account')),
                          ]),
                          const SizedBox(height: 8),
                          const Text(
                              'Data Encryption: transport uses TLS; at‑rest encryption is enforced on the backend.'),
                        ]),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.save),
                      label: Text(_saving ? 'Saving…' : 'Save Settings'),
                    ),
                  ),
                ],
              ),
            ),
          );

    return SizedBox(width: widget.width, height: widget.height, child: content);
  }
}
