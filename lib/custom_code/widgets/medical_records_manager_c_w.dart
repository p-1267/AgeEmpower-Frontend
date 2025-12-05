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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicalRecordsManagerCW extends StatelessWidget {
  final double? width;
  final double? height;

  const MedicalRecordsManagerCW({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Text("Login required.");

    final ref = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("records");

    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.upload_file),
          label: const Text("Upload Record"),
          onPressed: () async {
            // FlutterFlow upload action
          },
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: ref.orderBy("createdAt", descending: true).snapshots(),
            builder: (c, snap) {
              if (!snap.hasData) return const CircularProgressIndicator();
              return ListView(
                children: snap.data!.docs.map((d) {
                  final data = d.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(data["name"] ?? ""),
                    subtitle: Text(data["type"] ?? ""),
                    trailing: const Icon(Icons.picture_as_pdf),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/PdfViewer",
                        arguments: data["fileUrl"],
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
        )
      ],
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
