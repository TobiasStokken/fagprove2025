import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final askAiProvider = StateNotifierProvider<AskAiNotifier, List<Message>>(
    (ref) => AskAiNotifier());

class Message {
  final String text;
  final bool isUser;
  Message({required this.text, required this.isUser});
}

class AskAiNotifier extends StateNotifier<List<Message>> {
  AskAiNotifier() : super([]);

  Future<void> sendMessage(String text) async {
    state = [...state, Message(text: text, isUser: true)];
    try {
      final response = await FirebaseFunctions.instance
          .httpsCallable('askAi')
          .call({'question': text});
      final String aiResponse = response.data['answer'] ?? 'Ingen svar fra AI.';
      state = [...state, Message(text: aiResponse, isUser: false)];
    } catch (e) {
      state = [...state, Message(text: 'Feil: $e', isUser: false)];
    }
  }
}
