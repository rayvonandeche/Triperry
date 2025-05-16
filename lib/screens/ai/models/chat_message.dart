// Chat message model for AI assistant
import 'package:flutter/foundation.dart';
import 'dart:io';

enum AttachmentType {
  image,
  document,
  location
}

class MessageAttachment {
  final String path;
  final AttachmentType type;
  final String? description;
  
  MessageAttachment({
    required this.path,
    required this.type,
    this.description,
  });
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  final List<MessageAttachment>? attachments;
  
  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.attachments,
  });
  
  bool get hasAttachments => attachments != null && attachments!.isNotEmpty;
}
