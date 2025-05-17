import 'dart:io';
import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class AttachmentContent extends StatelessWidget {
  final List<MessageAttachment> attachments;
  
  const AttachmentContent({
    super.key,
    required this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < attachments.length; i++) ...[
          _buildAttachment(attachments[i]),
          if (i < attachments.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _buildAttachment(MessageAttachment attachment) {
    switch (attachment.type) {
      case AttachmentType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(attachment.path),
            width: 200,
            height: 150,
            fit: BoxFit.cover,
          ),
        );
        
      case AttachmentType.location:
        return Container(
          height: 120,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Colors.red, size: 40),
              const SizedBox(height: 8),
              Text(
                attachment.description ?? 'Shared location',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
        
      case AttachmentType.document:
      default:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.insert_drive_file, color: Colors.blue, size: 24),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  attachment.path.split('/').last,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
    }
  }
}