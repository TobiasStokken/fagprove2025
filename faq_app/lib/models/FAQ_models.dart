import 'package:cloud_firestore/cloud_firestore.dart';

class FAQTheme {
  final String title;
  final String description;
  final Timestamp createdAt;
  final String id;

  FAQTheme({
    required this.title,
    required this.description,
    required this.createdAt,
    required this.id,
  });
}

class FAQQuestion {
  final String question;
  final String answer;
  final Timestamp createdAt;
  final String id;

  FAQQuestion({
    required this.question,
    required this.answer,
    required this.createdAt,
    required this.id,
  });
}

class FAQ {
  final FAQTheme theme;
  final List<FAQQuestion> questions;

  FAQ({required this.theme, required this.questions});
}
