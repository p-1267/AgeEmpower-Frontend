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

class AppHomeNavigationCW extends StatefulWidget {
  final Widget home;
  final Widget chat;
  final Widget health;
  final Widget settings;

  const AppHomeNavigationCW({
    super.key,
    required this.home,
    required this.chat,
    required this.health,
    required this.settings,
  });

  @override
  State<AppHomeNavigationCW> createState() => _AppHomeNavigationCWState();
}

class _AppHomeNavigationCWState extends State<AppHomeNavigationCW> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      widget.home,
      widget.chat,
      widget.health,
      widget.settings,
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Health"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
