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

// Caregiver Management Page - FlutterFlow Custom Widget (Container-based, no Scaffold)
// Ready for FlutterFlow UI Builder & Test Mode. Includes demo data, add/edit, permissions, temp access, logs, emergency override.

import 'package:intl/intl.dart';

class CaregiverManagementPage extends StatefulWidget {
  const CaregiverManagementPage({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  State<CaregiverManagementPage> createState() =>
      _CaregiverManagementPageState();
}

class _CaregiverManagementPageState extends State<CaregiverManagementPage> {
  List<Map<String, dynamic>> caregivers = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  String _permissionLevel = 'View Only';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    caregivers = [
      {
        'name': 'Jane Doe',
        'email': 'jane@example.com',
        'phone': '+1 555 0100',
        'role': 'Primary Caregiver',
        'permission': 'Admin',
        'startDate': DateTime.now().subtract(const Duration(days: 30)),
        'endDate': null,
        'lastActive': DateTime.now(),
        'status': 'Active',
      },
      {
        'name': 'John Smith',
        'email': 'john@example.com',
        'phone': '+1 555 0123',
        'role': 'Backup Caregiver',
        'permission': 'View Only',
        'startDate': DateTime.now().subtract(const Duration(days: 10)),
        'endDate': null,
        'lastActive': DateTime.now().subtract(const Duration(hours: 2)),
        'status': 'Active',
      },
    ];
  }

  void _addOrEditCaregiver({int? index}) {
    if (index != null) {
      final cg = caregivers[index];
      _nameController.text = cg['name'] ?? '';
      _emailController.text = cg['email'] ?? '';
      _phoneController.text = cg['phone'] ?? '';
      _roleController.text = cg['role'] ?? '';
      _permissionLevel = cg['permission'] ?? 'View Only';
      _startDate = cg['startDate'];
      _endDate = cg['endDate'];
    } else {
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _roleController.clear();
      _permissionLevel = 'View Only';
      _startDate = null;
      _endDate = null;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 20,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(index == null ? 'Add Caregiver' : 'Edit Caregiver',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _roleController,
                  decoration:
                      const InputDecoration(labelText: 'Relationship / Role'),
                ),
                DropdownButtonFormField<String>(
                  value: _permissionLevel,
                  decoration:
                      const InputDecoration(labelText: 'Permission Level'),
                  items: const [
                    DropdownMenuItem(
                        value: 'View Only', child: Text('View Only')),
                    DropdownMenuItem(value: 'Edit', child: Text('Edit')),
                    DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                  ],
                  onChanged: (value) =>
                      setState(() => _permissionLevel = value!),
                ),
                const SizedBox(height: 10),
                const Text('Temporary Access Period:'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Text(_startDate == null
                          ? 'Start Date'
                          : DateFormat('MMM d, yyyy').format(_startDate!)),
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _startDate = picked);
                      },
                    ),
                    TextButton(
                      child: Text(_endDate == null
                          ? 'End Date'
                          : DateFormat('MMM d, yyyy').format(_endDate!)),
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _startDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _endDate = picked);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final caregiver = {
                        'name': _nameController.text,
                        'email': _emailController.text,
                        'phone': _phoneController.text,
                        'role': _roleController.text,
                        'permission': _permissionLevel,
                        'startDate': _startDate,
                        'endDate': _endDate,
                        'lastActive': DateTime.now(),
                        'status': 'Active',
                      };
                      setState(() {
                        if (index == null) {
                          caregivers.add(caregiver);
                        } else {
                          caregivers[index] = caregiver;
                        }
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                      index == null ? 'Add Caregiver' : 'Update Caregiver'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showActivityLogs(Map<String, dynamic> caregiver) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Activity Logs for ${caregiver['name']}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text('Shift log ${index + 1} - Example Entry'),
                subtitle: Text('Timestamp: ${DateTime.now()}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row (optional, page can also provide its own AppBar)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Caregivers',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addOrEditCaregiver(),
                  tooltip: 'Add Caregiver',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: caregivers.isEmpty
                ? const Center(child: Text('No caregivers added yet.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: caregivers.length,
                    itemBuilder: (context, index) {
                      final caregiver = caregivers[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(caregiver['name'] ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${caregiver['role']} | ${caregiver['permission']}'),
                              if (caregiver['startDate'] != null)
                                Text(
                                    'Access: ${DateFormat('MMM d').format(caregiver['startDate'])} - ${caregiver['endDate'] != null ? DateFormat('MMM d').format(caregiver['endDate']) : 'Ongoing'}'),
                              if (caregiver['lastActive'] != null)
                                Text(
                                    'Last Active: ${DateFormat('MMM d, HH:mm').format(caregiver['lastActive'])}'),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit')
                                _addOrEditCaregiver(index: index);
                              if (value == 'logs') _showActivityLogs(caregiver);
                              if (value == 'remove')
                                setState(() => caregivers.removeAt(index));
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(value: 'edit', child: Text('Edit')),
                              PopupMenuItem(
                                  value: 'logs', child: Text('View Logs')),
                              PopupMenuItem(
                                  value: 'remove', child: Text('Remove')),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _addOrEditCaregiver(),
                      icon: const Icon(Icons.person_add_alt_1),
                      label: const Text('Add Caregiver'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const AlertDialog(
                          title: Text('Emergency Override'),
                          content:
                              Text('Demo override triggered successfully.'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.warning_amber_rounded),
                    label: const Text('Override'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
