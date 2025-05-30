import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faq_app/providers/faqData_provider.dart';
import 'package:faq_app/widgets/faq_theme_card.dart';
import 'package:flutter/material.dart';

class FaqListScreen extends ConsumerWidget {
  const FaqListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqDataAsync = ref.watch(faqDataProvider);
    return faqDataAsync.when(
      data: (faqData) => _successWidget(faqData, ref),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Noe gikk galt: $e')),
    );
  }

  Widget _successWidget(List faqData, WidgetRef ref) {
    if (faqData.isEmpty) {
      return const Center(child: Text('Ingen FAQ-temaer funnet.'));
    }
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(faqDataProvider);
      },
      child: ListView(
        padding: EdgeInsets.zero,
        children:
            faqData.map((faqData) => FaqThemeCard(faqData: faqData)).toList(),
      ),
    );
  }
}
