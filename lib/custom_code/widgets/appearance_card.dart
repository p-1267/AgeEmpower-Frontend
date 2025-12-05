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

import 'package:shared_preferences/shared_preferences.dart';

class AppearanceCard extends StatefulWidget {
  final double? width, height;
  const AppearanceCard({Key? key, this.width, this.height}) : super(key: key);
  @override
  State<AppearanceCard> createState() => _AppearanceCardState();
}

class _AppearanceCardState extends State<AppearanceCard> {
  static const _kMode = 'app_theme_mode'; // 'system' | 'light' | 'dark'
  static const _kLarge = 'app_large_text'; // bool
  static const _kContrast = 'app_high_contrast'; // bool

  bool _loading = true, _saving = false;
  String _mode = 'system';
  bool _largeText = false;
  bool _highContrast = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      _mode = p.getString(_kMode) ?? 'system';
      _largeText = p.getBool(_kLarge) ?? false;
      _highContrast = p.getBool(_kContrast) ?? false;
      _loading = false;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final p = await SharedPreferences.getInstance();
    await p.setString(_kMode, _mode);
    await p.setBool(_kLarge, _largeText);
    await p.setBool(_kContrast, _highContrast);
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appearance settings saved')),
    );
  }

  ThemeData _previewTheme() {
    // Base by mode
    ThemeData base;
    if (_mode == 'dark') {
      base = ThemeData.dark();
    } else if (_mode == 'light') {
      base = ThemeData.light();
    } else {
      base = Theme.of(context); // system / app theme
    }
    // High contrast variant that works with older SDKs
    if (_highContrast) {
      final cs = (_mode == 'dark')
          ? const ColorScheme.highContrastDark()
          : const ColorScheme.highContrastLight();
      return ThemeData.from(colorScheme: cs);
    }
    return base;
  }

  @override
  Widget build(BuildContext context) {
    final child = _loading
        ? const Center(child: CircularProgressIndicator())
        : _body(context);
    return SizedBox(width: widget.width, height: widget.height, child: child);
  }

  Widget _body(BuildContext context) {
    final theme = _previewTheme();
    final scale = _largeText ? 1.2 : 1.0;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _card(
                'Theme Mode',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadioListTile<String>(
                      title: const Text('System'),
                      value: 'system',
                      groupValue: _mode,
                      onChanged: (v) => setState(() => _mode = v!),
                    ),
                    RadioListTile<String>(
                      title: const Text('Light'),
                      value: 'light',
                      groupValue: _mode,
                      onChanged: (v) => setState(() => _mode = v!),
                    ),
                    RadioListTile<String>(
                      title: const Text('Dark'),
                      value: 'dark',
                      groupValue: _mode,
                      onChanged: (v) => setState(() => _mode = v!),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tip: add a FlutterFlow “Set Theme Mode” action on Save for instant app-wide change.',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ],
                )),
            const SizedBox(height: 12),
            _card(
                'Accessibility',
                Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Large Text'),
                      subtitle:
                          const Text('Increase text size for readability'),
                      value: _largeText,
                      onChanged: (v) => setState(() => _largeText = v),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('High Contrast'),
                      subtitle: const Text('Stronger contrast for visibility'),
                      value: _highContrast,
                      onChanged: (v) => setState(() => _highContrast = v),
                    ),
                  ],
                )),
            const SizedBox(height: 12),
            _card(
                'Live Preview',
                Theme(
                  data: theme,
                  child: MediaQuery(
                    data:
                        MediaQuery.of(context).copyWith(textScaleFactor: scale),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('This is a heading',
                            style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                            'Body text preview. Toggle options above to see changes.',
                            style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 12),
                        Wrap(spacing: 12, runSpacing: 12, children: [
                          ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.health_and_safety),
                              label: const Text('Health Monitor')),
                          OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.medication),
                              label: const Text('Medications')),
                          ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.emergency),
                              label: const Text('Emergency')),
                        ]),
                        const SizedBox(height: 8),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: const ListTile(
                            leading: Icon(Icons.chat_bubble_outline),
                            title: Text('Messages'),
                            subtitle: Text(
                                'Conversations with caregivers and family'),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.save),
              label: Text(_saving ? 'Saving…' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

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
}
