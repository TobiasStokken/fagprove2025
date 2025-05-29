import 'package:faq_app/models/FAQ_models.dart';
import 'package:faq_app/providers/faqdata_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FaqQuestionScreen extends ConsumerWidget {
  const FaqQuestionScreen({
    super.key,
    required this.faqData,
  });

  final FAQ faqData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(faqDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(faqData.theme.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              faqData.theme.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              faqData.theme.description,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Opprettet: ${faqData.theme.createdAt}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Divider(height: 32, thickness: 1.2),
            const Text('Spørsmål:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 8),
            ...faqData.questions.map((q) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Spørsmål: ${q.question}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Text('Svar: ${q.answer}',
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                )),
            if (faqData.questions.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Ingen spørsmål registrert.',
                    style: TextStyle(color: Colors.grey)),
              ),
          ],
        ),
      ),
    );
  }
}
