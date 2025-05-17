import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triperry/theme/app_theme.dart';
import 'package:triperry/widgets/triperry_app_bar.dart';
import 'package:triperry/services/auth_service.dart';
import 'package:triperry/screens/ai/widgets/attachment_selector.dart';
import 'package:triperry/screens/ai/widgets/chat_messages_section.dart';
import 'package:triperry/screens/ai/widgets/ai_input_area.dart';
import 'package:triperry/screens/ai/widgets/ai_welcome_view.dart';
import 'package:triperry/screens/ai/models/chat_message.dart';

class AiPageModular extends StatefulWidget {
  const AiPageModular({super.key});

  @override
  State<AiPageModular> createState() => _AiPageModularState();
}

class _AiPageModularState extends State<AiPageModular>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;

  // Chat state
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _hasUserInteracted = false;
  final List<MessageAttachment> _pendingAttachments = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();

    // Add welcome message after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _addMessage(
            "Hello! I'm your travel planning assistant. How can I help you today?",
            false);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Get username from AuthService if available
  String get _userName {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      return authService.currentUser?.name ?? 'Traveler';
    } catch (e) {
      return 'Traveler';
    }
  }

  void _addMessage(String text, bool isUser) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: isUser,
        time: DateTime.now(),
        attachments: isUser ? [..._pendingAttachments] : null,
      ));

      // Clear pending attachments after adding them to a message
      if (isUser) {
        _pendingAttachments.clear();
      }

      if (!isUser) {
        _isTyping = false;
      }
    });

    _scrollToBottom();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty && _pendingAttachments.isEmpty) return;

    final messageText = text.trim().isEmpty
        ? (_pendingAttachments.isNotEmpty ? '[Shared attachment]' : '')
        : text;

    _textController.clear();
    _addMessage(messageText, true);

    setState(() {
      _isTyping = true;
      _hasUserInteracted = true;
    });

    // Simulate AI response delay
    Future.delayed(
        Duration(milliseconds: 800 + (text.length * 10).clamp(0, 1200)), () {
      if (mounted) {
        _generateResponse(text);
      }
    });
  }

  void _generateResponse(String text) {
    final String lowercaseText = text.toLowerCase();
    String response;

    if (lowercaseText.contains('hello') || lowercaseText.contains('hi')) {
      response =
          "Hello, $_userName! How can I help with your travel plans today?";
    } else if (lowercaseText.contains('safari') ||
        lowercaseText.contains('wildlife')) {
      response =
          "Kenya offers incredible safaris! The Maasai Mara is known for the Great Migration, while Amboseli has stunning views of Mt. Kilimanjaro. What kind of safari experience interests you?";
    } else if (lowercaseText.contains('beach') ||
        lowercaseText.contains('coast')) {
      response =
          "Kenya's coast is beautiful! Diani Beach has white sands and clear waters, while Lamu offers a unique cultural experience with traditional Swahili architecture. Would you like recommendations for beach resorts?";
    } else if (lowercaseText.contains('hotel') ||
        lowercaseText.contains('stay')) {
      response =
          "I can help you find the perfect accommodation! Kenya offers everything from luxury safari lodges to beachfront resorts. What's your budget range and preferred location?";
    } else if (lowercaseText.contains('food') ||
        lowercaseText.contains('restaurant')) {
      response =
          "Kenyan cuisine is delicious! You can try nyama choma (grilled meat), ugali (cornmeal), and sukuma wiki (collard greens). Nairobi has excellent restaurants ranging from local spots to international cuisine.";
    } else {
      response =
          "That's an interesting question about travel in Kenya! Would you like recommendations for specific destinations, activities, or travel tips?";
    }

    _addMessage(response, false);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppTheme.darkSurface
          : AppTheme.lightSurface,
      appBar: TriperryAppBar(
        title: 'Triperry AI',
        showAI: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () {
              // Show help dialog
            },
          ),
        ],
        onBack: () => Navigator.of(context).pushReplacementNamed('/home'),
      ),
      body: Container(
        // decoration: backgroundDecoration,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.darkSurface
            : AppTheme.lightSurface,
        child: SafeArea(
          child: Column(
            children: [
              // Show greeting and suggestions until user interacts
              if (!_hasUserInteracted) ...[
                Expanded(
                  child: AiWelcomeView(
                    userName: _userName,
                    onSuggestionTap: _handleSubmitted,
                  ),
                ),
              ],

              // Main content - messages
              if (_hasUserInteracted)
                Expanded(
                  child: ChatMessagesSection(
                    scrollController: _scrollController,
                    messages: _messages,
                    isTyping: _isTyping,
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.darkSurface
            : AppTheme.lightSurface,
        child: AiInputArea(
          textController: _textController,
          onAddAttachment: () {}, // No longer needed, options are now embedded
          onSubmitted: _handleSubmitted,
          pendingAttachments: _pendingAttachments,
          onRemoveAttachment: (attachment) {
            setState(() {
              _pendingAttachments.remove(attachment);
            });
          },
        ),
      ),
    );
  }
}
