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

import '/custom_code/widgets/app_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageRegionCW extends StatefulWidget {
  const LanguageRegionCW({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  State<LanguageRegionCW> createState() => _LanguageRegionCWState();
}

class _LanguageRegionCWState extends State<LanguageRegionCW> {
  static const _kLang = 'lr_language';
  static const _kMetric = 'lr_metric';
  static const _kTz = 'lr_timezone';

  String _languageCode = 'en';
  bool _useMetric = true;
  String? _timeZone;
  bool _loading = true;
  bool _saving = false;

  final Map<String, String> _langs = const {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    _languageCode = p.getString(_kLang) ?? 'en';
    _useMetric = p.getBool(_kMetric) ?? true;
    _timeZone = p.getString(_kTz);
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    // Persist locally
    final p = await SharedPreferences.getInstance();
    await p.setString(_kLang, _languageCode);
    await p.setBool(_kMetric, _useMetric);
    if (_timeZone == null || _timeZone!.trim().isEmpty) {
      await p.remove(_kTz);
    } else {
      await p.setString(_kTz, _timeZone!.trim());
    }

    // Call helper (your hook to i18n/unit logic)
    await applyLocalizationAndUnits(
      context,
      languageCode: _languageCode,
      useMetric: _useMetric,
      timeZone: _timeZone?.trim().isEmpty == true ? null : _timeZone,
    );

    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Language & region saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final card = _loading
        ? const Center(child: CircularProgressIndicator())
        : Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Language & Region',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _languageCode,
                    items: _langs.entries
                        .map((e) => DropdownMenuItem(
                            value: e.key, child: Text(e.value)))
                        .toList(),
                    onChanged: (v) => setState(() => _languageCode = v ?? 'en'),
                    decoration: const InputDecoration(
                      labelText: 'Language',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Use metric units'),
                    value: _useMetric,
                    onChanged: (v) => setState(() => _useMetric = v),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _timeZone,
                    decoration: const InputDecoration(
                      labelText: 'Time zone (optional, e.g. Europe/Berlin)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => _timeZone = v,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.save),
                      label: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          );

    return SizedBox(width: widget.width, height: widget.height, child: card);
  }
}
