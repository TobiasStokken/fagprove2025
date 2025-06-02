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
              onPressed: () => _showAddFaqDialog(context, ref),
              child: const Text('Ny FAQ'),
            ),
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

  Future<void> _showAddFaqDialog(BuildContext context, WidgetRef ref) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ny FAQ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Tittel'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Beskrivelse'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Avbryt'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Opprett'),
          ),
        ],
      ),
    );
    if (result == true && titleController.text.isNotEmpty) {
      await FirebaseFunctions.instance.httpsCallable('createNewFAQ').call({
        'title': titleController.text,
        'description': descriptionController.text
      });
      ref.invalidate(faqDataProvider);
    }
  }
}
