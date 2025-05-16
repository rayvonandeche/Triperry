import 'dart:async';
import 'package:flutter/material.dart';
import 'package:triperry/screens/ai/models/chat_message.dart';

/// Service to handle mini AI assistant interactions
class MiniAssistantService {
  final List<ChatMessage> _messages = [];
  final StreamController<List<ChatMessage>> _messagesController = StreamController<List<ChatMessage>>.broadcast();
  bool _isTyping = false;
  final StreamController<bool> _typingController = StreamController<bool>.broadcast();

  // Expose streams
  Stream<List<ChatMessage>> get messages => _messagesController.stream;
  Stream<bool> get isTypingStream => _typingController.stream;
  
  // Getters
  List<ChatMessage> get currentMessages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;
  ChatMessage? get lastResponse => _messages.isEmpty 
      ? null 
      : _messages.reversed.firstWhere((msg) => !msg.isUser, orElse: () => _messages.last);
  ChatMessage? get lastUserMessage => _messages.isEmpty
      ? null
      : _messages.reversed.firstWhere((msg) => msg.isUser, orElse: () => _messages.last);

  void dispose() {
    _messagesController.close();
    _typingController.close();
  }

  /// Add a user message
  void addUserMessage(String text) {
    final message = ChatMessage(
      text: text,
      isUser: true,
      time: DateTime.now(),
    );
    
    _messages.add(message);
    _messagesController.add(_messages);
    
    // Set typing indicator
    _isTyping = true;
    _typingController.add(_isTyping);
    
    // Get AI response
    _getAIResponse(text);
  }
  
  /// Simulate AI response
  Future<void> _getAIResponse(String userMessage) async {
    // In a real app, this would call your API or AI service
    // For now we'll simulate a delay and pre-programmed responses
    await Future.delayed(const Duration(milliseconds: 1500));
    
    String responseText;
    
    // Simple response matching (in a real app, this would be handled by an AI service)
    final lowerText = userMessage.toLowerCase();
    
    if (lowerText.contains('hello') || lowerText.contains('hi') || lowerText.contains('hey')) {
      responseText = "Hello! How can I assist with your travel plans today?";
    } else if (lowerText.contains('weather')) {
      responseText = "Currently it's sunny in Nairobi with temperatures around 25°C. Would you like more detailed weather information?";
    } else if (lowerText.contains('restaurant') || lowerText.contains('food') || lowerText.contains('eat')) {
      responseText = "I can recommend some great restaurants in your area. What type of cuisine are you interested in?";
    } else if (lowerText.contains('hotel') || lowerText.contains('stay') || lowerText.contains('accommodation')) {
      responseText = "I found several highly-rated hotels nearby. Would you like me to show you options with prices?";
    } else if (lowerText.contains('flight') || lowerText.contains('fly')) {
      responseText = "I can help you find flights. Could you provide your departure city and destination?";
    } else if (lowerText.contains('safari') || lowerText.contains('wildlife')) {
      responseText = "Kenya offers amazing safari experiences. The Maasai Mara is particularly good this time of year. Would you like more details?";
    } else if (lowerText.contains('beach')) {
      responseText = "Diani Beach is one of Kenya's most beautiful beaches, with white sand and clear blue waters. Would you like to see some photos?";
    } else {
      responseText = "That's an interesting question about your travels. Would you like me to search for more information, or would you prefer to open the full AI assistant for a more detailed response?";
    }
    
    final aiMessage = ChatMessage(
      text: responseText,
      isUser: false,
      time: DateTime.now(),
    );
    
    _messages.add(aiMessage);
    _messagesController.add(_messages);
    
    _isTyping = false;
    _typingController.add(_isTyping);
  }
  
  /// Clear conversation history
  void clearMessages() {
    _messages.clear();
    _messagesController.add(_messages);
  }
}
