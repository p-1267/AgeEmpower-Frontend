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

class MorningSetupCW extends StatefulWidget {
  const MorningSetupCW({Key? key, this.width, this.height}) : super(key: key);
  final double? width;
  final double? height;

  @override
  State<MorningSetupCW> createState() => _MorningSetupCWState();
}

class _MorningSetupCWState extends State<MorningSetupCW> {
  static const _kMeds = 'ms_meds';
  static const _kWater = 'ms_water';
  static const _kBreakfast = 'ms_breakfast';

  TimeOfDay? _meds;
  TimeOfDay? _water;
  TimeOfDay? _breakfast;
  bool _saving = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  TimeOfDay? _fromMins(int? m) =>
      m == null ? null : TimeOfDay(hour: (m ~/ 60) % 24, minute: m % 60);
  int _toMins(TimeOfDay t) => t.hour * 60 + t.minute;

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    _meds = _fromMins(p.getInt(_kMeds));
    _water = _fromMins(p.getInt(_kWater));
    _breakfast = _fromMins(p.getInt(_kBreakfast));
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _pick(String which) async {
    final initial = const TimeOfDay(hour: 7, minute: 0);
    final t = await showTimePicker(context: context, initialTime: initial);
    if (t == null) return;
    setState(() {
      if (which == 'meds') _meds = t;
      if (which == 'water') _water = t;
      if (which == 'breakfast') _breakfast = t;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    final p = await SharedPreferences.getInstance();
    if (_meds != null)
      await p.setInt(_kMeds, _toMins(_meds!));
    else
      await p.remove(_kMeds);
    if (_water != null)
      await p.setInt(_kWater, _toMins(_water!));
    else
      await p.remove(_kWater);
    if (_breakfast != null)
      await p.setInt(_kBreakfast, _toMins(_breakfast!));
    else
      await p.remove(_kBreakfast);

    // Call helper (stub where you’ll schedule notifications later)
    await scheduleMorningBundle(
      context,
      medsTime: _meds,
      hydrateTime: _water,
      breakfastTime: _breakfast,
    );

    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Morning reminders saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final card = Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Morning setup',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Medication time'),
              subtitle: Text(_meds?.format(context) ?? 'Not set'),
              trailing: const Icon(Icons.schedule),
              onTap: () => _pick('meds'),
            ),
            ListTile(
              title: const Text('Hydration time'),
              subtitle: Text(_water?.format(context) ?? 'Not set'),
              trailing: const Icon(Icons.schedule),
              onTap: () => _pick('water'),
            ),
            ListTile(
              title: const Text('Breakfast time'),
              subtitle: Text(_breakfast?.format(context) ?? 'Not set'),
              trailing: const Icon(Icons.schedule),
              onTap: () => _pick('breakfast'),
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
            )
          ],
        ),
      ),
    );

    return SizedBox(width: widget.width, height: widget.height, child: card);
  }
}
