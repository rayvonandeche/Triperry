import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/app_theme.dart';
import '../models/chat_message.dart';
import 'attachment_content.dart';

class ChatMessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime time;
  final List<MessageAttachment>? attachments;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.time,
    this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (!isUser) {
      // AI message: response content directly on background without icon
      return Padding(
        padding: const EdgeInsets.only(bottom: 24, left: 0, right: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 0, top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (attachments != null && attachments!.isNotEmpty)
                    _buildAttachments(attachments!),
                  if (message.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, right: 8.0),
                      child: Text(
                        message,
                        style: TextStyle(
                          color: isDarkMode
                              ? AppTheme.lightText
                              : AppTheme.darkText,
                          fontSize: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.2, end: 0, duration: 300.ms);
    }
    // User message
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
        right: 0,
        left: 60,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.primaryColor.withOpacity(0.2)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 3,
                    spreadRadius: 0.5,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (attachments != null && attachments!.isNotEmpty)
                    _buildAttachments(attachments!),
                  if (message.trim().isNotEmpty)
                    Text(
                      message,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.9)
                            : AppTheme.darkText,
                        fontSize: 16,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.2, end: 0, duration: 300.ms);
  }

  // Avatar builder removed as we no longer show AI icon
  Widget _buildAttachments(List<MessageAttachment> attachments) {
    // Use the reusable AttachmentContent widget
    return AttachmentContent(attachments: attachments);
  }
}
