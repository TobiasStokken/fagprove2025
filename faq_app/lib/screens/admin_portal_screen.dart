import 'package:faq_app/providers/faqdata_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:faq_app/screens/faq_edit_screen.dart';

class AdminPortalScreen extends ConsumerWidget {
  const AdminPortalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqDataAsync = ref.watch(faqDataProvider);
    return faqDataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (faqData) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () async {
                await FirebaseFunctions.instance
                    .httpsCallable('createNewFAQ')
                    .call({'title': 'Faq 0', 'description': 'description'});
                ref.invalidate(faqDataProvider);
              },
              child: const Text('Ny FAQ'),
            ),
            const Text('Admin side', style: TextStyle(fontSize: 24)),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: faqData.length,
                itemBuilder: (context, index) {
                  final faq = faqData[index];
                  return ListTile(
                    title: Text(faq.theme.title),
                    subtitle: Text(faq.theme.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FaqEditScreen(
                              faqData: faq,
                              docId: faq.theme.id,
                            ),
                          ),
                        ).then((value) {
                          if (value == true) {
                            ref.invalidate(faqDataProvider);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
