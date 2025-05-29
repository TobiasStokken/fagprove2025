import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faq_app/models/FAQ_models.dart';
import 'package:faq_app/providers/faqdata_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);
    await FirebaseFirestore.instance
        .collection('faq')
        .doc(widget.docId)
        .update({
      'title': _titleController.text,
      'description': _descriptionController.text,
    });
    setState(() => _isSaving = false);
    if (mounted) Navigator.of(context).pop(true);
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
                      _buildTitleField(),
                      const SizedBox(height: 16),
                      _buildDescriptionField(),
                      const SizedBox(height: 24),
                      _buildActionButtons(),
                      const SizedBox(height: 24),
                      _buildQuestionsHeader(context, ref),
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

  // Show dialog to add a new question
  Future<void> _showAddQuestionDialog(WidgetRef ref) async {
    final questionController = TextEditingController();
    final answerController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nytt spørsmål'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(labelText: 'Spørsmål'),
            ),
            TextField(
              controller: answerController,
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
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Legg til'),
          ),
        ],
      ),
    );
    if (result == true && questionController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('faq')
          .doc(widget.docId)
          .collection('questions')
          .add({
        'question': questionController.text,
        'answer': answerController.text,
      });
      if (mounted) ref.invalidate(faqDataProvider);
      setState(() {});
    }
  }

  // Delete a question
  Future<void> _deleteQuestion(
      WidgetRef ref, String questionId, int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bekreft sletting'),
        content: const Text('Vil du slette dette spørsmålet?'),
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
      ),
    );
    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('faq')
          .doc(widget.docId)
          .collection('questions')
          .doc(questionId)
          .delete();
      setState(() {
        widget.faqData.questions.removeAt(index);
      });
      if (mounted) ref.invalidate(faqDataProvider);
    }
  }

  // Update a question
  Future<void> _updateQuestion(
      WidgetRef ref, String questionId, String newQ, String newA) async {
    await FirebaseFirestore.instance
        .collection('faq')
        .doc(widget.docId)
        .collection('questions')
        .doc(questionId)
        .update({
      'question': newQ,
      'answer': newA,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Spørsmål oppdatert!')),
    );
    if (mounted) ref.invalidate(faqDataProvider);
  }

  Widget _buildTitleField() => TextField(
        controller: _titleController,
        decoration: const InputDecoration(labelText: 'Tittel'),
      );

  Widget _buildDescriptionField() => TextField(
        controller: _descriptionController,
        decoration: const InputDecoration(labelText: 'Beskrivelse'),
        maxLines: 3,
      );

  Widget _buildActionButtons() {
    return _isSaving
        ? const CircularProgressIndicator()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Lagre endringer'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Bekreft sletting'),
                      content: const Text(
                          'Er du sikker på at du vil slette denne FAQ? Dette kan ikke angres.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Avbryt'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Slett',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    setState(() => _isSaving = true);
                    await FirebaseFirestore.instance
                        .collection('faq')
                        .doc(widget.docId)
                        .delete();
                    setState(() => _isSaving = false);
                    if (mounted) Navigator.of(context).pop(true);
                  }
                },
                child: const Text('Slett'),
              ),
            ],
          );
  }

  Widget _buildQuestionsHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Spørsmål',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Legg til spørsmål',
          onPressed: () => _showAddQuestionDialog(ref),
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
