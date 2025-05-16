import 'dart:io';
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../models/chat_message.dart';

class AttachmentPreview extends StatelessWidget {
  final List<MessageAttachment> attachments;
  final Function(MessageAttachment) onRemove;

  const AttachmentPreview({
    Key? key,
    required this.attachments,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        itemBuilder: (context, index) {
          final attachment = attachments[index];
          return _buildAttachmentPreview(attachment);
        },
      ),
    );
  }

  Widget _buildAttachmentPreview(MessageAttachment attachment) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: _buildAttachmentContent(attachment),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => onRemove(attachment),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentContent(MessageAttachment attachment) {
    switch (attachment.type) {
      case AttachmentType.image:
        return Image.file(
          File(attachment.path),
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        );
        
      case AttachmentType.location:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_on,
              color: Colors.green,
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              attachment.description ?? 'Location',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
        
      case AttachmentType.document:
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.insert_drive_file,
              color: Colors.blue,
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              attachment.path.split('/').last,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        );
    }
  }
}
