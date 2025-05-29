import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faq_app/providers/faqdata_provider.dart';
// import 'package:faq_app/widgets/faq_theme_card.dart'; // Ikke i bruk
import 'package:faq_app/models/FAQ_models.dart';

class FaqSearchScreen extends ConsumerStatefulWidget {
  const FaqSearchScreen({super.key});

  @override
  ConsumerState<FaqSearchScreen> createState() => _FaqSearchScreenState();
}

class _FaqSearchScreenState extends ConsumerState<FaqSearchScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final faqDataAsync = ref.watch(faqDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Søk i FAQ'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Søk etter ord',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _search = value.trim().toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: faqDataAsync.when(
              data: (faqData) {
                final filtered = _search.isEmpty
                    ? faqData
                    : faqData
                        .map((faq) {
                          // Søk i tittel, beskrivelse og spørsmål
                          final title = faq.theme.title.toLowerCase();
                          final desc = faq.theme.description.toLowerCase();
                          final matchingQuestions = faq.questions.where((q) {
                            final question = q.question.toLowerCase();
                            final answer = q.answer.toLowerCase();
                            return question.contains(_search) ||
                                answer.contains(_search);
                          }).toList();
                          final themeMatch =
                              title.contains(_search) || desc.contains(_search);
                          if (themeMatch || matchingQuestions.isNotEmpty) {
                            // Returner FAQ med kun relevante spørsmål hvis søk på spørsmål
                            return FAQ(
                              theme: faq.theme,
                              questions: themeMatch
                                  ? faq.questions
                                  : matchingQuestions,
                            );
                          }
                          return null;
                        })
                        .whereType<FAQ>()
                        .toList();
                if (filtered.isEmpty) {
                  return const Center(child: Text('Ingen treff.'));
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final faq = filtered[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(faq.theme.title,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(faq.theme.description,
                                style: const TextStyle(color: Colors.black54)),
                            if (faq.questions.isNotEmpty) ...[
                              const Divider(height: 24),
                              ...faq.questions.map((q) => ListTile(
                                    title: Text(q.question),
                                    subtitle: Text(q.answer),
                                  )),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Noe gikk galt: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
