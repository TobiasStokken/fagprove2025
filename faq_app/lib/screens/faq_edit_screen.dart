import 'package:cloud_functions/cloud_functions.dart';
import 'package:faq_app/models/FAQ_models.dart';
import 'package:faq_app/providers/faqdata_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Main screen for editing a FAQ
class FaqEditScreen extends StatefulWidget {
  final FAQ faqData;
  final String docId;
  const FaqEditScreen({super.key, required this.faqData, required this.docId});

  @override
  State<FaqEditScreen> createState() => _FaqEditScreenState();
}

class _FaqEditScreenState extends State<FaqEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.faqData.theme.title);
    _descriptionController =
        TextEditingController(text: widget.faqData.theme.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Save FAQ changes to backend
  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);
    await FirebaseFunctions.instance.httpsCallable('editFAQ').call({
      'faqId': widget.docId,
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
    });
    setState(() => _isSaving = false);
    if (mounted) Navigator.of(context).pop(true);
  }

  // Show dialog to add a new question
  Future<void> _showAddQuestionDialog(WidgetRef ref) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AddQuestionDialog(),
    );
    if (result != null && result) {
      final question = AddQuestionDialog.question;
      final answer = AddQuestionDialog.answer;
      if (question.isNotEmpty) {
        await FirebaseFunctions.instance.httpsCallable('createQuestion').call({
          'faqId': widget.docId,
          'question': question,
          'answer': answer,
        });
        if (mounted) ref.invalidate(faqDataProvider);
        setState(() {});
      }
    }
  }

  // Delete a question
  Future<void> _deleteQuestion(
      WidgetRef ref, String questionId, int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDeleteDialog(),
    );
    if (confirm == true) {
      await FirebaseFunctions.instance.httpsCallable('deleteQuestion').call({
        'faqId': widget.docId,
        'questionId': questionId,
      });
      if (mounted) ref.invalidate(faqDataProvider);
      setState(() {});
    }
  }

  // Update a question
  Future<void> _updateQuestion(WidgetRef ref, String questionId,
      String newQuestion, String newAnswer) async {
    await FirebaseFunctions.instance.httpsCallable('editQuestion').call({
      'faqId': widget.docId,
      'questionId': questionId,
      'question': newQuestion,
      'answer': newAnswer,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Spørsmål oppdatert!')),
    );
    if (mounted) ref.invalidate(faqDataProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final asyncFaq = ref.watch(faqDataProvider);
        return asyncFaq.when(
          data: (faqList) {
            final faq = faqList.firstWhere(
              (f) => f.theme.id == widget.docId,
              orElse: () => widget.faqData,
            );
            return Scaffold(
              appBar: AppBar(title: const Text('Rediger FAQ')),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _TitleField(controller: _titleController),
                      const SizedBox(height: 16),
                      _DescriptionField(controller: _descriptionController),
                      const SizedBox(height: 24),
                      _ActionButtons(
                        isSaving: _isSaving,
                        onSave: _saveChanges,
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) =>
                                ConfirmDeleteDialog(isFaq: true),
                          );
                          if (confirm == true) {
                            setState(() => _isSaving = true);
                            await FirebaseFunctions.instance
                                .httpsCallable('deleteFAQ')
                                .call({'faqId': widget.docId});
                            setState(() => _isSaving = false);
                            if (mounted) Navigator.of(context).pop(true);
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      _QuestionsHeader(
                          onAdd: () => _showAddQuestionDialog(ref)),
                      ..._buildQuestionList(ref, faq),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Noe gikk galt: $e')),
        );
      },
    );
  }

  // Build the list of question cards
  List<Widget> _buildQuestionList(WidgetRef ref, FAQ faq) {
    final questions = faq.questions;
    if (questions.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Ingen spørsmål registrert.',
              style: TextStyle(color: Colors.grey)),
        ),
      ];
    }
    return List.generate(questions.length, (index) {
      final q = questions[index];
      return QuestionCard(
        question: q,
        onDelete: () => _deleteQuestion(ref, q.id, index),
        onSave: (newQ, newA) => _updateQuestion(ref, q.id, newQ, newA),
      );
    });
  }
}

// --- UI Helper Widgets ---

class _TitleField extends StatelessWidget {
  final TextEditingController controller;
  const _TitleField({required this.controller});
  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'Tittel'),
      );
}

class _DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  const _DescriptionField({required this.controller});
  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'Beskrivelse'),
        maxLines: 3,
      );
}

class _ActionButtons extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onDelete;
  const _ActionButtons(
      {required this.isSaving, required this.onSave, required this.onDelete});
  @override
  Widget build(BuildContext context) {
    return isSaving
        ? const CircularProgressIndicator()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: onSave,
                child: const Text('Lagre endringer'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: onDelete,
                child: const Text('Slett'),
              ),
            ],
          );
  }
}

class _QuestionsHeader extends StatelessWidget {
  final VoidCallback onAdd;
  const _QuestionsHeader({required this.onAdd});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Spørsmål',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Legg til spørsmål',
          onPressed: onAdd,
        ),
      ],
    );
  }
}

// --- Dialogs ---

class AddQuestionDialog extends StatefulWidget {
  static String question = '';
  static String answer = '';
  @override
  State<AddQuestionDialog> createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<AddQuestionDialog> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nytt spørsmål'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _questionController,
            decoration: const InputDecoration(labelText: 'Spørsmål'),
          ),
          TextField(
            controller: _answerController,
            decoration: const InputDecoration(labelText: 'Svar'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Avbryt'),
        ),
        TextButton(
          onPressed: () {
            AddQuestionDialog.question = _questionController.text;
            AddQuestionDialog.answer = _answerController.text;
            Navigator.of(context).pop(true);
          },
          child: const Text('Legg til'),
        ),
      ],
    );
  }
}

class ConfirmDeleteDialog extends StatelessWidget {
  final bool isFaq;
  const ConfirmDeleteDialog({this.isFaq = false});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isFaq ? 'Bekreft sletting av FAQ' : 'Bekreft sletting'),
      content: Text(isFaq
          ? 'Er du sikker på at du vil slette denne FAQ? Dette kan ikke angres.'
          : 'Vil du slette dette spørsmålet?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Avbryt'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Slett', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

// Widget for a single question card
class QuestionCard extends StatefulWidget {
  final dynamic question;
  final VoidCallback onDelete;
  final Future<void> Function(String, String) onSave;
  const QuestionCard(
      {super.key,
      required this.question,
      required this.onDelete,
      required this.onSave});

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  late TextEditingController _questionController;
  late TextEditingController _answerController;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question.question);
    _answerController = TextEditingController(text: widget.question.answer);
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: 'Spørsmål'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(labelText: 'Svar'),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Slett spørsmål',
                  onPressed: widget.onDelete,
                ),
                IconButton(
                  icon: const Icon(Icons.save, color: Colors.green),
                  tooltip: 'Lagre endringer',
                  onPressed: () => widget.onSave(
                      _questionController.text, _answerController.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
