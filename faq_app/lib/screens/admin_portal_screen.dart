import 'package:flutter/material.dart';

class AdminPortalScreen extends StatelessWidget {
  const AdminPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Admin side', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
