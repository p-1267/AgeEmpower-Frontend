// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> saveMedicationDoc(
  bool isEdit,
  String medDocId,
  String name,
  String dose,
  String time,
  String notes,
) async {
  final auth = FirebaseAuth.instance;
  final user = auth.currentUser ?? (await auth.signInAnonymously()).user;
  if (user == null) {
    throw Exception('Unable to get a Firebase user.');
  }
  final uid = user.uid;

  final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

  await userRef
      .set({'_init': FieldValue.serverTimestamp()}, SetOptions(merge: true));

  final medsCol = userRef.collection('medications');

  final data = <String, dynamic>{
    'name': name.trim(),
    'dose': dose.trim(),
    'time': time.trim(), // store as HH:mm string
    'notes': notes.trim(),
    'updated_at': FieldValue.serverTimestamp(),
  };

  if (isEdit && medDocId.isNotEmpty) {
    final docRef = medsCol.doc(medDocId);
    final snap = await docRef.get();
    final prevTaken = (snap.data()?['taken'] as bool?) ?? false;
    data['taken'] = prevTaken;

    await docRef.set(data, SetOptions(merge: true));
    return docRef.id;
  } else {
    data['created_at'] = FieldValue.serverTimestamp();
    data['taken'] = false;

    final docRef = await medsCol.add(data);
    return docRef.id;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
