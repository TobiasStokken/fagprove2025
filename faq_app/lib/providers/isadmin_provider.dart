import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isAdminProvider = FutureProvider<bool>((ref) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  final snapshot =
      await FirebaseFirestore.instance.collection('admin').doc(userId).get();
  return snapshot.exists;
});
