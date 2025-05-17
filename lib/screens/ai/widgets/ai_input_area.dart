import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_theme.dart';
import 'attachment_preview.dart';
import '../models/chat_message.dart';

class AiInputArea extends StatefulWidget {
  final TextEditingController textController;
  final VoidCallback onAddAttachment;
  final void Function(String) onSubmitted;
  final List<MessageAttachment> pendingAttachments;
  final void Function(MessageAttachment) onRemoveAttachment;

  const AiInputArea({
    super.key,
    required this.textController,
    required this.onAddAttachment,
    required this.onSubmitted,
    required this.pendingAttachments,
    required this.onRemoveAttachment,
  });

  @override
  State<AiInputArea> createState() => _AiInputAreaState();
}

class _AiInputAreaState extends State<AiInputArea>
    with SingleTickerProviderStateMixin {
  bool _isAttachmentOptionsVisible = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleAttachmentOptions() {
    setState(() {
      _isAttachmentOptionsVisible = !_isAttachmentOptionsVisible;
      if (_isAttachmentOptionsVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null && mounted) {
        final attachment = MessageAttachment(
          path: pickedFile.path,
          type: AttachmentType.image,
        );

        setState(() {
          widget.pendingAttachments.add(attachment);
          _toggleAttachmentOptions(); // Hide the options after selection
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  void _shareLocation() {
    // This would normally call a location plugin
    // For this prototype, we'll just use a dummy location
    final attachment = MessageAttachment(
      path: 'assets/map_thumbnail.png',
      type: AttachmentType.location,
      description: 'Current Location',
    );

    setState(() {
      widget.pendingAttachments.add(attachment);
      _toggleAttachmentOptions(); // Hide the options after selection
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
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

          // Expandable attachment options section
          SizeTransition(
            sizeFactor: _animation,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildAttachmentOptions(),
            ),
          ),

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
    if (widget.pendingAttachments.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 100,
      padding: const EdgeInsets.only(bottom: 8),
      child: AttachmentPreview(
        attachments: widget.pendingAttachments,
        onRemove: widget.onRemoveAttachment,
      ),
    );
  }

  Widget _buildAttachmentOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAttachmentOption(
            icon: Icons.photo,
            label: 'Photos',
            color: Colors.purple,
            onTap: () => _pickImage(ImageSource.gallery),
          ),
          _buildAttachmentOption(
            icon: Icons.camera_alt,
            label: 'Camera',
            color: AppTheme.primaryColor,
            onTap: () => _pickImage(ImageSource.camera),
          ),
          _buildAttachmentOption(
            icon: Icons.location_on,
            label: 'Location',
            color: Colors.green,
            onTap: _shareLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color.withOpacity(0.3), width: 1),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.grey[800],
            ),
          ),
        ],
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
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animation,
          color: AppTheme.primaryColor.withOpacity(0.7),
          size: 26,
        ),
        onPressed: _toggleAttachmentOptions,
        tooltip: 'Attachments',
      ),
    );
  }

  Widget _buildTextField(bool isDarkMode) {
    return Expanded(
      child: TextField(
        controller: widget.textController,
        decoration: InputDecoration(
          hintText: 'Ask about travel plans...',
          hintStyle: TextStyle(
            color: isDarkMode
                ? AppTheme.lightText.withOpacity(0.5)
                : AppTheme.darkText.withOpacity(0.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          border: InputBorder.none,
          isDense: true,
        ),
        style: TextStyle(
          color: isDarkMode ? AppTheme.lightText : AppTheme.darkText,
        ),
        onSubmitted: widget.onSubmitted,
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
        onPressed: () => widget.onSubmitted(widget.textController.text),
        splashRadius: 22,
        tooltip: 'Send',
      ),
    );
  }
}
