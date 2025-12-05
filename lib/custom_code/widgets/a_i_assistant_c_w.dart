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

class AIAssistantCW extends StatefulWidget {
  const AIAssistantCW({super.key});

  @override
  State<AIAssistantCW> createState() => _AIAssistantCWState();
}

class _AIAssistantCWState extends State<AIAssistantCW> {
  final List<Map<String, String>> messages = [];
  final TextEditingController controller = TextEditingController();

  String? userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
  }

  // ------------------------------------------------------------------
  // SEND MESSAGE TO AI (stub engine)
  // ------------------------------------------------------------------
  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": text.trim()});
    });

    controller.clear();

    final reply = await _generateAIReply(text.trim());
    setState(() {
      messages.add({"role": "ai", "text": reply});
    });
  }

  // ------------------------------------------------------------------
  // STUB AI ENGINE
  // This simulates conversational intelligence.
  // Replace later with OpenAI or your backend.
  // ------------------------------------------------------------------
  Future<String> _generateAIReply(String input) async {
    await Future.delayed(const Duration(milliseconds: 600)); // realism

    final lower = input.toLowerCase();

    // Safety-related intent
    if (lower.contains("fall") || lower.contains("dizzy")) {
      return "It sounds like you're concerned about falls. Try standing up slowly, staying hydrated, and using stable support when walking. If dizziness continues, notify a caregiver or use the SOS feature.";
    }

    if (lower.contains("med") || lower.contains("pill")) {
      return "Your medications should be taken as prescribed. I can help explain side effects if you tell me which medication you're curious about.";
    }

    if (lower.contains("help") || lower.contains("emergency")) {
      return "If this is an emergency, please activate the SOS button immediately. I can guide you, but safety comes first.";
    }

    if (lower.contains("tired") || lower.contains("sleep")) {
      return "Try maintaining a consistent sleep schedule and reducing screen exposure before bedtime. Gentle stretching can also help relaxation.";
    }

    if (lower.contains("pain") || lower.contains("hurt")) {
      return "If you're experiencing new or worsening pain, it’s important to tell a caregiver. If the pain is severe or unusual, consider activating the emergency feature.";
    }

    if (lower.contains("lonely") || lower.contains("sad")) {
      return "I'm here with you. Staying connected to family and caregivers can help. Would you like suggestions for uplifting activities?";
    }

    // General help
    if (lower.contains("what should i do")) {
      return "I can guide you based on your situation. Are you feeling unwell, confused, or worried about something specific?";
    }

    // Default fallback
    return "I'm here to help with safety, health, medications, and daily guidance. Tell me how you're feeling or what you need.";
  }

  // ------------------------------------------------------------------
  // QUICK SUGGESTION BUTTONS
  // ------------------------------------------------------------------
  Widget _quickSuggestion(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () => _sendMessage(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade100,
          foregroundColor: Colors.black,
        ),
        child: Text(text),
      ),
    );
  }

  // ------------------------------------------------------------------
  // UI BUILD
  // ------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Row(
          children: const [
            Icon(Icons.psychology_rounded, size: 32),
            SizedBox(width: 10),
            Text(
              "AI Assistant",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
          ],
        ),

        const SizedBox(height: 12),

        // Quick suggestions
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _quickSuggestion("How can I prevent falls?"),
              _quickSuggestion("Explain my medications"),
              _quickSuggestion("I feel dizzy"),
              _quickSuggestion("What should I do?"),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Chat display
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final m = messages[index];
              final isUser = m["role"] == "user";

              return Align(
                alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blue.shade300 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    m["text"]!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          ),
        ),

        // Input box
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Ask me anything…",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onSubmitted: _sendMessage,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _sendMessage(controller.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
