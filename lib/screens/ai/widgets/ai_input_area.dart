import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'attachment_preview.dart';
import '../models/chat_message.dart';

class AiInputArea extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onAddAttachment;
  final void Function(String) onSubmitted;
  final List<MessageAttachment> pendingAttachments;
  final void Function(MessageAttachment) onRemoveAttachment;

  const AiInputArea({
    Key? key,
    required this.textController,
    required this.onAddAttachment,
    required this.onSubmitted,
    required this.pendingAttachments,
    required this.onRemoveAttachment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 12),
      decoration: BoxDecoration(
        color: scaffoldBg.withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.08)
              : AppTheme.primaryColor.withOpacity(0.13),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAttachmentPreviewSection(),
          Row(
            children: [
              _buildAddAttachmentButton(),
              _buildTextField(isDarkMode),
              _buildSendButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentPreviewSection() {
    if (pendingAttachments.isEmpty) return const SizedBox.shrink();
    
    return Container(
      height: 100,
      padding: const EdgeInsets.only(bottom: 8),
      child: AttachmentPreview(
        attachments: pendingAttachments,
        onRemove: onRemoveAttachment,
      ),
    );
  }

  Widget _buildAddAttachmentButton() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        icon: Icon(Icons.add, 
            color: AppTheme.primaryColor.withOpacity(0.7), size: 26),
        onPressed: onAddAttachment,
        tooltip: 'Add attachment',
      ),
    );
  }

  Widget _buildTextField(bool isDarkMode) {
    return Expanded(
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          hintText: 'Ask about travel plans...',
          hintStyle: TextStyle(
            color: isDarkMode
                ? AppTheme.lightText.withOpacity(0.5)
                : AppTheme.darkText.withOpacity(0.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          border: InputBorder.none,
          isDense: true,
        ),
        style: TextStyle(
          color: isDarkMode ? AppTheme.lightText : AppTheme.darkText,
        ),
        onSubmitted: onSubmitted,
        minLines: 1,
        maxLines: 4,
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.18),
          width: 1,
        ),
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_upward_rounded, 
            color: Colors.white, size: 22),
        onPressed: () => onSubmitted(textController.text),
        splashRadius: 22,
        tooltip: 'Send',
      ),
    );
  }
}