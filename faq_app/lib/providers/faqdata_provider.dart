import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/FAQ_models.dart';

final faqDataProvider = FutureProvider<List<FAQ>>((ref) async {
  final snapshot = await FirebaseFirestore.instance.collection('faq').get();
  List<FAQ> faqs = [];
  for (final doc in snapshot.docs) {
    final data = doc.data();
    final theme = FAQTheme(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      id: doc.id,
    );
    // Fetch questions subcollection
    final questionsSnapshot = await doc.reference.collection('questions').get();
    final questions = questionsSnapshot.docs.map((qDoc) {
      final qData = qDoc.data();
      return FAQQuestion(
        question: qData['question'] ?? '',
        answer: qData['answer'] ?? '',
        createdAt: qData['createdAt'] ?? Timestamp.now(),
        id: qDoc.id,
      );
    }).toList();
    faqs.add(FAQ(theme: theme, questions: questions));
  }
  faqs.sort((a, b) => b.theme.createdAt.compareTo(a.theme.createdAt));

  return faqs;
});
