import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/typing_indicator.dart';

class ChatMessagesSection extends StatelessWidget {
  final ScrollController scrollController;
  final List<ChatMessage> messages;
  final bool isTyping;
  
  const ChatMessagesSection({
    Key? key,
    required this.scrollController,
    required this.messages,
    required this.isTyping,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: messages.length + (isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length) {
          return const TypingIndicator();
        }
        // Use the ChatMessage directly with the new widget
        return ChatMessageBubble(
          message: messages[index].text,
          isUser: messages[index].isUser,
          time: messages[index].time,
          attachments: messages[index].attachments,
        );
      },
    );
  }
}
