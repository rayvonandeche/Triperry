import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triperry/theme/app_theme.dart';
import 'package:triperry/widgets/triperry_app_bar.dart';
import 'package:triperry/services/auth_service.dart';
import 'package:triperry/screens/ai/widgets/chat_messages_section.dart';
import 'package:triperry/screens/ai/widgets/ai_input_area.dart';
import 'package:triperry/screens/ai/widgets/ai_welcome_view.dart';
import 'package:triperry/screens/ai/models/chat_message.dart';
import 'package:triperry/services/gemini_service.dart' as gemini_rest;
import 'package:triperry/services/api_keys.dart';
import 'dart:async';

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
  gemini_rest.GeminiService? _geminiService;
  StreamSubscription<String>? _streamSubscription;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();

    // Import API key from separate file for better security
    _initializeGeminiService();

    // Add welcome message after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _addMessage(
            "Hello! I'm your travel planning assistant. How can I help you today?",
            false);
      }
    });
  }
    void _initializeGeminiService() async {
    try {
      // Using the API key from the api_keys.dart file
      _geminiService = gemini_rest.GeminiService(ApiKeys.geminiApiKey);
      print('Gemini service initialized successfully');
    } catch (e) {
      print('Failed to initialize Gemini service: $e');
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    _streamSubscription?.cancel();
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
    });  }  
    void _generateResponse(String text) async {
    // Verify the Gemini service is initialized
    if (_geminiService == null) {
      _initializeGeminiService();
      // Show error message if still null
      if (_geminiService == null) {
        setState(() {
          _messages.add(ChatMessage(
            text: 'Sorry, the AI service is not available at the moment. Please try again later.',
            isUser: false,
            time: DateTime.now(),
          ));
          _isTyping = false;
        });
        return;
      }
    }

    setState(() {
      _isTyping = true;
    });

    // Add an empty AI message for streaming
    setState(() {
      _messages.add(ChatMessage(
        text: '',
        isUser: false,
        time: DateTime.now(),
      ));
    });

    // Cancel previous stream if any
    await _streamSubscription?.cancel();
    final aiMsgIndex = _messages.length - 1;
    StringBuffer buffer = StringBuffer();
      try {
      print('Starting Gemini API stream for prompt: ${text.substring(0, text.length > 50 ? 50 : text.length)}...');
      _streamSubscription = _geminiService!
          .streamContent(prompt: text)
          .listen(
        (chunk) {
          print('Received chunk: ${chunk.length} characters');
          buffer.write(chunk);
          setState(() {
            _messages[aiMsgIndex] = _messages[aiMsgIndex].copyWith(text: buffer.toString());
          });
          _scrollToBottom();
        },
        onDone: () {
          print('Stream completed successfully');
          setState(() {
            _isTyping = false;
          });
        },        onError: (e) {
          print('Stream error: $e');
          String errorMessage;
          
          // Handle different types of errors more gracefully
          if (e.toString().contains('429')) {
            errorMessage = 'Rate limit exceeded. Please try again in a few moments.';
          } else if (e.toString().contains('403')) {
            errorMessage = 'API key or authentication error. Please check your API key configuration.';
          } else if (e.toString().contains('timeout') || e.toString().contains('timed out')) {
            errorMessage = 'The request timed out. Please check your internet connection and try again.';
          } else {
            errorMessage = 'Sorry, I encountered an error while generating a response. Please try again.';
          }
          
          setState(() {
            _messages[aiMsgIndex] = _messages[aiMsgIndex].copyWith(
              text: buffer.toString().isNotEmpty 
                  ? buffer.toString() 
                  : errorMessage
            );
            _isTyping = false;
          });
          _scrollToBottom();
        },
      );
    } catch (e) {
      print('Exception creating stream: $e');
      setState(() {
        _messages[aiMsgIndex] = _messages[aiMsgIndex].copyWith(
          text: 'Sorry, I encountered an error while generating a response. Please try again.'
        );
        _isTyping = false;
      });
      _scrollToBottom();
    }
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
