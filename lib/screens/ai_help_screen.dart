import 'package:flutter/material.dart';

class AIHelpScreen extends StatelessWidget {
  const AIHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Help')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.chat_bubble_outline, size: 80, color: Colors.orange),
            const SizedBox(height: 20),
            const Text('Ask AI for assistance!', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Ask AI'),
            ),
          ],
        ),
      ),
    );
  }
}
