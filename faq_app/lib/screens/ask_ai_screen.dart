import 'package:flutter/material.dart';

class AskAiScreen extends StatelessWidget {
  const AskAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Spør Ai side', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
