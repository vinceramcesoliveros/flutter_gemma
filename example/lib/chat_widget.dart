import 'package:flutter/material.dart';
import 'package:flutter_gemma/core/chat.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma_example/chat_input_field.dart';
import 'package:flutter_gemma_example/chat_message.dart';
import 'package:flutter_gemma_example/gemma_input_field.dart';

class ChatListWidget extends StatelessWidget {
  const ChatListWidget({
    required this.messages,
    required this.gemmaHandler,
    required this.humanHandler,
    required this.errorHandler,
    this.chat,
    super.key,
  });

  final InferenceChat? chat;
  final List<Message> messages;
  final ValueChanged<ModelResponse> gemmaHandler; // Принимает ModelResponse (TextToken | FunctionCall)
  final ValueChanged<Message> humanHandler; // Changed from String to Message
  final ValueChanged<String> errorHandler;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      reverse: true,
      itemCount: messages.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          if (messages.isNotEmpty && messages.last.isUser) {
            return GemmaInputField(
              chat: chat,
              messages: messages,
              streamHandler: gemmaHandler,
              errorHandler: errorHandler,
            );
          }
          if (messages.isEmpty || !messages.last.isUser) {
            return ChatInputField(
              handleSubmitted: humanHandler,
              supportsImages: chat?.supportsImages ?? false, // Pass image support
            );
          }
        } else if (index == 1) {
          return const Divider(height: 1.0);
        } else {
          final message = messages.reversed.toList()[index - 2];
          return ChatMessageWidget(
            message: message,
          );
        }
        return null;
      },
    );
  }
}