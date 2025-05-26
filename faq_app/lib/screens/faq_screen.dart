import 'package:flutter/material.dart';

class FaqListScreen extends StatelessWidget {
  const FaqListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.question_answer, size: 48),
          SizedBox(width: 16),
          Text('FAQ List', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
